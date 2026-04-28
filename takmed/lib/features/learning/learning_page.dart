import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// Екран навчання.
class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.learning)),
      body: const Center(child: Text(AppStrings.lessons)),
    );
  }
}
