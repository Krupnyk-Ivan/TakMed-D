import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../../../core/database/daos/progress_dao.dart';
import '../../../../core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;
  final ProgressDao _progressDao;

  QuizBloc(this._repository, this._progressDao) : super(const QuizInitial()) {
    on<StartQuiz>(_onStartQuiz);
    on<AnswerSelected>(_onAnswerSelected);
    on<SequenceReordered>(_onSequenceReordered);
    on<NextQuestion>(_onNextQuestion);
    on<RetryQuiz>(_onRetryQuiz);
  }

  DateTime? _questionStartTime;
  List<String>? _currentSequenceOrder;

  Future<void> _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) async {
    emit(const QuizLoading());
    try {
      final questions = await _repository.getQuizQuestions(event.topicId);
      if (questions.isEmpty) {
        emit(const QuizError('Немає питань для цього тесту.'));
        return;
      }
      _questionStartTime = DateTime.now();
      emit(QuizInProgress(
        questions: questions,
        currentIndex: 0,
        score: 0,
        weakTopics: const [],
        fastAnswerCount: 0,
      ));
    } catch (e) {
      emit(QuizError('Помилка завантаження тесту: $e'));
    }
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<QuizState> emit) {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;
    final question = currentState.currentQuestion;

    bool isCorrect = false;

    question.map(
      multipleChoice: (q) {
        isCorrect = event.answerId == q.correctId;
      },
      trueFalse: (q) {
        isCorrect = event.answerId == q.correctAnswer.toString();
      },
      sequence: (q) {
        if (event.answerId == 'submit_sequence') {
          final correctOrderIds = q.items.toList()
            ..sort((a, b) => a.correctIndex.compareTo(b.correctIndex));
          final correctIds = correctOrderIds.map((e) => e.id).toList();
          final userOrder = _currentSequenceOrder ?? q.items.map((e) => e.id).toList();
          isCorrect = _listEquals(userOrder, correctIds);
        }
      },
      imageMatch: (q) {
        isCorrect = event.answerId == q.correctId;
      },
    );

    if (event.answerId == 'submit_sequence' ||
        question.maybeMap(sequence: (_) => false, orElse: () => true)) {
      _handleAnswer(isCorrect, event.answerId, currentState, emit);
    }
  }

  void _onSequenceReordered(SequenceReordered event, Emitter<QuizState> emit) {
    _currentSequenceOrder = event.reorderedItemIds;
  }

  void _handleAnswer(
    bool isCorrect,
    String selectedAnswerId,
    QuizInProgress currentState,
    Emitter<QuizState> emit,
  ) {
    int newScore = currentState.score;
    List<String> newWeakTopics = List.from(currentState.weakTopics);
    int newFastAnswerCount = currentState.fastAnswerCount;

    if (isCorrect) {
      newScore += 10;
      // Відстежуємо швидкі відповіді (< 5 секунд)
      final elapsed = _questionStartTime == null
          ? 999
          : DateTime.now().difference(_questionStartTime!).inSeconds;
      if (elapsed < 5) newFastAnswerCount++;
    } else {
      for (var tag in currentState.currentQuestion.tags) {
        if (!newWeakTopics.contains(tag)) newWeakTopics.add(tag);
      }
    }

    emit(QuizAnswered(
      progressState: currentState.copyWith(
        score: newScore,
        weakTopics: newWeakTopics,
        fastAnswerCount: newFastAnswerCount,
      ),
      isCorrect: isCorrect,
      selectedAnswerId: selectedAnswerId,
    ));
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _onNextQuestion(
    NextQuestion event,
    Emitter<QuizState> emit,
  ) async {
    _currentSequenceOrder = null;
    _questionStartTime = DateTime.now(); // reset timer for next question
    if (state is! QuizAnswered) return;
    final answeredState = state as QuizAnswered;
    final progressState = answeredState.progressState;

    if (progressState.currentIndex + 1 < progressState.questions.length) {
      emit(progressState.copyWith(currentIndex: progressState.currentIndex + 1));
    } else {
      final finalState = QuizCompleted(
        totalQuestions: progressState.questions.length,
        correctAnswers: progressState.score ~/ 10,
        earnedXp: progressState.score,
        weakTopics: progressState.weakTopics,
        fastAnswerCount: progressState.fastAnswerCount,
      );

      emit(finalState);

      try {
        await _progressDao.saveProgress(
          UserProgressCompanion(
            lessonRemoteId: const drift.Value('quiz_session'),
            score: drift.Value(progressState.score),
            attempts: const drift.Value(1),
            completedAt: drift.Value(DateTime.now()),
            weakTopics: drift.Value(jsonEncode(progressState.weakTopics)),
          ),
        );
      } catch (_) {}
    }
  }

  void _onRetryQuiz(RetryQuiz event, Emitter<QuizState> emit) {
    add(StartQuiz(event.topicId));
  }
}
