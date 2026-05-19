import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text('Вийти з тесту?'),
                    content: const Text('Ваш поточний прогрес буде втрачено.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(),
                        child: const Text('Скасувати'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogCtx).pop();
                          // Quiz — root-маршрут, тож може не бути куди pop-ити.
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
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
