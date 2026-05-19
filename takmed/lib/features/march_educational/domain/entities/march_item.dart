import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../march/domain/models/march_step.dart';

part 'march_item.freezed.dart';

enum MarchItemStatus { locked, active, completed, failedQuiz }

@freezed
class MarchItem with _$MarchItem {
  const factory MarchItem({
    required MarchStep step,
    @Default(MarchItemStatus.locked) MarchItemStatus status,
    @Default(0) int elapsedSeconds,
    @Default(0) int quizAttempts,
    bool? quizAnsweredCorrectly,
  }) = _MarchItem;

  const MarchItem._();

  /// Перевищили рекомендований час (для analytics).
  bool get timeExceeded =>
      elapsedSeconds > step.defaultMaxTimeSeconds;

  /// Сильно перевищили (>150% — слабка тема за часом).
  bool get heavilyOverTime =>
      elapsedSeconds > (step.defaultMaxTimeSeconds * 1.5).round();

  bool get isWeakSpot =>
      heavilyOverTime || (quizAnsweredCorrectly == false);
}
