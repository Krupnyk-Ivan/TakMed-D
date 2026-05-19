import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takmed/features/gamification/data/services/achievement_service.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/gamification/domain/models/achievement.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<AchievementService> makeService() async {
    final prefs = await SharedPreferences.getInstance();
    return AchievementService(prefs);
  }

  Future<GamificationService> makeGamificationService() async {
    final prefs = await SharedPreferences.getInstance();
    return GamificationService(prefs);
  }

  group('allAchievements', () {
    test('містить рівно 15 досягнень', () {
      expect(allAchievements.length, 15);
    });

    test('всі id унікальні', () {
      final ids = allAchievements.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('кожне досягнення має непорожні icon, title, description', () {
      for (final a in allAchievements) {
        expect(a.icon, isNotEmpty, reason: 'icon порожній для ${a.id}');
        expect(a.title, isNotEmpty, reason: 'title порожній для ${a.id}');
        expect(a.description, isNotEmpty, reason: 'description порожній для ${a.id}');
      }
    });

    test('всі очікувані id присутні', () {
      final ids = allAchievements.map((a) => a.id).toSet();
      const expected = {
        'first_lesson', 'streak_3', 'streak_7', 'streak_30',
        'perfect_quiz', 'march_complete', 'tourniquet_master',
        'chest_seal_pro', 'offline_warrior', 'speed_demon',
        'first_quiz', 'knowledge_seeker', 'cpr_expert',
        'veteran', 'night_owl',
      };
      expect(ids, equals(expected));
    });
  });

  group('AchievementService.unlockAchievement', () {
    test('повертає true при першому розблокуванні', () async {
      final svc = await makeService();
      final result = await svc.unlockAchievement('first_lesson');
      expect(result, isTrue);
    });

    test('повертає false якщо вже розблоковано', () async {
      final svc = await makeService();
      await svc.unlockAchievement('first_lesson');
      final result = await svc.unlockAchievement('first_lesson');
      expect(result, isFalse);
    });

    test('зберігає дату розблокування', () async {
      final svc = await makeService();
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      await svc.unlockAchievement('streak_3');
      final unlocked = svc.getUnlockedAchievements();
      expect(unlocked['streak_3']!.isAfter(before), isTrue);
    });

    test('незалежно розблоковує кілька досягнень', () async {
      final svc = await makeService();
      await svc.unlockAchievement('first_lesson');
      await svc.unlockAchievement('streak_3');
      await svc.unlockAchievement('perfect_quiz');
      final unlocked = svc.getUnlockedAchievements();
      expect(unlocked.keys, containsAll(['first_lesson', 'streak_3', 'perfect_quiz']));
    });
  });

  group('AchievementService.getAllAchievementsWithStatus', () {
    test('повертає 15 досягнень', () async {
      final svc = await makeService();
      expect(svc.getAllAchievementsWithStatus().length, 15);
    });

    test('нерозблоковані мають isUnlocked=false', () async {
      final svc = await makeService();
      final all = svc.getAllAchievementsWithStatus();
      expect(all.every((a) => !a.isUnlocked), isTrue);
    });

    test('розблоковане досягнення має isUnlocked=true', () async {
      final svc = await makeService();
      await svc.unlockAchievement('night_owl');
      final all = svc.getAllAchievementsWithStatus();
      final nightOwl = all.firstWhere((a) => a.id == 'night_owl');
      expect(nightOwl.isUnlocked, isTrue);
      expect(nightOwl.unlockedAt, isNotNull);
    });

    test('неперелічені id не з\'являються у списку', () async {
      final svc = await makeService();
      await svc.unlockAchievement('nonexistent_id');
      final all = svc.getAllAchievementsWithStatus();
      expect(all.any((a) => a.id == 'nonexistent_id'), isFalse);
    });
  });

  group('GamificationService.markCourseCompleted', () {
    test('рахує унікальні курси', () async {
      final svc = await makeGamificationService();
      await svc.markCourseCompleted('course_1');
      await svc.markCourseCompleted('course_2');
      await svc.markCourseCompleted('course_1'); // повтор
      expect(svc.getCompletedCoursesCount(), 2);
    });

    test('починає з 0', () async {
      final svc = await makeGamificationService();
      expect(svc.getCompletedCoursesCount(), 0);
    });

    test('зберігається між сесіями', () async {
      final prefs = await SharedPreferences.getInstance();
      final svc1 = GamificationService(prefs);
      await svc1.markCourseCompleted('course_a');

      final svc2 = GamificationService(prefs);
      expect(svc2.getCompletedCoursesCount(), 1);
    });
  });
}
