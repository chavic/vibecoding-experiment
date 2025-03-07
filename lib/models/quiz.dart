class Quiz {
  final int id;
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });
}

class Question {
  final int id;
  final String text;
  final List<Answer> answers;
  final String explanation;

  Question({
    required this.id,
    required this.text,
    required this.answers,
    required this.explanation,
  });
}

class Answer {
  final int id;
  final String text;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}