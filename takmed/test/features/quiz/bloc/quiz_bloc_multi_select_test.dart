import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takmed/features/quiz/data/repositories/quiz_repository.dart';
import 'package:takmed/features/quiz/domain/entities/answer_option.dart';
import 'package:takmed/features/quiz/domain/entities/quiz_question.dart';
import 'package:takmed/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:takmed/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:takmed/features/quiz/presentation/bloc/quiz_state.dart';
import 'package:takmed/core/database/daos/progress_dao.dart';
import 'package:takmed/core/database/daos/quiz_attempt_dao.dart';

@GenerateMocks([QuizRepository, ProgressDao, QuizAttemptDao, SupabaseClient, GoTrueClient])
import 'quiz_bloc_multi_select_test.mocks.dart';

// Хелпер для створення multi-select питання
QuizQuestion makeMultiSelect({
  String id = 'q1',
  List<String> correctIds = const ['opt_0', 'opt_2'],
}) =>
    QuizQuestion.multiSelect(
      id: id,
      text: 'Що входить до протоколу MARCH?',
      options: const [
        AnswerOption(id: 'opt_0', text: 'Massive hemorrhage'),
        AnswerOption(id: 'opt_1', text: 'Diagnosis'),
        AnswerOption(id: 'opt_2', text: 'Airway'),
      ],
      correctIds: correctIds,
      explanation: 'M і A — частини MARCH',
    );

void main() {
  late MockQuizRepository mockRepository;
  late MockProgressDao mockProgressDao;
  late MockQuizAttemptDao mockAttemptDao;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockRepository = MockQuizRepository();
    mockProgressDao = MockProgressDao();
    mockAttemptDao = MockQuizAttemptDao();
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(mockSupabase.auth).thenReturn(mockAuth);
    when(mockAuth.currentUser).thenReturn(null);
  });

  QuizBloc buildBloc() => QuizBloc(
        mockRepository,
        mockProgressDao,
        mockAttemptDao,
        mockSupabase,
      );

  group('MultiSelectToggled', () {
    blocTest<QuizBloc, QuizState>(
      'додає id до pendingSelectedIds',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect()],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const [],
      ),
      act: (bloc) => bloc.add(const MultiSelectToggled('opt_0')),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.pendingSelectedIds,
          'pendingSelectedIds',
          contains('opt_0'),
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'прибирає id якщо вже вибраний',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect()],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0'],
      ),
      act: (bloc) => bloc.add(const MultiSelectToggled('opt_0')),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.pendingSelectedIds,
          'pendingSelectedIds',
          isNot(contains('opt_0')),
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'дозволяє вибрати кілька варіантів',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect()],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0'],
      ),
      act: (bloc) => bloc.add(const MultiSelectToggled('opt_2')),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.pendingSelectedIds,
          'pendingSelectedIds',
          containsAll(['opt_0', 'opt_2']),
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'ігнорує toggle якщо стан не QuizInProgress',
      build: buildBloc,
      seed: () => const QuizInitial(),
      act: (bloc) => bloc.add(const MultiSelectToggled('opt_0')),
      expect: () => <QuizState>[],
    );
  });

  group('SubmitMultiSelect', () {
    blocTest<QuizBloc, QuizState>(
      'правильна відповідь — isCorrect=true, +10 балів',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect(correctIds: ['opt_0', 'opt_2'])],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0', 'opt_2'],
      ),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => [
        isA<QuizAnswered>()
            .having((s) => s.isCorrect, 'isCorrect', true)
            .having((s) => s.progressState.score, 'score', 10),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'неповна відповідь (тільки один з двох) — isCorrect=false',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect(correctIds: ['opt_0', 'opt_2'])],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0'],
      ),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => [
        isA<QuizAnswered>().having((s) => s.isCorrect, 'isCorrect', false),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'зайвий варіант (правильний + неправильний) — isCorrect=false',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect(correctIds: ['opt_0', 'opt_2'])],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0', 'opt_1', 'opt_2'],
      ),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => [
        isA<QuizAnswered>().having((s) => s.isCorrect, 'isCorrect', false),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'порядок вибору не має значення — isCorrect=true',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect(correctIds: ['opt_0', 'opt_2'])],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_2', 'opt_0'],
      ),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => [
        isA<QuizAnswered>().having((s) => s.isCorrect, 'isCorrect', true),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'після submit selectedAnswerIds містить вибрані id',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect(correctIds: ['opt_0', 'opt_2'])],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0', 'opt_2'],
      ),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => [
        isA<QuizAnswered>().having(
          (s) => s.selectedAnswerIds,
          'selectedAnswerIds',
          containsAll(['opt_0', 'opt_2']),
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'після submit pendingSelectedIds скидається до порожнього',
      build: buildBloc,
      seed: () => QuizInProgress(
        questions: [makeMultiSelect(correctIds: ['opt_0', 'opt_2'])],
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        pendingSelectedIds: const ['opt_0', 'opt_2'],
      ),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => [
        isA<QuizAnswered>().having(
          (s) => s.progressState.pendingSelectedIds,
          'pendingSelectedIds',
          isEmpty,
        ),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'ігнорує submit якщо стан не QuizInProgress',
      build: buildBloc,
      seed: () => const QuizInitial(),
      act: (bloc) => bloc.add(const SubmitMultiSelect()),
      expect: () => <QuizState>[],
    );
  });
}
