import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/pages/main_page.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Lab',
      theme: lightTheme,
      home: const MainPage(),
    );
  }
}
