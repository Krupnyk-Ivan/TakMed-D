import 'package:flutter/material.dart';
import 'dart:math';

class AnswerButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback onTap;
  final bool disabled;

  const AnswerButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
    this.disabled = false,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant AnswerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && widget.isCorrect == false && oldWidget.isCorrect == null) {
      // Trigger shake
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey[600]!;
    Color backgroundColor = Colors.transparent;
    IconData? icon;

    if (widget.isSelected) {
      if (widget.isCorrect == true) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.2);
        icon = Icons.check_circle;
      } else if (widget.isCorrect == false) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.2);
        icon = Icons.cancel;
      }
    } else if (widget.isCorrect == true && widget.disabled) {
      // Highlight the correct answer even if not selected
      borderColor = Colors.green;
      backgroundColor = Colors.green.withOpacity(0.2);
      icon = Icons.check_circle;
    }

    Widget button = InkWell(
      onTap: widget.disabled ? null : widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (icon != null) Icon(icon, color: borderColor),
          ],
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final sineValue = sin(4 * pi * _shakeController.value);
        return Transform.translate(
          offset: Offset(sineValue * 10, 0),
          child: child,
        );
      },
      child: button,
    );
  }
}
