import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../models/quiz.dart';

class SessionProvider with ChangeNotifier {
  List<Session> _sessions = [];
  int _currentSessionIndex = 0;

  List<Session> get sessions => [..._sessions];
  
  Session get currentSession => _sessions[_currentSessionIndex];

  int get currentSessionIndex => _currentSessionIndex;

  void setCurrentSessionIndex(int index) {
    if (index >= 0 && index < _sessions.length) {
      _currentSessionIndex = index;
      notifyListeners();
    }
  }

  SessionProvider() {
    _loadSessions();
  }

  void _loadSessions() {
    // In a real app, this would load from an API or local storage
    _sessions = [
      Session(
        id: 1,
        title: 'Focus Building Basics',
        description: 'Learn the fundamentals of improving focus with practical exercises.',
        durationMinutes: 50,
        exercises: [
          Exercise(
            id: 1,
            title: 'Mindful Breathing',
            description: 'A simple breathing exercise to center your attention.',
            type: ExerciseType.mindfulness,
            durationMinutes: 10,
            content: 'Sit comfortably and focus on your breath for 10 minutes. When your mind wanders, gently bring it back to your breathing.',
          ),
          Exercise(
            id: 2,
            title: 'Pomodoro Technique',
            description: 'Learn to work in focused sprints.',
            type: ExerciseType.timeManagement,
            durationMinutes: 25,
            content: 'Choose one task to focus on. Work for 25 minutes, then take a 5-minute break.',
          ),
          Exercise(
            id: 3,
            title: 'Focus Assessment',
            description: 'Test your understanding of focus techniques.',
            type: ExerciseType.quiz,
            durationMinutes: 15,
            content: Quiz(
              id: 1,
              title: 'Focus Techniques Quiz',
              questions: [
                Question(
                  id: 1,
                  text: 'What is the Pomodoro Technique?',
                  answers: [
                    Answer(id: 1, text: 'A meditation practice', isCorrect: false),
                    Answer(id: 2, text: 'Working in focused sprints with breaks', isCorrect: true),
                    Answer(id: 3, text: 'A medication for ADHD', isCorrect: false),
                    Answer(id: 4, text: 'A type of tomato sauce', isCorrect: false),
                  ],
                  explanation: 'The Pomodoro Technique involves working in focused sprints (typically 25 minutes) followed by short breaks.',
                ),
                Question(
                  id: 2,
                  text: 'What should you do when your mind wanders during mindful breathing?',
                  answers: [
                    Answer(id: 1, text: 'Get frustrated with yourself', isCorrect: false),
                    Answer(id: 2, text: 'Give up and try again tomorrow', isCorrect: false),
                    Answer(id: 3, text: 'Gently bring your attention back to your breath', isCorrect: true),
                    Answer(id: 4, text: 'Switch to a different activity', isCorrect: false),
                  ],
                  explanation: 'Mind wandering is normal. The practice is in gently returning your focus to your breath without judgment.',
                ),
              ],
            ),
          ),
        ],
      ),
      Session(
        id: 2,
        title: 'Time Management Mastery',
        description: 'Practical techniques to improve time management for ADHD minds.',
        durationMinutes: 50,
        exercises: [
          Exercise(
            id: 4,
            title: 'Time Audit',
            description: 'Track and analyze how you spend your time.',
            type: ExerciseType.timeManagement,
            durationMinutes: 15,
            content: 'For the next 15 minutes, record your activities and time spent on each task. Look for patterns of distraction.',
          ),
          Exercise(
            id: 5,
            title: 'Priority Matrix',
            description: 'Learn to categorize tasks by importance and urgency.',
            type: ExerciseType.organizationalSkill,
            durationMinutes: 20,
            content: 'Create a 2x2 grid with four quadrants: Important & Urgent, Important & Not Urgent, Not Important & Urgent, Not Important & Not Urgent. Categorize your tasks.',
          ),
          Exercise(
            id: 6,
            title: 'Time Management Quiz',
            description: 'Test your understanding of time management principles.',
            type: ExerciseType.quiz,
            durationMinutes: 15,
            content: Quiz(
              id: 2,
              title: 'Time Management Quiz',
              questions: [
                Question(
                  id: 3,
                  text: 'Which tasks should you focus on first according to the Priority Matrix?',
                  answers: [
                    Answer(id: 1, text: 'Important & Urgent', isCorrect: true),
                    Answer(id: 2, text: 'Important & Not Urgent', isCorrect: false),
                    Answer(id: 3, text: 'Not Important & Urgent', isCorrect: false),
                    Answer(id: 4, text: 'Not Important & Not Urgent', isCorrect: false),
                  ],
                  explanation: 'Important & Urgent tasks require immediate attention and have significant consequences.',
                ),
                Question(
                  id: 4,
                  text: 'What is the benefit of conducting a time audit?',
                  answers: [
                    Answer(id: 1, text: 'It makes you work faster', isCorrect: false),
                    Answer(id: 2, text: 'It helps identify where your time is actually going', isCorrect: true),
                    Answer(id: 3, text: 'It eliminates the need for breaks', isCorrect: false),
                    Answer(id: 4, text: 'It automatically organizes your schedule', isCorrect: false),
                  ],
                  explanation: 'A time audit helps you become aware of how you actually spend your time versus how you think you spend it, revealing patterns of distraction or inefficiency.',
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}