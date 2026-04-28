import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

// TODO: Импортировать необходимый BLoC

/// Auth Feature - главный экран
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.login)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppStrings.register),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text(AppStrings.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
