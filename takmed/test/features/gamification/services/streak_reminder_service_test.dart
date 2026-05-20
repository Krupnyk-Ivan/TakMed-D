import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:takmed/core/sync/gamification_cloud_sync.dart';
import 'package:takmed/features/gamification/data/services/achievement_service.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/gamification/data/services/i_reminder_service.dart';
import 'package:takmed/features/gamification/data/services/streak_service.dart';
import 'package:takmed/features/gamification/presentation/bloc/gamification_bloc.dart';
import 'package:takmed/features/gamification/presentation/bloc/gamification_event.dart';
import 'package:takmed/features/gamification/presentation/bloc/gamification_state.dart';

import 'streak_reminder_service_test.mocks.dart';

@GenerateMocks([IReminderService, GamificationCloudSync])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late GamificationService gamification;
  late StreakService streak;
  late AchievementService achievements;
  late MockIReminderService mockReminder;
  late MockGamificationCloudSync mockSync;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    gamification = GamificationService(prefs);
    streak = StreakService(prefs);
    achievements = AchievementService(prefs);
    mockReminder = MockIReminderService();
    mockSync = MockGamificationCloudSync();

    when(mockReminder.scheduleDailyReminder(any))
        .thenAnswer((_) => Future.value());
    when(mockReminder.cancelReminderForToday(any))
        .thenAnswer((_) => Future.value());
    when(mockSync.restoreFromCloud()).thenAnswer((_) async => false);
    when(mockSync.pushToCloud()).thenAnswer((_) => Future.value());
  });

  GamificationBloc buildBloc() => GamificationBloc(
        gamification,
        streak,
        achievements,
        mockReminder,
        mockSync,
      );

  // ─── scheduleDailyReminder ──────────────────────────────────────────────────

  group('scheduleDailyReminder', () {
    blocTest<GamificationBloc, GamificationState>(
      'викликається при ініціалізації з поточним стріком (0)',
      build: buildBloc,
      act: (bloc) => bloc.add(const GamificationInitialized()),
      verify: (_) {
        verify(mockReminder.scheduleDailyReminder(0)).called(1);
      },
    );

    blocTest<GamificationBloc, GamificationState>(
      'викликається зі стріком 1 після першого дня активності',
      build: buildBloc,
      setUp: () async {
        await streak.registerActivity();
      },
      act: (bloc) => bloc.add(const GamificationInitialized()),
      verify: (_) {
        verify(mockReminder.scheduleDailyReminder(1)).called(1);
      },
    );

    blocTest<GamificationBloc, GamificationState>(
      'не кидає виняток якщо scheduleDailyReminder падає',
      build: () {
        when(mockReminder.scheduleDailyReminder(any))
            .thenThrow(Exception('Permission denied'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GamificationInitialized()),
      expect: () => [isA<GamificationState>()],
    );
  });

  // ─── cancelReminderForToday ──────────────────────────────────────────────────

  group('cancelReminderForToday', () {
    blocTest<GamificationBloc, GamificationState>(
      'викликається після завершення уроку',
      build: buildBloc,
      act: (bloc) => bloc.add(const GamificationLessonCompleted(
        lessonId: 1,
        courseRemoteId: 'course-1',
        isOffline: false,
        isAllCourseComplete: false,
        totalCompletedLessons: 1,
      )),
      verify: (_) {
        verify(mockReminder.cancelReminderForToday(any)).called(1);
      },
    );

    blocTest<GamificationBloc, GamificationState>(
      'викликається після завершення квізу',
      build: buildBloc,
      act: (bloc) => bloc.add(const GamificationQuizCompleted(
        totalQuestions: 10,
        correctAnswers: 8,
        earnedXp: 80,
        courseRemoteId: 'course-1',
        fastAnswerCount: 3,
      )),
      verify: (_) {
        verify(mockReminder.cancelReminderForToday(any)).called(1);
      },
    );

    blocTest<GamificationBloc, GamificationState>(
      'НЕ викликається при ініціалізації — лише schedule',
      build: buildBloc,
      act: (bloc) => bloc.add(const GamificationInitialized()),
      verify: (_) {
        verifyNever(mockReminder.cancelReminderForToday(any));
        verify(mockReminder.scheduleDailyReminder(any)).called(1);
      },
    );
  });

  // ─── IReminderService — контракт fake-реалізації ────────────────────────────

  group('IReminderService — контракт', () {
    test('FakeReminderService реалізує всі методи без помилок', () async {
      final fake = _FakeReminderService();

      await fake.initialize();
      expect(await fake.areNotificationsEnabled(), isTrue);
      await fake.scheduleDailyReminder(5);
      await fake.cancelReminderForToday(5);
      await fake.cancelAll();

      expect(fake.scheduled, isEmpty);
      expect(fake.cancelled, isEmpty);
    });

    test('scheduleDailyReminder накопичує значення стріку', () async {
      final fake = _FakeReminderService();
      await fake.scheduleDailyReminder(7);
      await fake.scheduleDailyReminder(14);

      expect(fake.scheduled, [7, 14]);
    });

    test('cancelReminderForToday зберігає значення стріку', () async {
      final fake = _FakeReminderService();
      await fake.cancelReminderForToday(3);

      expect(fake.cancelled, [3]);
    });

    test('cancelAll очищує обидва списки', () async {
      final fake = _FakeReminderService();
      await fake.scheduleDailyReminder(5);
      await fake.cancelReminderForToday(5);
      await fake.cancelAll();

      expect(fake.scheduled, isEmpty);
      expect(fake.cancelled, isEmpty);
    });
  });
}

// ─── Fake-реалізація IReminderService для перевірки контракту ───────────────

class _FakeReminderService implements IReminderService {
  final List<int> scheduled = [];
  final List<int> cancelled = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> areNotificationsEnabled() async => true;

  @override
  Future<void> scheduleDailyReminder(int streak) async {
    scheduled.add(streak);
  }

  @override
  Future<void> cancelReminderForToday(int streak) async {
    cancelled.add(streak);
  }

  @override
  Future<void> cancelAll() async {
    scheduled.clear();
    cancelled.clear();
  }
}
