import 'package:flutter/material.dart';
import 'package:quiz_lab/core/pages/main_page.dart';
import 'package:quiz_lab/core/themes/light_theme.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/dependency_injection/get_it_dependency_injection.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (
        context,
        orientation,
        deviceType,
      ) {
        return MaterialApp(
          title: 'Quiz Lab',
          theme: lightTheme,
          home: const MainPage(),
        );
      },
    );
  }
}
