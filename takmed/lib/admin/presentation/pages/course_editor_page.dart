import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CourseEditorPage extends StatefulWidget {
  const CourseEditorPage({super.key, required this.courseId});

  /// 'new' — створення, інакше — id курсу для редагування.
  final String courseId;

  @override
  State<CourseEditorPage> createState() => _CourseEditorPageState();
}

class _CourseEditorPageState extends State<CourseEditorPage> {
  final _client = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderController = TextEditingController(text: '1');

  String _track = 'military';
  bool _loading = false;
  bool _initialLoading = false;

  bool get _isNew => widget.courseId == 'new';

  @override
  void initState() {
    super.initState();
    if (!_isNew) _loadCourse();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _loadCourse() async {
    setState(() => _initialLoading = true);
    try {
      final data = await _client
          .from('courses')
          .select()
          .eq('remote_id', widget.courseId)
          .single();
      _titleController.text = data['title'] as String;
      _descriptionController.text = data['description'] as String;
      _orderController.text = '${data['order_index']}';
      setState(() => _track = data['track'] as String);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка завантаження: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _initialLoading = false);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final orderIndex = int.tryParse(_orderController.text.trim()) ?? 1;

    try {
      if (_isNew) {
        final id = '${_track}_${DateTime.now().millisecondsSinceEpoch}';
        await _client.from('courses').insert({
          'remote_id': id,
          'title': title,
          'description': description,
          'track': _track,
          'order_index': orderIndex,
          'total_lessons': 0,
        });
      } else {
        await _client.from('courses').update({
          'title': title,
          'description': description,
          'track': _track,
          'order_index': orderIndex,
        }).eq('remote_id', widget.courseId);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isNew ? 'Курс створено' : 'Зміни збережено'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка збереження: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: Text(_isNew ? 'Новий курс' : 'Редагування курсу'),
        actions: [
          if (!_initialLoading)
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingMedium),
              child: ElevatedButton.icon(
                icon: _loading
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Зберегти'),
                onPressed: _loading ? null : _save,
              ),
            ),
        ],
      ),
      body: _initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionHeader(title: 'Основна інформація'),
                        const SizedBox(height: AppDimensions.spacerMedium),
                        _buildCard(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Назва курсу *',
                                hintText: 'Наприклад: Зупинка кровотечі',
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? "Назва обов'язкова" : null,
                            ),
                            const SizedBox(height: AppDimensions.spacerMedium),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Опис *',
                                hintText: 'Короткий опис курсу для каталогу',
                                alignLabelWithHint: true,
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? "Опис обов'язковий" : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacerLarge),
                        _SectionHeader(title: 'Налаштування'),
                        const SizedBox(height: AppDimensions.spacerMedium),
                        _buildCard(
                          children: [
                            const Text(
                              'Тип аудиторії',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppDimensions.fontSizeMedium,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacerSmall),
                            Row(
                              children: [
                                Expanded(
                                  child: _TrackButton(
                                    label: 'Військовий',
                                    icon: Icons.shield_outlined,
                                    selected: _track == 'military',
                                    color: AppColors.primaryRed,
                                    onTap: () => setState(() => _track = 'military'),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacerSmall),
                                Expanded(
                                  child: _TrackButton(
                                    label: 'Цивільний',
                                    icon: Icons.local_hospital_outlined,
                                    selected: _track == 'civilian',
                                    color: AppColors.accentGreen,
                                    onTap: () => setState(() => _track = 'civilian'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacerMedium),
                            TextFormField(
                              controller: _orderController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Порядковий номер',
                                hintText: '1',
                                prefixIcon: Icon(Icons.sort),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Вкажіть порядок';
                                if (int.tryParse(v.trim()) == null) return 'Має бути числом';
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacerXLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _TrackButton extends StatelessWidget {
  const _TrackButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animationShort,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: selected ? color : AppColors.borderColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: AppDimensions.fontSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
