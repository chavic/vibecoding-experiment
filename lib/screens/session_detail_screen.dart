import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/session_provider.dart';
import 'exercise_screen.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final session = sessionProvider.currentSession;

    return Scaffold(
      appBar: AppBar(
        title: Text(session.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Header
            _buildSessionHeader(context, session),
            
            const SizedBox(height: 24),
            
            // Session Structure
            Text(
              'Session Structure',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Exercise List
            ...session.exercises.map((exercise) => _buildExerciseItem(
              context, 
              exercise,
              session.exercises.indexOf(exercise),
            )).toList(),
            
            const SizedBox(height: 24),
            
            // Start Session Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ExerciseScreen(exerciseIndex: 0),
                    ),
                  );
                },
                child: const Text('Start Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader(BuildContext context, Session session) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 8),
                Text('${session.durationMinutes} minutes'),
                const Spacer(),
                const Icon(Icons.fitness_center),
                const SizedBox(width: 8),
                Text('${session.exercises.length} exercises'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              session.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, Exercise exercise, int index) {
    // Different icons for different exercise types
    IconData getIconForExerciseType(ExerciseType type) {
      switch (type) {
        case ExerciseType.focusTask:
          return Icons.center_focus_strong;
        case ExerciseType.mindfulness:
          return Icons.self_improvement;
        case ExerciseType.timeManagement:
          return Icons.schedule;
        case ExerciseType.organizationalSkill:
          return Icons.folder;
        case ExerciseType.quiz:
          return Icons.quiz;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(getIconForExerciseType(exercise.type)),
        ),
        title: Text(exercise.title),
        subtitle: Text('${exercise.durationMinutes} min · ${exercise.type.toString().split('.').last}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ExerciseScreen(exerciseIndex: index),
            ),
          );
        },
      ),
    );
  }
}