import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class LessonsListPage extends StatefulWidget {
  const LessonsListPage({super.key, required this.courseId});

  final String courseId;

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> _lessons = [];
  String _courseTitle = '';
  bool _loading = true;
  String? _error;

  static const _typeLabels = {
    'theory': 'Теорія',
    'checklist': 'Чекліст',
    'quiz': 'Тест',
    'video': 'Відео',
  };

  static const _typeIcons = {
    'theory': Icons.article_outlined,
    'checklist': Icons.checklist_outlined,
    'quiz': Icons.quiz_outlined,
    'video': Icons.play_circle_outline,
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final courseData = await _client
          .from('courses')
          .select('title')
          .eq('remote_id', widget.courseId)
          .single();
      _courseTitle = courseData['title'] as String;

      final lessonsData = await _client
          .from('lessons')
          .select()
          .eq('course_remote_id', widget.courseId)
          .order('order_index', ascending: true);

      setState(() {
        _lessons = List<Map<String, dynamic>>.from(lessonsData as List);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _deleteLesson(String id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Видалити урок?'),
        content: Text('Урок "$title" буде видалено безповоротно.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _client.from('lessons').delete().eq('remote_id', id);
      _fetchData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: Text(_courseTitle.isEmpty ? 'Уроки курсу' : 'Уроки: $_courseTitle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingMedium),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Новий урок'),
              onPressed: () async {
                await context.push('/admin/editor/lesson/new?courseId=${widget.courseId}');
                _fetchData();
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
            const SizedBox(height: AppDimensions.spacerSmall),
            Text(_error!, style: const TextStyle(color: AppColors.errorRed)),
            const SizedBox(height: AppDimensions.spacerMedium),
            ElevatedButton(onPressed: _fetchData, child: const Text('Повторити')),
          ],
        ),
      );
    }
    if (_lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppDimensions.spacerMedium),
            const Text(
              'Уроків ще немає',
              style: TextStyle(fontSize: AppDimensions.fontSizeLarge, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacerMedium),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Додати перший урок'),
              onPressed: () async {
                await context.push('/admin/editor/lesson/new?courseId=${widget.courseId}');
                _fetchData();
              },
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacerSmall),
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        final id = lesson['remote_id'] as String;
        final title = lesson['title'] as String;
        final type = lesson['type'] as String;
        final orderIndex = lesson['order_index'] as int;
        final durationSec = lesson['duration_seconds'] as int;
        final xpReward = lesson['xp_reward'] as int;

        final durationMin = (durationSec / 60).ceil();
        final icon = _typeIcons[type] ?? Icons.article_outlined;
        final typeLabel = _typeLabels[type] ?? type;

        return Card(
          color: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge,
              vertical: AppDimensions.paddingSmall,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryRed.withValues(alpha: 0.15),
              child: Icon(icon, color: AppColors.primaryRed, size: 20),
            ),
            title: Text(
              '$orderIndex. $title',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: Row(
              children: [
                _InfoChip(label: typeLabel),
                const SizedBox(width: 6),
                _InfoChip(label: '$durationMin хв'),
                const SizedBox(width: 6),
                _InfoChip(label: '+$xpReward XP', color: AppColors.accentGreen),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                  tooltip: 'Редагувати',
                  onPressed: () async {
                    await context.push('/admin/editor/lesson/$id?courseId=${widget.courseId}');
                    _fetchData();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                  tooltip: 'Видалити',
                  onPressed: () => _deleteLesson(id, title),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, this.color = AppColors.textSecondary});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
