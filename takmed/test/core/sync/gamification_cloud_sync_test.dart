import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:takmed/core/sync/gamification_cloud_sync.dart';
import 'package:takmed/features/gamification/data/services/achievement_service.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/gamification/data/services/streak_service.dart';

import 'gamification_cloud_sync_test.mocks.dart';

@GenerateMocks([SupabaseClient, GoTrueClient])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late GamificationService gamification;
  late StreakService streak;
  late AchievementService achievements;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    gamification = GamificationService(prefs);
    streak = StreakService(prefs);
    achievements = AchievementService(prefs);
  });

  MockSupabaseClient buildClient({required String? userId}) {
    final client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(client.auth).thenReturn(auth);
    when(auth.currentUser)
        .thenReturn(userId != null ? _fakeUser(userId) : null);
    return client;
  }

  GamificationCloudSync buildSync(SupabaseClient client) =>
      GamificationCloudSync(client, gamification, streak, achievements);

  // ─── pushToCloud ────────────────────────────────────────────────────────────

  group('pushToCloud', () {
    test('повертає без помилок якщо userId = null', () async {
      final client = buildClient(userId: null);
      await expectLater(buildSync(client).pushToCloud(), completes);
    });

    test('відправляє поточні дані гейміфікації коли userId присутній', () async {
      await gamification.awardXp(250);
      await streak.setCurrentStreak(5);
      await streak.setBestStreak(10);

      final captured = <Map<String, dynamic>>[];
      final client = buildClient(userId: 'uid-push');
      when(client.from('user_gamification'))
          .thenAnswer((_) => _CapturingQueryBuilder(captured));

      await buildSync(client).pushToCloud();

      expect(captured, hasLength(1));
      expect(captured.first['user_id'], 'uid-push');
      expect(captured.first['total_xp'], 250);
      expect(captured.first['current_streak'], 5);
      expect(captured.first['best_streak'], 10);
    });
  });

  // ─── restoreFromCloud ───────────────────────────────────────────────────────

  group('restoreFromCloud', () {
    test('повертає false якщо userId = null', () async {
      final client = buildClient(userId: null);
      expect(await buildSync(client).restoreFromCloud(), isFalse);
    });

    test('повертає false якщо хмарний рядок відсутній', () async {
      final client = buildClient(userId: 'uid-empty');
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(null));

      expect(await buildSync(client).restoreFromCloud(), isFalse);
    });

    test('оновлює XP якщо хмарне значення більше', () async {
      await gamification.setTotalXp(100);

      final client = buildClient(userId: 'uid-xp');
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(_cloudRow(xp: 500)));

      expect(await buildSync(client).restoreFromCloud(), isTrue);
      expect(gamification.getTotalXp(), 500);
    });

    test('зберігає локальний XP якщо він більший за хмарний', () async {
      await gamification.setTotalXp(800);

      final client = buildClient(userId: 'uid-xp-keep');
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(_cloudRow(xp: 200)));

      expect(await buildSync(client).restoreFromCloud(), isFalse);
      expect(gamification.getTotalXp(), 800);
    });

    test('оновлює currentStreak якщо хмарний більший', () async {
      await streak.setCurrentStreak(3);

      final client = buildClient(userId: 'uid-streak');
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(_cloudRow(currentStreak: 10)));

      await buildSync(client).restoreFromCloud();
      expect(streak.getCurrentStreak(), 10);
    });

    test('оновлює bestStreak якщо хмарний більший', () async {
      await streak.setBestStreak(5);

      final client = buildClient(userId: 'uid-best');
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(_cloudRow(bestStreak: 20)));

      await buildSync(client).restoreFromCloud();
      expect(streak.getBestStreak(), 20);
    });

    test('розблоковує досягнення з хмари яких немає локально', () async {
      final client = buildClient(userId: 'uid-ach');
      final cloudAch = jsonEncode({'first_lesson': '2026-01-01T00:00:00.000Z'});
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(_cloudRow(achievements: cloudAch)));

      expect(await buildSync(client).restoreFromCloud(), isTrue);
      expect(achievements.getUnlockedAchievements(), contains('first_lesson'));
    });

    test('не змінює дату вже локально розблокованих досягнень', () async {
      await achievements.unlockAchievement('first_lesson');
      final before = achievements.getUnlockedAchievements()['first_lesson'];

      final client = buildClient(userId: 'uid-ach2');
      final cloudAch = jsonEncode({'first_lesson': '2025-05-01T00:00:00.000Z'});
      when(client.from('user_gamification'))
          .thenAnswer((_) => _SelectingQueryBuilder(_cloudRow(achievements: cloudAch)));

      await buildSync(client).restoreFromCloud();
      expect(achievements.getUnlockedAchievements()['first_lesson'], before);
    });
  });
}

// ─── Helpers ────────────────────────────────────────────────────────────────

User _fakeUser(String id) => User(
      id: id,
      appMetadata: const {},
      userMetadata: const {},
      aud: 'authenticated',
      createdAt: '2026-01-01T00:00:00.000Z',
    );

Map<String, dynamic> _cloudRow({
  int xp = 0,
  int currentStreak = 0,
  int bestStreak = 0,
  int freezes = 0,
  String? lastActivity,
  String? achievements,
}) =>
    {
      'total_xp': xp,
      'current_streak': currentStreak,
      'best_streak': bestStreak,
      'freezes_available': freezes,
      'last_activity_date': lastActivity,
      'unlocked_achievements': achievements ?? '{}',
    };

// ─── Fake Supabase builders ─────────────────────────────────────────────────

/// Fake SupabaseQueryBuilder — перехоплює upsert і зберігає дані.
class _CapturingQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final List<Map<String, dynamic>> _captured;
  _CapturingQueryBuilder(this._captured);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString();
    if (name.contains('upsert') || name.contains('insert')) {
      final args = invocation.positionalArguments;
      if (args.isNotEmpty && args.first is Map) {
        _captured.add(Map<String, dynamic>.from(args.first as Map));
      }
    }
    return _CompletingFilterBuilder();
  }
}

/// Fake SupabaseQueryBuilder — повертає контрольований рядок через maybeSingle().
class _SelectingQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final Map<String, dynamic>? _row;
  _SelectingQueryBuilder(this._row);

  @override
  dynamic noSuchMethod(Invocation invocation) => _RowFilterBuilder(_row);
}

/// Fake PostgrestFilterBuilder<dynamic> — миттєво завершується (для upsert).
class _CompletingFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  @override
  Future<U> then<U>(
    FutureOr<U> Function(dynamic) onValue, {
    Function? onError,
  }) =>
      Future<dynamic>.value(null).then(onValue, onError: onError);

  @override
  dynamic noSuchMethod(Invocation invocation) => this;
}

/// Fake PostgrestFilterBuilder — підтримує select/eq ланцюжок і maybeSingle.
class _RowFilterBuilder extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  final Map<String, dynamic>? _row;
  _RowFilterBuilder(this._row);

  @override
  PostgrestTransformBuilder<Map<String, dynamic>?> maybeSingle() =>
      _MaybeSingleBuilder(_row);

  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) =>
      Future<List<Map<String, dynamic>>>.value(
        _row != null ? [_row] : [],
      ).then(onValue, onError: onError);

  @override
  dynamic noSuchMethod(Invocation invocation) => this;
}

/// Fake PostgrestTransformBuilder — повертає конкретний рядок при await.
class _MaybeSingleBuilder extends Fake
    implements PostgrestTransformBuilder<Map<String, dynamic>?> {
  final Map<String, dynamic>? _row;
  _MaybeSingleBuilder(this._row);

  @override
  Future<U> then<U>(
    FutureOr<U> Function(Map<String, dynamic>?) onValue, {
    Function? onError,
  }) =>
      Future<Map<String, dynamic>?>.value(_row).then(onValue, onError: onError);

  @override
  dynamic noSuchMethod(Invocation invocation) => this;
}
