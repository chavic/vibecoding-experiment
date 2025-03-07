class UserProgress {
  final int userId;
  Map<int, SessionProgress> sessionsProgress;
  int streakDays;
  int totalPointsEarned;

  UserProgress({
    required this.userId,
    required this.sessionsProgress,
    this.streakDays = 0,
    this.totalPointsEarned = 0,
  });
}

class SessionProgress {
  final int sessionId;
  bool isCompleted;
  DateTime? completedDate;
  Map<int, bool> exercisesCompleted;
  int pointsEarned;

  SessionProgress({
    required this.sessionId,
    this.isCompleted = false,
    this.completedDate,
    required this.exercisesCompleted,
    this.pointsEarned = 0,
  });
}