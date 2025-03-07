import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizWidget extends StatefulWidget {
  final Quiz quiz;
  final Function(int) onComplete;

  const QuizWidget({
    Key? key,
    required this.quiz,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentQuestionIndex = 0;
  List<int?> _selectedAnswers = [];
  bool _showExplanation = false;
  int _score = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.quiz.questions.length, null);
  }

  void _selectAnswer(int answerIndex) {
    if (_showExplanation) return; // Prevent changing answer after showing explanation
    
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _checkAnswer() {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final selectedAnswerIndex = _selectedAnswers[_currentQuestionIndex];
    
    if (selectedAnswerIndex == null) return;
    
    final isCorrect = currentQuestion.answers[selectedAnswerIndex].isCorrect;
    
    setState(() {
      _showExplanation = true;
      
      if (isCorrect) {
        _score += 10; // 10 points per correct answer
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _showExplanation = false;
      
      if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        widget.onComplete(_score);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildQuizCompletedView();
    }
    
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final selectedAnswerIndex = _selectedAnswers[_currentQuestionIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).primaryColor,
        ),
        
        const SizedBox(height: 16),
        
        // Question counter
        Text(
          'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        
        const SizedBox(height: 16),
        
        // Question
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion.text,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                
                const SizedBox(height: 24),
                
                // Answer options
                ...List.generate(
                  currentQuestion.answers.length,
                  (index) => _buildAnswerOption(
                    context,
                    currentQuestion.answers[index],
                    index,
                    selectedAnswerIndex == index,
                    _showExplanation,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Explanation
                if (_showExplanation)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explanation:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(currentQuestion.explanation),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!_showExplanation)
              ElevatedButton(
                onPressed: selectedAnswerIndex != null ? _checkAnswer : null,
                child: const Text('Check Answer'),
              )
            else
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex < widget.quiz.questions.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerOption(
    BuildContext context,
    Answer answer,
    int index,
    bool isSelected,
    bool showCorrectness,
  ) {
    Color? backgroundColor;
    
    if (showCorrectness) {
      if (answer.isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.2);
      } else if (isSelected && !answer.isCorrect) {
        backgroundColor = Colors.red.withOpacity(0.2);
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: InkWell(
        onTap: () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                String.fromCharCode(65 + index), // A, B, C, D...
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(answer.text)),
              if (showCorrectness && answer.isCorrect)
                const Icon(Icons.check_circle, color: Colors.green)
              else if (showCorrectness && isSelected && !answer.isCorrect)
                const Icon(Icons.cancel, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCompletedView() {
    final totalQuestions = widget.quiz.questions.length;
    final correctAnswers = _score ~/ 10; // Assuming 10 points per correct answer
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 64,
              color: Colors.amber,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'You scored: $_score points',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '$correctAnswers correct out of $totalQuestions questions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 24),
            
            if (correctAnswers == totalQuestions)
              const Text(
                'Perfect score! Great job! 🎉',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            else if (correctAnswers >= totalQuestions * 0.7)
              const Text(
                'Well done! You did great! 👍',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            else if (correctAnswers >= totalQuestions * 0.5)
              const Text(
                'Good effort! Keep practicing! 👌',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            else
              const Text(
                'Keep trying! You'll improve with practice! 💪',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
      ),
    );
  }
}