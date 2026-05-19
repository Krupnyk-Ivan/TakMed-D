import 'package:equatable/equatable.dart';
import '../../domain/entities/march_quiz_question.dart';
import '../../domain/entities/march_session.dart';

enum MarchEducationalStatus {
  initial,
  running,
  quizActive,
  quizFailed,
  finished,
  saving,
  saved,
}

class MarchEducationalState extends Equatable {
  const MarchEducationalState({
    this.status = MarchEducationalStatus.initial,
    this.session,
    this.hintExpanded = false,
    this.activeQuiz,
    this.selectedQuizIndex,
    this.totalXpAwarded = 0,
    this.errorMessage,
  });

  final MarchEducationalStatus status;
  final MarchSession? session;
  final bool hintExpanded;

  /// Питання, яке зараз відкрите у мікро-квізі (null коли quiz закритий).
  final MarchQuizQuestion? activeQuiz;

  /// Який варіант обраний (для UI підсвічування).
  final int? selectedQuizIndex;

  /// Сумарно нараховано XP (для анімації на result-екрані).
  final int totalXpAwarded;

  final String? errorMessage;

  MarchEducationalState copyWith({
    MarchEducationalStatus? status,
    MarchSession? session,
    bool? hintExpanded,
    MarchQuizQuestion? activeQuiz,
    int? selectedQuizIndex,
    int? totalXpAwarded,
    String? errorMessage,
    bool clearQuiz = false,
    bool clearSelected = false,
    bool clearError = false,
  }) {
    return MarchEducationalState(
      status: status ?? this.status,
      session: session ?? this.session,
      hintExpanded: hintExpanded ?? this.hintExpanded,
      activeQuiz: clearQuiz ? null : (activeQuiz ?? this.activeQuiz),
      selectedQuizIndex:
          clearSelected ? null : (selectedQuizIndex ?? this.selectedQuizIndex),
      totalXpAwarded: totalXpAwarded ?? this.totalXpAwarded,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        session,
        hintExpanded,
        activeQuiz,
        selectedQuizIndex,
        totalXpAwarded,
        errorMessage,
      ];
}
