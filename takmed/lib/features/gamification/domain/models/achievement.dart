import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      icon: icon,
      title: title,
      description: description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [id, isUnlocked, unlockedAt];
}

/// Перелік усіх 15 доступних значків
final List<Achievement> allAchievements = [
  const Achievement(id: 'first_lesson', icon: '🎯', title: 'Перший крок', description: 'Пройди перший урок'),
  const Achievement(id: 'streak_3', icon: '🔥', title: 'Іскра', description: '3 дні поспіль'),
  const Achievement(id: 'streak_7', icon: '🔥', title: 'Тиждень вогню', description: '7 днів поспіль'),
  const Achievement(id: 'streak_30', icon: '💪', title: 'Місяць сталі', description: '30 днів поспіль'),
  const Achievement(id: 'perfect_quiz', icon: '⭐', title: 'Відмінник', description: '100% правильних відповідей у вікторині'),
  const Achievement(id: 'march_complete', icon: '🩺', title: 'Знаю MARCH', description: 'Завершити модуль MARCH'),
  const Achievement(id: 'tourniquet_master', icon: '🦾', title: 'Майстер турнікету', description: 'Завершити модуль турнікетів'),
  const Achievement(id: 'chest_seal_pro', icon: '🫁', title: 'Врятоване дихання', description: 'Завершити модуль Chest Seals'),
  const Achievement(id: 'offline_warrior', icon: '📡', title: 'Польовий боєць', description: 'Пройти урок без підключення до інтернету'),
  const Achievement(id: 'speed_demon', icon: '⚡', title: 'Блискавка', description: 'Відповісти на 10 питань < 5 сек кожне'),
  const Achievement(id: 'first_quiz', icon: '📝', title: 'Перший іспит', description: 'Пройди свою першу вікторину'),
  const Achievement(id: 'knowledge_seeker', icon: '🧠', title: 'Шукач знань', description: 'Пройти 5 уроків'),
  const Achievement(id: 'cpr_expert', icon: '❤️', title: 'Експерт СЛР', description: 'Пройти чеклист по СЛР'),
  const Achievement(id: 'veteran', icon: '🎖️', title: 'Ветеран', description: 'Пройти всі доступні курси'),
  const Achievement(id: 'night_owl', icon: '🦉', title: 'Нічна сова', description: 'Пройти урок після 22:00'),
];
