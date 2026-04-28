import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// Екран чату ШІ.
class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aiChat)),
      body: const Center(child: Text(AppStrings.message)),
    );
  }
}
