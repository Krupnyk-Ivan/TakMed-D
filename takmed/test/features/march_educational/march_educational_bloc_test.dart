import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/march/domain/models/march_step.dart';
import 'package:takmed/features/march_educational/domain/entities/march_item.dart';
import 'package:takmed/features/march_educational/domain/repositories/march_repository.dart';
import 'package:takmed/features/march_educational/presentation/bloc/march_educational_bloc.dart';
import 'package:takmed/features/march_educational/presentation/bloc/march_educational_event.dart';
import 'package:takmed/features/march_educational/presentation/bloc/march_educational_state.dart';

import 'march_educational_bloc_test.mocks.dart';

@GenerateMocks([MarchRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockMarchRepository mockRepo;
  late GamificationService gamification;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    gamification = GamificationService(prefs);
    mockRepo = MockMarchRepository();
    when(mockRepo.saveSession(any))
        .thenAnswer((_) async => const Right(1));
  });

  MarchEducationalBloc buildBloc() =>
      MarchEducationalBloc(mockRepo, gamification);

  group('MarchSessionStarted', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'створює свіжу сесію з активним M',
      build: buildBloc,
      act: (bloc) => bloc.add(const MarchSessionStarted()),
      expect: () => [
        isA<MarchEducationalState>()
            .having((s) => s.status, 'status', MarchEducationalStatus.running)
            .having((s) => s.session?.items.first.step,
                'first step', MarchStep.massiveHemorrhage)
            .having((s) => s.session?.items.first.status,
                'first.status', MarchItemStatus.active)
            .having((s) => s.session?.items[1].status,
                'second.status', MarchItemStatus.locked),
      ],
    );
  });

  group('MarchHintToggled', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'переключає hintExpanded',
      build: buildBloc,
      seed: () => const MarchEducationalState(),
      act: (bloc) => bloc.add(const MarchHintToggled()),
      expect: () => [
        isA<MarchEducationalState>().having((s) => s.hintExpanded, 'hint', true),
      ],
    );
  });

  group('MarchStepCompleteRequested', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'відкриває quiz для активного кроку',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const MarchSessionStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const MarchStepCompleteRequested());
      },
      skip: 1, // running після start
      expect: () => [
        isA<MarchEducationalState>()
            .having((s) => s.status, 'status', MarchEducationalStatus.quizActive)
            .having((s) => s.activeQuiz?.step, 'quiz.step',
                MarchStep.massiveHemorrhage),
      ],
    );
  });

  group('MarchQuizAnswered', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'правильна відповідь → completed + наступний крок активний + XP',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const MarchSessionStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const MarchStepCompleteRequested());
        await Future<void>.delayed(Duration.zero);
        // Правильна відповідь для М — індекс 0
        bloc.add(const MarchQuizAnswered(0));
      },
      skip: 2, // running + quizActive
      expect: () => [
        isA<MarchEducationalState>()
            .having((s) => s.status, 'status', MarchEducationalStatus.running)
            .having((s) => s.session?.items[0].status,
                'M.status', MarchItemStatus.completed)
            .having((s) => s.session?.items[0].quizAnsweredCorrectly,
                'M.correct', true)
            .having((s) => s.session?.items[1].status,
                'A.status', MarchItemStatus.active)
            .having((s) => s.totalXpAwarded, 'XP', 20)
            .having((s) => s.activeQuiz, 'quiz closed', isNull),
      ],
      verify: (_) {
        expect(gamification.getTotalXp(), 20);
      },
    );

    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'неправильна відповідь → quizFailed + retry-можливість',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const MarchSessionStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const MarchStepCompleteRequested());
        await Future<void>.delayed(Duration.zero);
        // Невірна відповідь (всі некоректні крім 0)
        bloc.add(const MarchQuizAnswered(2));
      },
      skip: 2,
      expect: () => [
        isA<MarchEducationalState>()
            .having((s) => s.status, 'status', MarchEducationalStatus.quizFailed)
            .having((s) => s.session?.items[0].status,
                'M.status', MarchItemStatus.failedQuiz)
            .having((s) => s.selectedQuizIndex, 'selected', 2)
            .having((s) => s.session?.items[0].quizAttempts, 'attempts', 1)
            // XP не нараховано
            .having((s) => s.totalXpAwarded, 'XP', 0),
      ],
    );
  });

  group('MarchQuizDismissAfterFailure', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'після failedQuiz переходить на наступний крок без XP',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const MarchSessionStarted());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const MarchStepCompleteRequested());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const MarchQuizAnswered(2));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const MarchQuizDismissAfterFailure());
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      verify: (bloc) {
        final state = bloc.state;
        expect(state.status, MarchEducationalStatus.running);
        expect(state.session?.items[0].status, MarchItemStatus.failedQuiz);
        expect(state.session?.items[1].status, MarchItemStatus.active);
        expect(state.activeQuiz, isNull);
        expect(state.totalXpAwarded, 0);
      },
    );
  });
}
