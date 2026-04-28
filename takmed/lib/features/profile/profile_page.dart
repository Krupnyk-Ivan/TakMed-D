import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// Екран профілю.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: const Center(child: Text(AppStrings.profile)),
    );
  }
}
