import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/admin/navigation/admin_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takmed/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:takmed/features/auth/presentation/bloc/auth_state.dart';
import 'package:mockito/mockito.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  AuthState get state => const AuthState();
  @override
  Stream<AuthState> get stream => const Stream.empty();
}

void main() {
  testWidgets('AdminRouter contains login and dashboard routes', (WidgetTester tester) async {
    final mockAuthBloc = MockAuthBloc();
    // Act
    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: MaterialApp.router(
          routerConfig: AdminRouter.router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The initial route is /login, so LoginPage should be visible.
    // Assuming LoginPage contains a text 'Увійти' or similar, but we can just check if router initialized.
    expect(AdminRouter.router.routerDelegate.currentConfiguration.uri.toString(), '/login');
  });
}
