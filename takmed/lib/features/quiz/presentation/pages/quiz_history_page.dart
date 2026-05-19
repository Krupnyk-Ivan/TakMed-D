import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/quiz_attempt_dao.dart';
import '../../../../core/di/injection_container.dart';

class QuizHistoryPage extends StatefulWidget {
  const QuizHistoryPage({super.key});

  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  final _dao = getIt<QuizAttemptDao>();
  List<QuizAttemptDB> _attempts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final attempts = await _dao.getAttemptsByUser(userId);
    if (mounted) setState(() { _attempts = attempts; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: const Text('Історія тестів'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _attempts.isEmpty
              ? _buildEmpty()
              : _buildList(),
    );
  }

  Widget _buildEmpty() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.quiz_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppDimensions.spacerMedium),
            const Text(
              'Ще немає жодної спроби',
              style: TextStyle(fontSize: AppDimensions.fontSizeLarge, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacerSmall),
            const Text(
              'Пройдіть перший тест — результат з\'явиться тут',
              style: TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontSizeMedium),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildList() {
    // Групуємо спроби по даті
    final grouped = <String, List<QuizAttemptDB>>{};
    for (final a in _attempts) {
      final key = _dateLabel(a.attemptedAt);
      grouped.putIfAbsent(key, () => []).add(a);
    }

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      children: [
        _StatsRow(attempts: _attempts),
        const SizedBox(height: AppDimensions.spacerLarge),
        ...grouped.entries.expand((entry) => [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacerSmall),
            child: Text(
              entry.key,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimensions.fontSizeMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...entry.value.map((a) => _AttemptCard(attempt: a)),
          const SizedBox(height: AppDimensions.spacerMedium),
        ]),
      ],
    );
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Сьогодні';
    if (d == today.subtract(const Duration(days: 1))) return 'Вчора';
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}

// ─── Widgets ─────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.attempts});
  final List<QuizAttemptDB> attempts;

  @override
  Widget build(BuildContext context) {
    final total = attempts.length;
    final avgPercent = total == 0
        ? 0
        : attempts.map((a) => a.scorePercent).reduce((a, b) => a + b) ~/ total;
    final best = total == 0
        ? 0
        : attempts.map((a) => a.scorePercent).reduce((a, b) => a > b ? a : b);
    final totalXp = attempts.map((a) => a.earnedXp).fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Row(
        children: [
          _StatCell(label: 'Спроб', value: '$total'),
          _Divider(),
          _StatCell(label: 'Середній %', value: '$avgPercent%'),
          _Divider(),
          _StatCell(label: 'Рекорд', value: '$best%'),
          _Divider(),
          _StatCell(label: 'XP зароблено', value: '$totalXp'),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1, height: 36, color: AppColors.borderColor,
      );
}

class _AttemptCard extends StatelessWidget {
  const _AttemptCard({required this.attempt});
  final QuizAttemptDB attempt;

  @override
  Widget build(BuildContext context) {
    final percent = attempt.scorePercent;
    final color = percent >= 80
        ? AppColors.accentGreen
        : percent >= 50
            ? AppColors.warningOrange
            : AppColors.errorRed;

    final weakTopics = _parseWeakTopics(attempt.weakTopics);
    final time = _formatTime(attempt.attemptedAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacerSmall),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Відсоток
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacerMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${attempt.correctAnswers} з ${attempt.totalQuestions} правильних',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.bolt, size: 14, color: AppColors.warningOrange),
                      Text(
                        ' +${attempt.earnedXp} XP',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.warningOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      Text(
                        ' $time',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  if (weakTopics.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: weakTopics.map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                        ),
                        child: Text(t, style: const TextStyle(fontSize: 10, color: AppColors.errorRed)),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _parseWeakTopics(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {}
    return [];
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
