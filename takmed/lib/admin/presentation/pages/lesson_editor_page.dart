import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class LessonEditorPage extends StatefulWidget {
  const LessonEditorPage({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  final String lessonId;
  final String courseId;

  @override
  State<LessonEditorPage> createState() => _LessonEditorPageState();
}

class _LessonEditorPageState extends State<LessonEditorPage> {
  final _client = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _orderController = TextEditingController(text: '1');
  final _durationController = TextEditingController(text: '300');
  final _xpController = TextEditingController(text: '10');

  String _type = 'theory';
  bool _loading = false;
  bool _initialLoading = false;

  // theory
  final List<_ContentBlockData> _blocks = [];

  // checklist
  final List<_ChecklistStepData> _steps = [];

  // quiz
  final List<_QuizQuestionData> _questions = [];

  bool get _isNew => widget.lessonId == 'new';

  static const _types = ['theory', 'checklist', 'quiz'];
  static const _typeLabels = {'theory': 'Теорія', 'checklist': 'Чекліст', 'quiz': 'Тест'};
  static const _typeIcons = {
    'theory': Icons.article_outlined,
    'checklist': Icons.checklist_outlined,
    'quiz': Icons.quiz_outlined,
  };

  @override
  void initState() {
    super.initState();
    if (!_isNew) _loadLesson();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _orderController.dispose();
    _durationController.dispose();
    _xpController.dispose();
    for (final b in _blocks) { b.dispose(); }
    for (final s in _steps) { s.dispose(); }
    for (final q in _questions) { q.dispose(); }
    super.dispose();
  }

  Future<void> _loadLesson() async {
    setState(() => _initialLoading = true);
    try {
      final data = await _client
          .from('lessons')
          .select()
          .eq('remote_id', widget.lessonId)
          .single();

      _titleController.text = data['title'] as String;
      _orderController.text = '${data['order_index']}';
      _durationController.text = '${data['duration_seconds']}';
      _xpController.text = '${data['xp_reward']}';
      final type = data['type'] as String;
      setState(() => _type = type);

      final raw = data['content_json'] as String;
      _parseContentJson(type, raw);
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

  void _parseContentJson(String type, String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (type == 'theory') {
        final blocks = json['blocks'] as List<dynamic>? ?? [];
        for (final b in blocks) {
          final map = b as Map<String, dynamic>;
          _blocks.add(_ContentBlockData.fromJson(map));
        }
      } else if (type == 'checklist') {
        final steps = json['steps'] as List<dynamic>? ?? [];
        for (final s in steps) {
          final map = s as Map<String, dynamic>;
          _steps.add(_ChecklistStepData(
            title: map['title'] as String? ?? '',
            description: map['description'] as String? ?? '',
          ));
        }
      } else if (type == 'quiz') {
        final questions = json['questions'] as List<dynamic>? ?? [];
        for (final q in questions) {
          final map = q as Map<String, dynamic>;
          final qType = map['type'] as String? ?? 'multipleChoice';
          final isMulti = qType == 'multiSelect';

          // options може бути List<String> (старий формат) або List<{id,text}> (новий)
          final rawOptions = map['options'] as List<dynamic>? ?? [];
          final options = rawOptions.map((o) {
            if (o is String) return o;
            return (o as Map<String, dynamic>)['text'] as String? ?? '';
          }).toList();

          // correctIndices: відновлюємо з correctIds (новий формат) або correctIndex (старий)
          Set<int> correctIndices = {};
          if (isMulti) {
            final ids = (map['correctIds'] as List<dynamic>? ?? [])
                .map((e) => e as String)
                .toList();
            correctIndices = ids
                .map((id) => int.tryParse(id.replaceFirst('opt_', '')) ?? -1)
                .where((i) => i >= 0)
                .toSet();
          }

          final correctIndex = isMulti
              ? (correctIndices.isEmpty ? 0 : correctIndices.first)
              : (() {
                  final cid = map['correctId'] as String?;
                  if (cid != null) {
                    return int.tryParse(cid.replaceFirst('opt_', '')) ?? 0;
                  }
                  return map['correctIndex'] as int? ?? 0;
                })();

          _questions.add(_QuizQuestionData(
            question: (map['question'] as String?) ?? (map['text'] as String?) ?? '',
            options: options,
            correctIndex: correctIndex,
            correctIndices: correctIndices,
            isMultiSelect: isMulti,
            explanation: map['explanation'] as String? ?? '',
          ));
        }
      }
    } catch (_) {}
  }

  String _buildContentJson() {
    if (_type == 'theory') {
      return jsonEncode({
        'blocks': _blocks.map((b) => b.toJson()).toList(),
      });
    } else if (_type == 'checklist') {
      return jsonEncode({
        'steps': _steps.map((s) => s.toJson()).toList(),
      });
    } else {
      return jsonEncode({
        'questions': _questions.map((q) => q.toJson()).toList(),
      });
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final title = _titleController.text.trim();
    final orderIndex = int.tryParse(_orderController.text.trim()) ?? 1;
    final duration = int.tryParse(_durationController.text.trim()) ?? 300;
    final xp = int.tryParse(_xpController.text.trim()) ?? 10;
    final contentJson = _buildContentJson();

    try {
      if (_isNew) {
        final id = '${widget.courseId}_lesson_${DateTime.now().millisecondsSinceEpoch}';
        await _client.from('lessons').insert({
          'remote_id': id,
          'course_remote_id': widget.courseId,
          'type': _type,
          'title': title,
          'content_json': contentJson,
          'duration_seconds': duration,
          'order_index': orderIndex,
          'xp_reward': xp,
        });
        await _updateTotalLessons();
      } else {
        await _client.from('lessons').update({
          'type': _type,
          'title': title,
          'content_json': contentJson,
          'duration_seconds': duration,
          'order_index': orderIndex,
          'xp_reward': xp,
        }).eq('remote_id', widget.lessonId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isNew ? 'Урок створено' : 'Зміни збережено'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateTotalLessons() async {
    final count = await _client
        .from('lessons')
        .select()
        .eq('course_remote_id', widget.courseId);
    await _client
        .from('courses')
        .update({'total_lessons': (count as List).length})
        .eq('remote_id', widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: Text(_isNew ? 'Новий урок' : 'Редагування уроку'),
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
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                children: [
                  _buildBaseFields(),
                  const SizedBox(height: AppDimensions.spacerLarge),
                  _buildTypeSelector(),
                  const SizedBox(height: AppDimensions.spacerLarge),
                  _buildContentEditor(),
                  const SizedBox(height: AppDimensions.spacerXLarge),
                ],
              ),
            ),
    );
  }

  Widget _buildBaseFields() {
    return _Card(children: [
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: 'Назва уроку *'),
        validator: (v) => (v == null || v.trim().isEmpty) ? "Обов'язкове" : null,
      ),
      const SizedBox(height: AppDimensions.spacerMedium),
      Row(children: [
        Expanded(
          child: TextFormField(
            controller: _orderController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Порядок №', prefixIcon: Icon(Icons.sort)),
            validator: (v) => int.tryParse(v ?? '') == null ? 'Число' : null,
          ),
        ),
        const SizedBox(width: AppDimensions.spacerMedium),
        Expanded(
          child: TextFormField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Тривалість (сек)', prefixIcon: Icon(Icons.timer_outlined)),
            validator: (v) => int.tryParse(v ?? '') == null ? 'Число' : null,
          ),
        ),
        const SizedBox(width: AppDimensions.spacerMedium),
        Expanded(
          child: TextFormField(
            controller: _xpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'XP-нагорода', prefixIcon: Icon(Icons.star_outline)),
            validator: (v) => int.tryParse(v ?? '') == null ? 'Число' : null,
          ),
        ),
      ]),
    ]);
  }

  Widget _buildTypeSelector() {
    return Row(
      children: _types.map((type) {
        final selected = _type == type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                if (_type != type) {
                  setState(() {
                    _type = type;
                    _blocks.clear();
                    _steps.clear();
                    _questions.clear();
                  });
                }
              },
              child: AnimatedContainer(
                duration: AppDimensions.animationShort,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryRed.withValues(alpha: 0.15) : AppColors.cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                    color: selected ? AppColors.primaryRed : AppColors.borderColor,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Column(children: [
                  Icon(_typeIcons[type], color: selected ? AppColors.primaryRed : AppColors.textSecondary, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    _typeLabels[type] ?? type,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? AppColors.primaryRed : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContentEditor() {
    switch (_type) {
      case 'theory':
        return _buildTheoryEditor();
      case 'checklist':
        return _buildChecklistEditor();
      case 'quiz':
        return _buildQuizEditor();
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── THEORY ───────────────────────────────────────────────

  Widget _buildTheoryEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(text: 'Блоки контенту'),
        const SizedBox(height: AppDimensions.spacerSmall),
        ..._blocks.asMap().entries.map((e) => _buildBlockCard(e.key, e.value)),
        const SizedBox(height: AppDimensions.spacerSmall),
        _AddMenu(
          label: 'Додати блок',
          items: const {
            'text': 'Абзац',
            'heading': 'Заголовок',
            'warning': 'Попередження ⚠️',
            'info': 'Інформація ℹ️',
            'image': 'Зображення',
          },
          onSelected: (type) => setState(() => _blocks.add(_ContentBlockData(type: type))),
        ),
      ],
    );
  }

  Widget _buildBlockCard(int index, _ContentBlockData block) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacerSmall),
      child: _Card(children: [
        Row(children: [
          _BlockTypeChip(type: block.type),
          const Spacer(),
          if (index > 0)
            IconButton(
              icon: const Icon(Icons.arrow_upward, size: 18),
              onPressed: () => setState(() {
                _blocks.insert(index - 1, _blocks.removeAt(index));
              }),
            ),
          if (index < _blocks.length - 1)
            IconButton(
              icon: const Icon(Icons.arrow_downward, size: 18),
              onPressed: () => setState(() {
                _blocks.insert(index + 1, _blocks.removeAt(index));
              }),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 18),
            onPressed: () => setState(() => _blocks.removeAt(index)),
          ),
        ]),
        const SizedBox(height: AppDimensions.spacerSmall),
        if (block.type == 'heading') ...[
          TextFormField(
            controller: block.textController,
            decoration: const InputDecoration(labelText: 'Текст заголовку'),
          ),
          const SizedBox(height: AppDimensions.spacerSmall),
          DropdownButtonFormField<int>(
            value: block.headingLevel,
            dropdownColor: AppColors.cardColor,
            decoration: const InputDecoration(labelText: 'Рівень'),
            items: [1, 2, 3].map((l) => DropdownMenuItem(value: l, child: Text('H$l'))).toList(),
            onChanged: (v) => setState(() => block.headingLevel = v ?? 2),
          ),
        ] else if (block.type == 'image') ...[
          TextFormField(
            controller: block.textController,
            decoration: const InputDecoration(labelText: 'URL зображення', prefixIcon: Icon(Icons.link)),
          ),
          const SizedBox(height: AppDimensions.spacerSmall),
          TextFormField(
            controller: block.captionController,
            decoration: const InputDecoration(labelText: 'Підпис (необов\'язково)'),
          ),
        ] else
          TextFormField(
            controller: block.textController,
            maxLines: block.type == 'text' ? 5 : 3,
            decoration: InputDecoration(
              labelText: block.type == 'warning' ? 'Текст попередження'
                  : block.type == 'info' ? 'Інформаційний текст'
                  : 'Текст абзацу',
              alignLabelWithHint: true,
            ),
          ),
      ]),
    );
  }

  // ─── CHECKLIST ────────────────────────────────────────────

  Widget _buildChecklistEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(text: 'Кроки чекліста'),
        const SizedBox(height: AppDimensions.spacerSmall),
        ..._steps.asMap().entries.map((e) => _buildStepCard(e.key, e.value)),
        const SizedBox(height: AppDimensions.spacerSmall),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Додати крок'),
          onPressed: () => setState(() => _steps.add(_ChecklistStepData())),
        ),
      ],
    );
  }

  Widget _buildStepCard(int index, _ChecklistStepData step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacerSmall),
      child: _Card(children: [
        Row(children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primaryRed.withValues(alpha: 0.2),
            child: Text('${index + 1}', style: const TextStyle(fontSize: 11, color: AppColors.primaryRed)),
          ),
          const Spacer(),
          if (index > 0)
            IconButton(
              icon: const Icon(Icons.arrow_upward, size: 18),
              onPressed: () => setState(() => _steps.insert(index - 1, _steps.removeAt(index))),
            ),
          if (index < _steps.length - 1)
            IconButton(
              icon: const Icon(Icons.arrow_downward, size: 18),
              onPressed: () => setState(() => _steps.insert(index + 1, _steps.removeAt(index))),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 18),
            onPressed: () => setState(() => _steps.removeAt(index)),
          ),
        ]),
        const SizedBox(height: AppDimensions.spacerSmall),
        TextFormField(
          controller: step.titleController,
          decoration: const InputDecoration(labelText: 'Назва кроку *'),
          validator: (v) => (v == null || v.trim().isEmpty) ? "Обов'язкове" : null,
        ),
        const SizedBox(height: AppDimensions.spacerSmall),
        TextFormField(
          controller: step.descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Опис / деталі', alignLabelWithHint: true),
        ),
      ]),
    );
  }

  // ─── QUIZ ─────────────────────────────────────────────────

  Widget _buildQuizEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(text: 'Питання тесту'),
        const SizedBox(height: AppDimensions.spacerSmall),
        ..._questions.asMap().entries.map((e) => _buildQuestionCard(e.key, e.value)),
        const SizedBox(height: AppDimensions.spacerSmall),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Додати питання'),
          onPressed: () => setState(() => _questions.add(_QuizQuestionData())),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index, _QuizQuestionData q) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacerMedium),
      child: _Card(children: [
        // — Заголовок + видалити —
        Row(children: [
          Text('Питання ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          // Перемикач single/multi
          Row(children: [
            Text(
              q.isMultiSelect ? 'Кілька відповідей' : 'Одна відповідь',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Switch(
              value: q.isMultiSelect,
              activeColor: AppColors.primaryRed,
              onChanged: (val) => setState(() {
                q.isMultiSelect = val;
                q.correctIndices.clear();
                q.correctIndex = 0;
              }),
            ),
          ]),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 18),
            onPressed: () => setState(() => _questions.removeAt(index)),
          ),
        ]),
        const SizedBox(height: AppDimensions.spacerSmall),
        TextFormField(
          controller: q.questionController,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Текст питання *', alignLabelWithHint: true),
          validator: (v) => (v == null || v.trim().isEmpty) ? "Обов'язкове" : null,
        ),
        const SizedBox(height: AppDimensions.spacerMedium),
        Text(
          q.isMultiSelect
              ? 'Варіанти (позначте всі правильні):'
              : 'Варіанти (оберіть одну правильну):',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: AppDimensions.spacerSmall),
        ...q.optionControllers.asMap().entries.map((e) {
          final i = e.key;
          final ctrl = e.value;
          final isCorrect = q.isMultiSelect
              ? q.correctIndices.contains(i)
              : q.correctIndex == i;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              GestureDetector(
                onTap: () => setState(() {
                  if (q.isMultiSelect) {
                    if (q.correctIndices.contains(i)) {
                      q.correctIndices.remove(i);
                    } else {
                      q.correctIndices.add(i);
                    }
                  } else {
                    q.correctIndex = i;
                  }
                }),
                child: AnimatedContainer(
                  duration: AppDimensions.animationShort,
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    // Квадрат для multi, коло для single
                    shape: q.isMultiSelect ? BoxShape.rectangle : BoxShape.circle,
                    borderRadius: q.isMultiSelect ? BorderRadius.circular(4) : null,
                    color: isCorrect
                        ? AppColors.accentGreen.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: isCorrect ? AppColors.accentGreen : AppColors.borderColor,
                      width: 2,
                    ),
                  ),
                  child: isCorrect
                      ? const Icon(Icons.check, size: 14, color: AppColors.accentGreen)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    labelText: 'Варіант ${i + 1}${isCorrect ? " ✓" : ""}',
                    labelStyle: TextStyle(
                        color: isCorrect ? AppColors.accentGreen : null),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Заповніть" : null,
                ),
              ),
              if (q.optionControllers.length > 2)
                IconButton(
                  icon: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                  onPressed: () => setState(() {
                    q.optionControllers.removeAt(i).dispose();
                    q.correctIndices.remove(i);
                    q.correctIndices = q.correctIndices
                        .map((idx) => idx > i ? idx - 1 : idx)
                        .toSet();
                    if (!q.isMultiSelect &&
                        q.correctIndex >= q.optionControllers.length) {
                      q.correctIndex = q.optionControllers.length - 1;
                    }
                  }),
                ),
            ]),
          );
        }),
        if (q.optionControllers.length < 5)
          TextButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Додати варіант'),
            onPressed: () =>
                setState(() => q.optionControllers.add(TextEditingController())),
          ),
        const SizedBox(height: AppDimensions.spacerSmall),
        TextFormField(
          controller: q.explanationController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Пояснення правильної відповіді',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.lightbulb_outline),
          ),
        ),
      ]),
    );
  }
}

// ─── Data models ──────────────────────────────────────────────

class _ContentBlockData {
  _ContentBlockData({required this.type, String text = '', String caption = '', int level = 2})
      : textController = TextEditingController(text: text),
        captionController = TextEditingController(text: caption),
        headingLevel = level;

  factory _ContentBlockData.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'text';
    return _ContentBlockData(
      type: type,
      text: json['text'] as String? ?? json['url'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      level: json['level'] as int? ?? 2,
    );
  }

  final String type;
  final TextEditingController textController;
  final TextEditingController captionController;
  int headingLevel;

  Map<String, dynamic> toJson() {
    switch (type) {
      case 'heading':
        return {'type': type, 'text': textController.text.trim(), 'level': headingLevel};
      case 'image':
        return {'type': type, 'url': textController.text.trim(), 'caption': captionController.text.trim()};
      default:
        return {'type': type, 'text': textController.text.trim()};
    }
  }

  void dispose() {
    textController.dispose();
    captionController.dispose();
  }
}

class _ChecklistStepData {
  _ChecklistStepData({String title = '', String description = ''})
      : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description);

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  Map<String, dynamic> toJson() => {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'isChecked': false,
      };

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }
}

class _QuizQuestionData {
  _QuizQuestionData({
    String question = '',
    List<String> options = const ['', ''],
    this.correctIndex = 0,
    Set<int>? correctIndices,
    this.isMultiSelect = false,
    String explanation = '',
  })  : questionController = TextEditingController(text: question),
        optionControllers = options.map((o) => TextEditingController(text: o)).toList(),
        explanationController = TextEditingController(text: explanation),
        correctIndices = correctIndices ?? {};

  final TextEditingController questionController;
  final List<TextEditingController> optionControllers;
  int correctIndex;
  Set<int> correctIndices;
  bool isMultiSelect;
  final TextEditingController explanationController;

  Map<String, dynamic> toJson() {
    final options = optionControllers.map((c) => c.text.trim()).toList();
    if (isMultiSelect) {
      return {
        'type': 'multiSelect',
        'question': questionController.text.trim(),
        'options': options.asMap().entries.map((e) => {
          'id': 'opt_${e.key}',
          'text': e.value,
        }).toList(),
        'correctIds': correctIndices.map((i) => 'opt_$i').toList(),
        'explanation': explanationController.text.trim(),
        'tags': <String>[],
      };
    }
    return {
      'type': 'multipleChoice',
      'question': questionController.text.trim(),
      'options': options.asMap().entries.map((e) => {
        'id': 'opt_${e.key}',
        'text': e.value,
      }).toList(),
      'correctId': 'opt_$correctIndex',
      'explanation': explanationController.text.trim(),
      'tags': <String>[],
    };
  }

  void dispose() {
    questionController.dispose();
    for (final c in optionControllers) { c.dispose(); }
    explanationController.dispose();
  }
}

// ─── Shared widgets ───────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: AppDimensions.fontSizeLarge, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      );
}

class _BlockTypeChip extends StatelessWidget {
  const _BlockTypeChip({required this.type});
  final String type;

  static const _labels = {'text': 'Абзац', 'heading': 'Заголовок', 'warning': '⚠️ Попередження', 'info': 'ℹ️ Інформація', 'image': '🖼 Зображення'};

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        ),
        child: Text(_labels[type] ?? type, style: const TextStyle(fontSize: 11, color: AppColors.primaryRed, fontWeight: FontWeight.w600)),
      );
}

class _AddMenu extends StatelessWidget {
  const _AddMenu({required this.label, required this.items, required this.onSelected});
  final String label;
  final Map<String, String> items;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        color: AppColors.cardColor,
        onSelected: onSelected,
        itemBuilder: (_) => items.entries
            .map((e) => PopupMenuItem(
                  value: e.key,
                  child: Text(e.value, style: const TextStyle(color: AppColors.textPrimary)),
                ))
            .toList(),
        child: OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: Text(label),
          onPressed: null,
        ),
      );
}
