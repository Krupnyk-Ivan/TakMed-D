import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/features/march/domain/models/march_step.dart';
import 'package:takmed/features/march/domain/models/march_step_state.dart';
import 'package:takmed/features/march/presentation/bloc/march_bloc.dart';
import 'package:takmed/features/march/presentation/bloc/march_checklist_state.dart';
import 'package:takmed/features/march/presentation/bloc/march_event.dart';

// Шаблон для швидких таймерів у тестах (1 мс замість реального часу)
MarchBloc _fastTimerBloc() =>
    MarchBloc(timerDurationOverride: (_) => const Duration(milliseconds: 1));

// Хелпер: завершити крок (start + complete)
Future<void> _completeStep(MarchBloc bloc, MarchStep step,
    {String? notes}) async {
  bloc.add(MarchStepStartRequested(step));
  await Future<void>.delayed(Duration.zero);
  bloc.add(MarchStepCompletionRequested(step: step, notes: notes));
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('MarchChecklistState', () {
    test('initial() — всі кроки Pending, статус idle', () {
      final s = MarchChecklistState.initial();
      expect(s.overallStatus, MarchOverallStatus.idle);
      expect(s.validationError, isNull);
      for (final step in MarchStep.values) {
        expect(s[step], isA<StepPending>());
      }
    });

    test('initial(maxTimeOverrides) — використовує задані ліміти', () {
      final s = MarchChecklistState.initial(
        maxTimeOverrides: {MarchStep.massiveHemorrhage: 30},
      );
      expect(s[MarchStep.massiveHemorrhage].maxTimeSeconds, 30);
      expect(s[MarchStep.airway].maxTimeSeconds,
          MarchStep.airway.defaultMaxTimeSeconds);
    });

    test('canActivate — M завжди доступний; A — тільки після успіху M', () {
      final s = MarchChecklistState.initial();
      expect(s.canActivate(MarchStep.massiveHemorrhage), isTrue);
      expect(s.canActivate(MarchStep.airway), isFalse);
    });

    test('canComplete — тільки для InProgress кроку з виконаним prereq', () {
      final initial = MarchChecklistState.initial();
      // Немає InProgress — canComplete false
      expect(initial.canComplete(MarchStep.massiveHemorrhage), isFalse);

      // Симулюємо M InProgress
      final inProgress = initial.withStep(
        MarchStep.massiveHemorrhage,
        StepInProgress(
            maxTimeSeconds: 120, startedAt: DateTime.now()),
      );
      expect(inProgress.canComplete(MarchStep.massiveHemorrhage), isTrue);

      // A InProgress але M ще Pending — canComplete false
      final aInProgress = initial.withStep(
        MarchStep.airway,
        StepInProgress(maxTimeSeconds: 60, startedAt: DateTime.now()),
      );
      expect(aInProgress.canComplete(MarchStep.airway), isFalse);
    });

    test('canRollback — можна відкотити тільки якщо наступні Pending/Failed',
        () {
      final s = MarchChecklistState.initial()
          .withStep(
            MarchStep.massiveHemorrhage,
            StepCompleted(
              maxTimeSeconds: 120,
              completedAt: DateTime.now(),
              elapsedSeconds: 30,
            ),
          )
          .withStep(
            MarchStep.airway,
            StepInProgress(maxTimeSeconds: 60, startedAt: DateTime.now()),
          );

      // A in progress → не можна відкотити M
      expect(s.canRollback(MarchStep.massiveHemorrhage), isFalse);
      // A in progress → можна відкотити A (після неї немає активних)
      expect(s.canRollback(MarchStep.airway), isTrue);
    });
  });

  // ─── BLoC ──────────────────────────────────────────────────────────────────

  group('MarchBloc — lifecycle', () {
    blocTest<MarchBloc, MarchChecklistState>(
      'MarchStarted → M переходить у InProgress',
      build: MarchBloc.new,
      act: (b) => b.add(const MarchStarted()),
      expect: () => [
        isA<MarchChecklistState>()
            .having((s) => s.overallStatus, 'status',
                MarchOverallStatus.inProgress)
            .having(
                (s) => s[MarchStep.massiveHemorrhage], 'M', isA<StepInProgress>()),
      ],
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'MarchReset повертає до початкового стану',
      build: MarchBloc.new,
      act: (b) async {
        b.add(const MarchStarted());
        await Future<void>.delayed(Duration.zero);
        b.add(const MarchReset());
      },
      skip: 1, // пропускаємо MarchStarted state
      expect: () => [
        isA<MarchChecklistState>()
            .having((s) => s.overallStatus, 'status', MarchOverallStatus.idle)
            .having((s) => s[MarchStep.massiveHemorrhage], 'M',
                isA<StepPending>()),
      ],
    );
  });

  group('MarchBloc — бізнес-правила (prerequisite)', () {
    blocTest<MarchBloc, MarchChecklistState>(
      'Запуск A до завершення M → validationError, A залишається Pending',
      build: MarchBloc.new,
      act: (b) => b.add(const MarchStepStartRequested(MarchStep.airway)),
      expect: () => [
        isA<MarchChecklistState>()
            .having((s) => s.validationError, 'error', isNotNull)
            .having((s) => s[MarchStep.airway], 'A', isA<StepPending>()),
      ],
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Завершення A якщо M у стані Failed → validationError',
      build: MarchBloc.new,
      act: (b) async {
        // Запускаємо M
        b.add(const MarchStepStartRequested(MarchStep.massiveHemorrhage));
        await Future<void>.delayed(Duration.zero);
        // M fails
        b.add(const MarchStepFailureReported(
            step: MarchStep.massiveHemorrhage,
            reason: 'Кровотечу зупинити неможливо'));
        await Future<void>.delayed(Duration.zero);
        // Намагаємось стартувати A
        b.add(const MarchStepStartRequested(MarchStep.airway));
      },
      verify: (b) {
        expect(b.state.validationError, isNotNull);
        expect(b.state[MarchStep.airway], isA<StepPending>());
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Завершення A після Skip M → дозволено',
      build: MarchBloc.new,
      act: (b) async {
        b.add(const MarchStepSkipRequested(
            step: MarchStep.massiveHemorrhage,
            reason: 'Відсутня кровотеча'));
        await Future<void>.delayed(Duration.zero);
        b.add(const MarchStepStartRequested(MarchStep.airway));
        await Future<void>.delayed(Duration.zero);
        b.add(const MarchStepCompletionRequested(step: MarchStep.airway));
      },
      verify: (b) {
        expect(b.state[MarchStep.massiveHemorrhage], isA<StepSkipped>());
        expect(b.state[MarchStep.airway], isA<StepCompleted>());
        expect(b.state.validationError, isNull);
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Спроба завершити крок не InProgress → validationError',
      build: MarchBloc.new,
      act: (b) => b.add(
          const MarchStepCompletionRequested(step: MarchStep.massiveHemorrhage)),
      expect: () => [
        isA<MarchChecklistState>()
            .having((s) => s.validationError, 'error', isNotNull),
      ],
    );
  });

  group('MarchBloc — таймаут', () {
    blocTest<MarchBloc, MarchChecklistState>(
      'Таймаут крок переходить у StepFailed із повідомленням про таймаут',
      build: _fastTimerBloc,
      act: (b) async {
        b.add(const MarchStepStartRequested(MarchStep.massiveHemorrhage));
        // Чекаємо поки таймер спрацює (1 ms)
        await Future<void>.delayed(const Duration(milliseconds: 20));
      },
      verify: (b) {
        final stepState = b.state[MarchStep.massiveHemorrhage];
        expect(stepState, isA<StepFailed>());
        final failed = stepState as StepFailed;
        expect(failed.reason, contains('Таймаут'));
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Завершення кроку до таймауту скасовує таймер (не emitується Failed)',
      build: _fastTimerBloc,
      act: (b) async {
        b.add(const MarchStepStartRequested(MarchStep.massiveHemorrhage));
        await Future<void>.delayed(Duration.zero);
        // Завершуємо до спрацювання таймера
        b.add(const MarchStepCompletionRequested(
            step: MarchStep.massiveHemorrhage));
        // Чекаємо — таймер вже скасовано
        await Future<void>.delayed(const Duration(milliseconds: 20));
      },
      verify: (b) {
        expect(
            b.state[MarchStep.massiveHemorrhage], isA<StepCompleted>());
      },
    );
  });

  group('MarchBloc — rollback', () {
    blocTest<MarchBloc, MarchChecklistState>(
      'Відкат M коли A Pending → M повертається у Pending',
      build: MarchBloc.new,
      act: (b) async {
        await _completeStep(b, MarchStep.massiveHemorrhage);
        b.add(const MarchRollbackRequested(MarchStep.massiveHemorrhage));
      },
      verify: (b) {
        expect(b.state[MarchStep.massiveHemorrhage], isA<StepPending>());
        expect(b.state.validationError, isNull);
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Відкат M коли A InProgress → validationError, M залишається Completed',
      build: MarchBloc.new,
      act: (b) async {
        await _completeStep(b, MarchStep.massiveHemorrhage);
        b.add(const MarchStepStartRequested(MarchStep.airway));
        await Future<void>.delayed(Duration.zero);
        b.add(const MarchRollbackRequested(MarchStep.massiveHemorrhage));
      },
      verify: (b) {
        expect(b.state.validationError, isNotNull);
        expect(b.state[MarchStep.massiveHemorrhage], isA<StepCompleted>());
        expect(b.state[MarchStep.airway], isA<StepInProgress>());
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Відкат також скидає наступні кроки у Pending',
      build: MarchBloc.new,
      act: (b) async {
        await _completeStep(b, MarchStep.massiveHemorrhage);
        await _completeStep(b, MarchStep.airway);
        // Відкат A — має скинути R, C, H теж
        b.add(const MarchRollbackRequested(MarchStep.airway));
      },
      verify: (b) {
        expect(b.state[MarchStep.airway], isA<StepPending>());
        expect(b.state[MarchStep.respiration], isA<StepPending>());
        expect(b.state[MarchStep.circulation], isA<StepPending>());
        expect(b.state[MarchStep.hypothermia], isA<StepPending>());
        // M залишається Completed
        expect(b.state[MarchStep.massiveHemorrhage], isA<StepCompleted>());
      },
    );
  });

  group('MarchBloc — повний протокол', () {
    blocTest<MarchBloc, MarchChecklistState>(
      'Виконання всіх 5 кроків → status completed, isComplete true',
      build: MarchBloc.new,
      act: (b) async {
        for (final step in MarchStep.values) {
          await _completeStep(b, step);
        }
      },
      verify: (b) {
        expect(b.state.overallStatus, MarchOverallStatus.completed);
        expect(b.state.isComplete, isTrue);
        expect(b.state.validationError, isNull);
        for (final step in MarchStep.values) {
          expect(b.state[step], isA<StepCompleted>());
        }
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Провал M → partiallyFailed; протокол продовжувати неможливо без Skip/Complete',
      build: MarchBloc.new,
      act: (b) async {
        b.add(const MarchStepStartRequested(MarchStep.massiveHemorrhage));
        await Future<void>.delayed(Duration.zero);
        b.add(const MarchStepFailureReported(
            step: MarchStep.massiveHemorrhage,
            reason: 'Ампутація, турнікет не допоміг'));
        await Future<void>.delayed(Duration.zero);
        // Спроба стартувати A — блокована
        b.add(const MarchStepStartRequested(MarchStep.airway));
      },
      verify: (b) {
        expect(b.state.overallStatus, MarchOverallStatus.partiallyFailed);
        expect(b.state[MarchStep.airway], isA<StepPending>());
        expect(b.state.validationError, isNotNull);
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Skip M → можна продовжити та завершити повний протокол',
      build: MarchBloc.new,
      act: (b) async {
        b.add(const MarchStepSkipRequested(
            step: MarchStep.massiveHemorrhage,
            reason: 'Відсутність кровотечі'));
        await Future<void>.delayed(Duration.zero);
        for (final step in MarchStep.values.skip(1)) {
          await _completeStep(b, step);
        }
      },
      verify: (b) {
        expect(b.state.overallStatus, MarchOverallStatus.completed);
        expect(b.state.isComplete, isTrue);
        expect(b.state[MarchStep.massiveHemorrhage], isA<StepSkipped>());
      },
    );

    blocTest<MarchBloc, MarchChecklistState>(
      'Завершений крок зберігає elapsedSeconds та notes',
      build: MarchBloc.new,
      act: (b) async {
        b.add(const MarchStepStartRequested(MarchStep.massiveHemorrhage));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        b.add(const MarchStepCompletionRequested(
            step: MarchStep.massiveHemorrhage,
            notes: 'CAT накладено на ліве плече'));
      },
      verify: (b) {
        final completed =
            b.state[MarchStep.massiveHemorrhage] as StepCompleted;
        expect(completed.notes, 'CAT накладено на ліве плече');
        expect(completed.elapsedSeconds, greaterThanOrEqualTo(0));
      },
    );
  });
}
