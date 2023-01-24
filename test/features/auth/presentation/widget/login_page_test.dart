import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/features/auth/presentation/widget/login_page.dart';

void main() {
  testWidgets('should have expected structure', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: const LoginPage(),
      ),
    );

    final loginForm = find.byKey(const ValueKey('loginForm'));
    final emailFormField = find.byKey(const ValueKey('emailFormField'));
    final passwordFormField = find.byKey(const ValueKey('passwordFormField'));
    final loginButton = find.byKey(const ValueKey('loginButton'));
    final enterAnonymouslyButton =
        find.byKey(const ValueKey('enterAnonymouslyButton'));
    final signUpButton = find.byKey(const ValueKey('signUpButton'));

    expect(loginForm, findsOneWidget, reason: 'Missing loginForm');
    expect(emailFormField, findsOneWidget, reason: 'Missing emailFormField');
    expect(
      passwordFormField,
      findsOneWidget,
      reason: 'Missing passwordFormField',
    );
    expect(loginButton, findsOneWidget, reason: 'Missing loginButton');
    expect(
      enterAnonymouslyButton,
      findsOneWidget,
      reason: 'Missing enterAnonymouslyButton',
    );
    expect(signUpButton, findsOneWidget, reason: 'Missing signUpButton');
  });
}
