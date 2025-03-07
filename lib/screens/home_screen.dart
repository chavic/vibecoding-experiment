import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/user_progress_provider.dart';
import 'session_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final userProgressProvider = Provider.of<UserProgressProvider>(context);
    final sessions = sessionProvider.sessions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADHD Training'),
      ),
      body: userProgressProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // User Progress Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProgressStat(
                        context,
                        'Streak',
                        '${userProgressProvider.userProgress?.streakDays ?? 0} days',
                        Icons.local_fire_department,
                      ),
                      _buildProgressStat(
                        context,
                        'Points',
                        '${userProgressProvider.userProgress?.totalPointsEarned ?? 0}',
                        Icons.star,
                      ),
                      _buildProgressStat(
                        context,
                        'Sessions',
                        '${userProgressProvider.userProgress?.sessionsProgress.values.where((s) => s.isCompleted).length ?? 0}/${sessions.length}',
                        Icons.check_circle,
                      ),
                    ],
                  ),
                ),
                
                // Today's Recommendation
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Recommendation',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildRecommendedSession(context, sessionProvider),
                    ],
                  ),
                ),
                
                // All Sessions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Sessions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // Show all sessions view
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sessions.length,
                    itemBuilder: (ctx, index) {
                      final session = sessions[index];
                      final sessionProgress = userProgressProvider.userProgress?.sessionsProgress[session.id];
                      final isCompleted = sessionProgress?.isCompleted ?? false;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(session.title),
                          subtitle: Text(session.description),
                          trailing: isCompleted
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.arrow_forward),
                          onTap: () {
                            sessionProvider.setCurrentSessionIndex(index);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const SessionDetailScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProgressStat(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildRecommendedSession(BuildContext context, SessionProvider sessionProvider) {
    // In a real app, this would be based on user's progress and habits
    final recommendedSession = sessionProvider.sessions[0];
    
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          sessionProvider.setCurrentSessionIndex(0);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const SessionDetailScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.psychology, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    recommendedSession.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(recommendedSession.description),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${recommendedSession.durationMinutes} minutes'),
                  ElevatedButton(
                    onPressed: () {
                      sessionProvider.setCurrentSessionIndex(0);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const SessionDetailScreen(),
                        ),
                      );
                    },
                    child: const Text('Start Session'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}