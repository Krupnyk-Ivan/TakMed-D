import 'package:flutter/material.dart';

class ExplanationPanel extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final VoidCallback onNext;

  const ExplanationPanel({
    super.key,
    required this.isCorrect,
    required this.explanation,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isCorrect ? Colors.green : Colors.red,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                isCorrect ? 'Правильно!' : 'Неправильно',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            explanation,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Далі', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
