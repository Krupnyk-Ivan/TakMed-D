import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takmed/features/gamification/data/services/streak_service.dart';

void main() {
  late SharedPreferences prefs;
  late StreakService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    service = StreakService(prefs);
  });

  /// Допоміжна функція — встановлює lastActivity на конкретний день (00:00)
  Future<void> setLastActivity(DateTime date) async {
    await prefs.setString('streak_last_activity', date.toIso8601String());
  }

  Future<void> setStreak(int current, int best) async {
    await prefs.setInt('streak_current', current);
    await prefs.setInt('streak_best', best);
  }

  group('StreakService', () {
    test('1. Перша активність встановлює streak=1, bestStreak=1', () async {
      final increased = await service.registerActivity();

      expect(increased, isTrue);
      expect(service.getCurrentStreak(), 1);
      expect(service.getBestStreak(), 1);
    });

    test('2. Активність того ж дня не збільшує streak', () async {
      // Перша активність сьогодні
      await service.registerActivity();
      expect(service.getCurrentStreak(), 1);

      // Знову сьогодні — streak не змінюється
      final increased = await service.registerActivity();

      expect(increased, isFalse);
      expect(service.getCurrentStreak(), 1);
    });

    test('3. Активність наступного дня збільшує streak до 2', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await setLastActivity(DateTime(yesterday.year, yesterday.month, yesterday.day));
      await setStreak(1, 1);

      final increased = await service.registerActivity();

      expect(increased, isTrue);
      expect(service.getCurrentStreak(), 2);
      expect(service.getBestStreak(), 2);
    });

    test('4. Пропуск 2 днів без заморозки скидає streak до 1', () async {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      await setLastActivity(DateTime(twoDaysAgo.year, twoDaysAgo.month, twoDaysAgo.day));
      await setStreak(5, 5);
      // Заморозок немає

      final increased = await service.registerActivity();

      expect(increased, isTrue); // streak зростає з 0 до 1
      expect(service.getCurrentStreak(), 1);
      expect(service.getBestStreak(), 5); // bestStreak зберігається
    });

    test('5. Пропуск 1 дня із заморозкою зберігає streak', () async {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      await setLastActivity(DateTime(twoDaysAgo.year, twoDaysAgo.month, twoDaysAgo.day));
      await setStreak(7, 7);
      // Дати 1 заморозку
      await prefs.setInt('streak_freezes_available', 1);

      await service.registerActivity();

      // streak має зберегтись (checkStreak використав заморозку)
      expect(service.getCurrentStreak(), greaterThanOrEqualTo(7));
      expect(service.getFreezesAvailable(), 0);
    });

    test('6. Streak кратний 7 дає +1 заморозку', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await setLastActivity(DateTime(yesterday.year, yesterday.month, yesterday.day));
      await setStreak(6, 6); // наступна активність = 7
      await prefs.setInt('streak_freezes_available', 0);

      await service.registerActivity();

      expect(service.getCurrentStreak(), 7);
      expect(service.getFreezesAvailable(), 1);
    });

    test('7. bestStreak правильно відстежує максимальний streak', () async {
      // Симулюємо streak 3, bestStreak 10
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await setLastActivity(DateTime(yesterday.year, yesterday.month, yesterday.day));
      await setStreak(3, 10);

      await service.registerActivity();

      expect(service.getCurrentStreak(), 4);
      expect(service.getBestStreak(), 10); // bestStreak не змінився
    });

    test('8. Midnight edge case: активність 23:50 вчора, потім 00:05 сьогодні = різні дні → streak зростає', () async {
      final now = DateTime.now();
      final todayMidnight = DateTime(now.year, now.month, now.day);
      // "Вчора" = 23:50 попереднього дня
      final yesterday2350 = todayMidnight.subtract(const Duration(minutes: 10));

      await setLastActivity(yesterday2350);
      await setStreak(1, 1);

      // registerActivity() викликається "сьогодні о 00:05" (мокаємо через today)
      // StreakService порівнює по даті (рік/місяць/день), тому 23:50 вчора ≠ сьогодні
      final increased = await service.registerActivity();

      expect(increased, isTrue);
      expect(service.getCurrentStreak(), 2);
    });
  });
}
