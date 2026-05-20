import 'package:equatable/equatable.dart';
import '../../../march/domain/models/march_step.dart';
import 'march_item.dart';

/// Освітня тренувальна сесія MARCH.
class MarchSession extends Equatable {
  const MarchSession({
    required this.startedAt,
    required this.items,
    this.endedAt,
  });

  final DateTime startedAt;
  final DateTime? endedAt;
  final List<MarchItem> items;

  factory MarchSession.fresh({DateTime? startedAt}) {
    final start = startedAt ?? DateTime.now();
    final list = MarchStep.values
        .map((s) => MarchItem(
              step: s,
              status: s == MarchStep.massiveHemorrhage
                  ? MarchItemStatus.active
                  : MarchItemStatus.locked,
            ))
        .toList();
    return MarchSession(startedAt: start, items: list);
  }

  /// Індекс активного кроку, або -1 коли все завершено.
  int get activeIndex => items.indexWhere((it) => it.status == MarchItemStatus.active);

  MarchItem? get activeItem {
    final i = activeIndex;
    return i == -1 ? null : items[i];
  }

  bool get isCompleted =>
      items.every((it) =>
          it.status == MarchItemStatus.completed ||
          it.status == MarchItemStatus.failedQuiz);

  /// Загальний час сесії в секундах.
  int get totalDurationSeconds {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt).inSeconds;
  }

  /// % успішності — частка кроків з правильним quiz від загальної кількості кроків.
  int get successRatePercent {
    if (items.isEmpty) return 0;
    final correct = items.where((it) => it.quizAnsweredCorrectly == true).length;
    return (correct * 100 / items.length).round();
  }

  /// Слабкі теми (за timeExceeded або failed quiz).
  List<MarchStep> get weakSpots =>
      items.where((it) => it.isWeakSpot).map((it) => it.step).toList();

  MarchSession copyWith({
    List<MarchItem>? items,
    DateTime? endedAt,
  }) {
    return MarchSession(
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [startedAt, endedAt, items];
}
