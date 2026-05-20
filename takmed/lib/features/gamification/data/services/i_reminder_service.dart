abstract interface class IReminderService {
  Future<void> initialize();
  Future<bool> areNotificationsEnabled();
  Future<void> scheduleDailyReminder(int streak);
  Future<void> cancelReminderForToday(int streak);
  Future<void> cancelAll();
}
