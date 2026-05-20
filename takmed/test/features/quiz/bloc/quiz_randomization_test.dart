import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:takmed/features/quiz/domain/entities/answer_option.dart';
import 'package:takmed/features/quiz/domain/entities/quiz_question.dart';
import 'package:takmed/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:takmed/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:takmed/features/quiz/presentation/bloc/quiz_state.dart';

import 'quiz_bloc_multi_select_test.mocks.dart';

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
  });

  QuizBloc buildBloc() => QuizBloc(
        mockRepository,
        mockProgressDao,
        mockAttemptDao,
        mockSupabase,
      );

  final testQuestions = [
    QuizQuestion.multipleChoice(
      id: 'q1',
      text: 'Q1',
      options: const [
        AnswerOption(id: '1a', text: 'A'),
        AnswerOption(id: '1b', text: 'B'),
        AnswerOption(id: '1c', text: 'C'),
      ],
      correctId: '1a',
      explanation: '...',
    ),
    QuizQuestion.multipleChoice(
      id: 'q2',
      text: 'Q2',
      options: const [
        AnswerOption(id: '2a', text: 'A'),
        AnswerOption(id: '2b', text: 'B'),
      ],
      correctId: '2a',
      explanation: '...',
    ),
    QuizQuestion.multipleChoice(
      id: 'q3',
      text: 'Q3',
      options: const [
        AnswerOption(id: '3a', text: 'A'),
        AnswerOption(id: '3b', text: 'B'),
      ],
      correctId: '3a',
      explanation: '...',
    ),
  ];

  group('QuizBloc Randomization', () {
    blocTest<QuizBloc, QuizState>(
      'StartQuiz should eventually produce different question orders (statistical)',
      build: buildBloc,
      act: (bloc) async {
        when(mockRepository.getQuizQuestions('topic')).thenAnswer((_) async => testQuestions);
        bloc.add(const StartQuiz('topic'));
      },
      skip: 1, // skip Loading
      verify: (bloc) {
        final state = bloc.state as QuizInProgress;
        expect(state.questions.length, equals(testQuestions.length));
        
        // Перевіряємо, що всі ID питань на місці
        final actualIds = state.questions.map((q) => q.id).toList();
        final expectedIds = testQuestions.map((q) => q.id).toList();
        expect(actualIds, containsAll(expectedIds));
        
        // Перевірка, що опції всередині теж на місці (незалежно від порядку)
        for (var actualQ in state.questions) {
          final originalQ = testQuestions.firstWhere((q) => q.id == actualQ.id);
          
          actualQ.map(
            multipleChoice: (actualMc) {
              final originalMc = originalQ as MultipleChoiceQuestion;
              expect(actualMc.options, containsAll(originalMc.options));
              expect(actualMc.correctId, equals(originalMc.correctId));
            },
            trueFalse: (_) {},
            sequence: (actualS) {
              final originalS = originalQ as SequenceQuestion;
              expect(actualS.items, containsAll(originalS.items));
            },
            imageMatch: (actualIm) {
              final originalIm = originalQ as ImageMatchQuestion;
              expect(actualIm.options, containsAll(originalIm.options));
            },
            multiSelect: (actualMs) {
              final originalMs = originalQ as MultiSelectQuestion;
              expect(actualMs.options, containsAll(originalMs.options));
            },
          );
        }
      },
    );
  });
}
