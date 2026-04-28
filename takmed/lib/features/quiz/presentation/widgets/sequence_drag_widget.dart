import 'package:flutter/material.dart';
import '../../domain/entities/sequence_item.dart';
import 'package:flutter/services.dart';

class SequenceDragWidget extends StatefulWidget {
  final List<SequenceItem> items;
  final bool disabled;
  final Function(List<String>) onReorder;
  final bool? isCorrect; // Passed after submit to show green/red

  const SequenceDragWidget({
    super.key,
    required this.items,
    required this.onReorder,
    this.disabled = false,
    this.isCorrect,
  });

  @override
  State<SequenceDragWidget> createState() => _SequenceDragWidgetState();
}

class _SequenceDragWidgetState extends State<SequenceDragWidget> {
  late List<SequenceItem> _currentItems;

  @override
  void initState() {
    super.initState();
    // Shuffle or use the provided list. The bloc should probably pass shuffled list initially.
    _currentItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant SequenceDragWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _currentItems = List.from(widget.items);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (widget.disabled) return;
    HapticFeedback.lightImpact();

    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _currentItems.removeAt(oldIndex);
      _currentItems.insert(newIndex, item);
    });

    widget.onReorder(_currentItems.map((e) => e.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey[800]!;
    if (widget.isCorrect == true) borderColor = Colors.green;
    if (widget.isCorrect == false) borderColor = Colors.red;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: _onReorder,
        children: [
          for (int index = 0; index < _currentItems.length; index++)
            Container(
              key: ValueKey(_currentItems[index].id),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  _currentItems[index].text,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                trailing: const Icon(Icons.drag_handle, color: Colors.white54),
              ),
            ),
        ],
      ),
    );
  }
}
