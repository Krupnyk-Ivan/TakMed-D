import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/quiz_attempt_dao.dart';
import '../../../../core/di/injection_container.dart';

/// Лінійний графік динаміки результатів тестів за останні 30 днів.
///
/// Точка X — день (0..29), Y — середній % правильних за день.
/// Дні без спроб не відображаються.
class QuizDynamicsChart extends StatefulWidget {
  const QuizDynamicsChart({super.key});

  @override
  State<QuizDynamicsChart> createState() => _QuizDynamicsChartState();
}

class _QuizDynamicsChartState extends State<QuizDynamicsChart> {
  late Future<List<_DailyAverage>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_DailyAverage>> _load() async {
    final dao = getIt<QuizAttemptDao>();
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final attempts = await dao.getAttemptsLast30Days(userId);

    if (attempts.isEmpty) return [];

    // Згрупувати за днем
    final byDay = <DateTime, List<QuizAttemptDB>>{};
    for (final a in attempts) {
      final d = DateTime(a.attemptedAt.year, a.attemptedAt.month, a.attemptedAt.day);
      byDay.putIfAbsent(d, () => []).add(a);
    }

    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);

    final result = <_DailyAverage>[];
    byDay.forEach((day, list) {
      final daysAgo = todayMidnight.difference(day).inDays;
      // X — кількість днів ТОМУ (0 = сьогодні, 29 = 30 днів тому).
      // Перетворюємо у "дні від початку 30-денного вікна" для зростаючої осі.
      final x = (29 - daysAgo).toDouble();
      if (x < 0 || x > 29) return;
      final avg = list.map((a) => a.scorePercent).reduce((a, b) => a + b) / list.length;
      result.add(_DailyAverage(x: x, day: day, avgPercent: avg));
    });

    result.sort((a, b) => a.x.compareTo(b.x));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_DailyAverage>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return _buildEmpty();
        }
        return _buildChart(data);
      },
    );
  }

  Widget _buildEmpty() => Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, size: 40, color: AppColors.textSecondary),
              SizedBox(height: 8),
              Text(
                'Поки немає даних для графіка',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 4),
              Text(
                'Пройдіть тест — динаміка з\'явиться тут',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      );

  Widget _buildChart(List<_DailyAverage> data) {
    final spots = data.map((d) => FlSpot(d.x, d.avgPercent)).toList();
    final today = DateTime.now();

    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 29,
          minY: 0,
          maxY: 100,
          backgroundColor: Colors.transparent,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.borderColor.withValues(alpha: 0.4),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 25,
                getTitlesWidget: (value, _) => Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 7,
                getTitlesWidget: (value, _) {
                  // Конвертуємо x назад у дату
                  final daysAgo = 29 - value.toInt();
                  if (daysAgo < 0) return const SizedBox.shrink();
                  final date = today.subtract(Duration(days: daysAgo));
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${date.day}.${date.month.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.4)),
              left: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.4)),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              color: AppColors.accentGreen,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primaryRed,
                  strokeWidth: 2,
                  strokeColor: AppColors.darkBackground,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accentGreen.withValues(alpha: 0.12),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceColor,
              getTooltipItems: (touched) => touched.map((t) {
                final daysAgo = 29 - t.x.toInt();
                final date = today.subtract(Duration(days: daysAgo));
                return LineTooltipItem(
                  '${date.day}.${date.month.toString().padLeft(2, '0')} — ${t.y.toInt()}%',
                  const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyAverage {
  const _DailyAverage({
    required this.x,
    required this.day,
    required this.avgPercent,
  });
  final double x;
  final DateTime day;
  final double avgPercent;
}
