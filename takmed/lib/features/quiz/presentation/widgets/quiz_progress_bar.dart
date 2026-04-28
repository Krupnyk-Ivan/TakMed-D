import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int total;
  final int current;

  const QuizProgressBar({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Питання ${current + 1} з $total', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Show exit confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Вийти з тесту?'),
                    content: const Text('Ваш поточний прогрес буде втрачено.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Скасувати'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(); // pop quiz page
                        },
                        child: const Text('Вийти'),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: total > 0 ? (current + 1) / total : 0,
          backgroundColor: Colors.grey[800],
          color: Colors.green,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
