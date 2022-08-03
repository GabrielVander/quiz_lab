import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/pages/main_page.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:sizer/sizer.dart';

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
