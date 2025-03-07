import 'package:flutter/foundation.dart';
import '../models/user_progress.dart';
import '../services/reminder_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProgressProvider with ChangeNotifier {
  UserProgress? _userProgress;
  bool _isLoading = true;

  UserProgress? get userProgress => _userProgress;
  bool get isLoading => _isLoading;

  UserProgressProvider() {
    _initUserProgress();
  }

  Future<void> _initUserProgress() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadUserProgress();
    } catch (e) {
      // If loading fails, create a new user progress
      _userProgress = UserProgress(
        userId: 1, // Default user ID
        sessionsProgress: {},
        streakDays: 0,
        totalPointsEarned: 0,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final userProgressJson = prefs.getString('user_progress');
    
    if (userProgressJson != null) {
      final Map<String, dynamic> jsonData = json.decode(userProgressJson);
      
      // Convert the JSON to UserProgress object
      _userProgress = UserProgress(
        userId: jsonData['userId'],
        streakDays: jsonData['streakDays'],
        totalPointsEarned: jsonData['totalPointsEarned'],
        sessionsProgress: (jsonData['sessionsProgress'] as Map).map(
          (key, value) => MapEntry(
            int.parse(key),
            SessionProgress(
              sessionId: value['sessionId'],
              isCompleted: value['isCompleted'],
              completedDate: value['completedDate'] != null 
                ? DateTime.parse(value['completedDate']) 
                : null,
              exercisesCompleted: (value['exercisesCompleted'] as Map).map(
                (exKey, exValue) => MapEntry(int.parse(exKey), exValue as bool)
              ),
              pointsEarned: value['pointsEarned'],
            ),
          ),
        ),
      );
    } else {
      throw Exception('No user progress found');
    }
  }

  Future<void> _saveUserProgress() async {
    if (_userProgress == null) return;

    final prefs = await SharedPreferences.getInstance();
    
    // Convert UserProgress to JSON
    final Map<String, dynamic> jsonData = {
      'userId': _userProgress!.userId,
      'streakDays': _userProgress!.streakDays,
      'totalPointsEarned': _userProgress!.totalPointsEarned,
      'sessionsProgress': _userProgress!.sessionsProgress.map(
        (key, value) => MapEntry(
          key.toString(),
          {
            'sessionId': value.sessionId,
            'isCompleted': value.isCompleted,
            'completedDate': value.completedDate?.toIso8601String(),
            'exercisesCompleted': value.exercisesCompleted.map(
              (exKey, exValue) => MapEntry(exKey.toString(), exValue)
            ),
            'pointsEarned': value.pointsEarned,
          },
        ),
      ),
    };
    
    await prefs.setString('user_progress', json.encode(jsonData));
  }

  Future<void> markExerciseCompleted(int sessionId, int exerciseId, int pointsEarned) async {
    if (_userProgress == null) return;

    // Initialize session progress if it doesn't exist
    if (!_userProgress!.sessionsProgress.containsKey(sessionId)) {
      _userProgress!.sessionsProgress[sessionId] = SessionProgress(
        sessionId: sessionId,
        exercisesCompleted: {},
      );
    }

    // Mark exercise as completed
    _userProgress!.sessionsProgress[sessionId]!.exercisesCompleted[exerciseId] = true;
    _userProgress!.sessionsProgress[sessionId]!.pointsEarned += pointsEarned;
    _userProgress!.totalPointsEarned += pointsEarned;

    // Check if all exercises in the session are completed
    // This would require knowing the total number of exercises in the session

    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> markSessionCompleted(int sessionId) async {
    if (_userProgress == null) return;

    if (_userProgress!.sessionsProgress.containsKey(sessionId)) {
      _userProgress!.sessionsProgress[sessionId]!.isCompleted = true;
      _userProgress!.sessionsProgress[sessionId]!.completedDate = DateTime.now();

      // Update streak
      _updateStreak();

      await _saveUserProgress();
      notifyListeners();
    }
  }
  
  // Check if the user has completed a session today
  bool hasCompletedSessionToday() {
    if (_userProgress == null) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check if any session was completed today
    return _userProgress!.sessionsProgress.values.any((session) {
      if (session.completedDate == null) return false;
      
      final sessionDate = DateTime(
        session.completedDate!.year,
        session.completedDate!.month,
        session.completedDate!.day,
      );
      
      return sessionDate.isAtSameMomentAs(today);
    });
  }
  
  // Schedule a reminder if the user hasn't completed a session today
  Future<void> checkAndScheduleStreakReminder() async {
    if (!hasCompletedSessionToday()) {
      await ReminderService.scheduleStreakReminder();
    }
  }

  void _updateStreak() {
    // This is a simplified streak calculation
    // In a real app, you'd check if the user completed a session each day
    _userProgress!.streakDays++;
  }
}