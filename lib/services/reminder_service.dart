import '../utils/notification_helper.dart';

class ReminderService {
  // Schedule a daily reminder at 9 AM
  static Future<void> scheduleDailyReminder() async {
    // Schedule notification for 9:00 AM daily
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      9, // 9 AM
      0,
    );

    // If it's already past 9 AM, schedule for tomorrow
    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await NotificationHelper.scheduleSessionReminder(
      id: 0,
      title: 'Time for your ADHD Training',
      body: 'Ready for your 50-minute session? Tap to start!',
      scheduledTime: scheduledTime,
    );
  }

  // Schedule a reminder for an incomplete session
  static Future<void> scheduleSessionReminder(int sessionId, String sessionTitle) async {
    final now = DateTime.now();
    
    // Schedule for 2 hours from now
    final scheduledTime = now.add(const Duration(hours: 2));

    await NotificationHelper.scheduleSessionReminder(
      id: sessionId,
      title: 'Continue Your Training',
      body: 'You have an incomplete session: $sessionTitle',
      scheduledTime: scheduledTime,
    );
  }

  // Schedule a streak reminder if the user hasn't completed a session today
  static Future<void> scheduleStreakReminder() async {
    final now = DateTime.now();
    
    // Schedule for 8 PM if user hasn't completed a session today
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      20, // 8 PM
      0,
    );

    // Only schedule if it's still before 8 PM
    if (now.isBefore(scheduledTime)) {
      await NotificationHelper.scheduleSessionReminder(
        id: 999, // Special ID for streak reminder
        title: 'Don\'t Break Your Streak!',
        body: 'Complete a quick session to maintain your training streak!',
        scheduledTime: scheduledTime,
      );
    }
  }
}