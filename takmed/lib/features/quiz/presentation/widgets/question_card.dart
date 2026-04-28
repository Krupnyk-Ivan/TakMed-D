import 'package:flutter/material.dart';
import '../../domain/entities/quiz_question.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QuestionCard extends StatelessWidget {
  final QuizQuestion question;

  const QuestionCard({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(question.id),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            question.map(
              multipleChoice: (q) => _buildTextQuestion(context, q.text, q.imageUrl),
              trueFalse: (q) => _buildTextQuestion(context, q.statement, null),
              sequence: (q) => _buildTextQuestion(context, q.instruction, null),
              imageMatch: (q) => _buildTextQuestion(context, q.question, q.imageUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextQuestion(BuildContext context, String text, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (imageUrl != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
