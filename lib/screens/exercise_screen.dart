import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/session.dart';
import '../models/quiz.dart';
import '../providers/session_provider.dart';
import '../providers/user_progress_provider.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/timer_widget.dart';

class ExerciseScreen extends StatefulWidget {
  final int exerciseIndex;

  const ExerciseScreen({
    Key? key,
    required this.exerciseIndex,
  }) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool _isCompleted = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startExerciseTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startExerciseTimer() {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final exercise = sessionProvider.currentSession.exercises[widget.exerciseIndex];
    
    // Skip timer for quiz exercises
    if (exercise.type == ExerciseType.quiz) return;
    
    _remainingSeconds = exercise.durationMinutes * 60;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _completeExercise();
        }
      });
    });
  }

  void _completeExercise() {
    setState(() {
      _isCompleted = true;
    });
    
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userProgressProvider = Provider.of<UserProgressProvider>(context, listen: false);
    final session = sessionProvider.currentSession;
    final exercise = session.exercises[widget.exerciseIndex];
    
    // Award points for completing the exercise
    userProgressProvider.markExerciseCompleted(
      session.id,
      exercise.id,
      10, // Points for completing
    );
    
    // Check if this was the last exercise in the session
    if (widget.exerciseIndex == session.exercises.length - 1) {
      userProgressProvider.markSessionCompleted(session.id);
    }
  }

  void _onQuizCompleted(int score) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userProgressProvider = Provider.of<UserProgressProvider>(context, listen: false);
    final session = sessionProvider.currentSession;
    final exercise = session.exercises[widget.exerciseIndex];
    
    // Award points based on quiz score
    userProgressProvider.markExerciseCompleted(
      session.id,
      exercise.id,
      score, // Points from quiz
    );
    
    _completeExercise();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final session = sessionProvider.currentSession;
    final exercise = session.exercises[widget.exerciseIndex];
    final isLastExercise = widget.exerciseIndex == session.exercises.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
        actions: [
          if (exercise.type != ExerciseType.quiz)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: TimerWidget(
                  remainingSeconds: _remainingSeconds,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exercise.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Exercise content
            if (exercise.type == ExerciseType.quiz)
              QuizWidget(
                quiz: exercise.content as Quiz,
                onComplete: _onQuizCompleted,
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        exercise.content as String,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Complete Exercise Button (for non-quiz exercises)
            if (exercise.type != ExerciseType.quiz)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isCompleted ? null : _completeExercise,
                  child: Text(_isCompleted ? 'Completed' : 'Complete Exercise'),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Navigation buttons
            if (_isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.exerciseIndex > 0)
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ExerciseScreen(
                              exerciseIndex: widget.exerciseIndex - 1,
                            ),
                          ),
                        );
                      },
                      child: const Text('Previous'),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  isLastExercise
                      ? ElevatedButton(
                          onPressed: () {
                            // Navigate back to session detail
                            Navigator.of(context).pop();
                          },
                          child: const Text('Finish Session'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ExerciseScreen(
                                  exerciseIndex: widget.exerciseIndex + 1,
                                ),
                              ),
                            );
                          },
                          child: const Text('Next Exercise'),
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}