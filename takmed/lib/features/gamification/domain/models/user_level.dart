enum UserLevel {
  recruit(0, 'Рекрут', 0),         // 0–100 XP
  private(1, 'Рядовий', 100),       // 100–300 XP
  corporal(2, 'Єфрейтор', 300),     // 300–700 XP
  sergeant(3, 'Сержант', 700),      // 700–1500 XP
  medic(4, 'Медик', 1500),          // 1500–3000 XP
  tacmedSpecialist(5, 'Спеціаліст тактмеду', 3000); // 3000+ XP

  final int id;
  final String title;
  final int minXp;

  const UserLevel(this.id, this.title, this.minXp);

  /// Повертає рівень на основі кількості XP
  static UserLevel getLevelForXp(int xp) {
    if (xp >= tacmedSpecialist.minXp) return tacmedSpecialist;
    if (xp >= medic.minXp) return medic;
    if (xp >= sergeant.minXp) return sergeant;
    if (xp >= corporal.minXp) return corporal;
    if (xp >= private.minXp) return private;
    return recruit;
  }

  /// Повертає наступний рівень або null, якщо це максимальний рівень
  UserLevel? get nextLevel {
    if (this == tacmedSpecialist) return null;
    return UserLevel.values[id + 1];
  }
}
