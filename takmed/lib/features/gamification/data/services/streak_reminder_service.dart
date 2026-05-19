import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class StreakReminderService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const int _notificationId = 1900;

  static const _androidDetails = AndroidNotificationDetails(
    'streak_reminders', 'Streak Reminders',
    channelDescription: 'Нагадування про проходження уроків',
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> initialize() async {
    tz.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
    );

    // Android 13+ потребує явного запиту POST_NOTIFICATIONS у рантаймі.
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    // iOS — на випадок якщо ініціалізація не показала діалог.
    final iosImpl = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Перевіряє, чи дозволено сповіщення на цьому пристрої.
  Future<bool> areNotificationsEnabled() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      return (await androidImpl.areNotificationsEnabled()) ?? false;
    }
    final iosImpl = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      final settings = await iosImpl.checkPermissions();
      return settings?.isEnabled ?? false;
    }
    return true; // інші платформи
  }

  /// Скасовує всі заплановані сповіщення.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Планує щоденне нагадування о 19:00 з поточним стріком у заголовку.
  Future<void> scheduleDailyReminder(int streak) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 0);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      _notificationId,
      '🔥 Твій стрік $streak днів під загрозою!',
      'Займись 5 хвилин, щоб зберегти свій прогрес.',
      scheduled,
      const NotificationDetails(android: _androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Скасовує сьогоднішнє нагадування та планує нове на завтра.
  Future<void> cancelReminderForToday(int streak) async {
    await _plugin.cancel(_notificationId);

    final now = tz.TZDateTime.now(tz.local);
    final tomorrow = tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 0)
        .add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      _notificationId,
      '🔥 Твій стрік $streak днів під загрозою!',
      'Займись 5 хвилин, щоб зберегти свій прогрес.',
      tomorrow,
      const NotificationDetails(android: _androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
