import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> _courses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _client
          .from('courses')
          .select()
          .order('order_index', ascending: true);
      setState(() {
        _courses = List<Map<String, dynamic>>.from(data as List);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _resetSync() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Скинути кеш синхронізації?'),
        content: const Text(
          'Усі користувачі при наступному запуску отримають повну синхронізацію курсів із сервера.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Скинути'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('learning_last_sync_')).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Скинуто ${keys.length} запис(ів) кешу синхронізації'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  Future<void> _deleteCourse(String id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Видалити курс?'),
        content: Text('Курс "$title" та всі його уроки буде видалено безповоротно.'),
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
      await _client.from('courses').delete().eq('remote_id', id);
      _fetchCourses();
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
        title: const Text('Управління курсами'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Оновити',
            onPressed: _fetchCourses,
          ),
          IconButton(
            icon: const Icon(Icons.sync_problem_outlined),
            tooltip: 'Скинути кеш синхронізації',
            onPressed: _resetSync,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingMedium),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Новий курс'),
              onPressed: () async {
                await context.push('/admin/editor/course/new');
                _fetchCourses();
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
            const SizedBox(height: AppDimensions.spacerSmall),
            Text(_error!, style: const TextStyle(color: AppColors.errorRed)),
            const SizedBox(height: AppDimensions.spacerMedium),
            ElevatedButton(onPressed: _fetchCourses, child: const Text('Повторити')),
          ],
        ),
      );
    }
    if (_courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.library_books_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppDimensions.spacerMedium),
            const Text(
              'Курси відсутні',
              style: TextStyle(fontSize: AppDimensions.fontSizeLarge, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacerMedium),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Створити перший курс'),
              onPressed: () async {
                await context.push('/admin/editor/course/new');
                _fetchCourses();
              },
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      itemCount: _courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacerSmall),
      itemBuilder: (context, index) {
        final course = _courses[index];
        final id = course['remote_id'] as String;
        final title = course['title'] as String;
        final description = course['description'] as String;
        final track = course['track'] as String;
        final totalLessons = course['total_lessons'] as int;
        final orderIndex = course['order_index'] as int;

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
              backgroundColor: track == 'military'
                  ? AppColors.primaryRed.withValues(alpha: 0.2)
                  : AppColors.accentGreen.withValues(alpha: 0.2),
              child: Text(
                '$orderIndex',
                style: TextStyle(
                  color: track == 'military' ? AppColors.primaryRed : AppColors.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontSizeMedium),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _TrackChip(track: track),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Icon(Icons.menu_book, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '$totalLessons уроків',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.list_alt, color: AppColors.textSecondary),
                  tooltip: 'Уроки',
                  onPressed: () async {
                    await context.push('/admin/editor/course/$id/lessons');
                    _fetchCourses();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                  tooltip: 'Редагувати',
                  onPressed: () async {
                    await context.push('/admin/editor/course/$id');
                    _fetchCourses();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                  tooltip: 'Видалити',
                  onPressed: () => _deleteCourse(id, title),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrackChip extends StatelessWidget {
  const _TrackChip({required this.track});
  final String track;

  @override
  Widget build(BuildContext context) {
    final isMilitary = track == 'military';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (isMilitary ? AppColors.primaryRed : AppColors.accentGreen).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        border: Border.all(
          color: (isMilitary ? AppColors.primaryRed : AppColors.accentGreen).withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        isMilitary ? 'Військовий' : 'Цивільний',
        style: TextStyle(
          fontSize: 11,
          color: isMilitary ? AppColors.primaryRed : AppColors.accentGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
