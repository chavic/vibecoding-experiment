class Session {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final List<Exercise> exercises;

  Session({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.exercises,
  });
}

class Exercise {
  final int id;
  final String title;
  final String description;
  final ExerciseType type;
  final int durationMinutes;
  final dynamic content;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    required this.content,
  });
}

enum ExerciseType {
  focusTask,
  mindfulness,
  timeManagement,
  organizationalSkill,
  quiz,
}