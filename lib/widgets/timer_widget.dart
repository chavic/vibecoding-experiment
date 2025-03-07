import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int remainingSeconds;

  const TimerWidget({
    Key? key,
    required this.remainingSeconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer),
        const SizedBox(width: 4),
        Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}