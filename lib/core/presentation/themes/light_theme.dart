import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/themes/quiz_lab_theme.dart';

final quizLabLightTheme = QuizLabTheme.light();

final ThemeData lightTheme = ThemeData.light().copyWith(
  useMaterial3: true,
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: quizLabLightTheme.textColors.primary,
        displayColor: quizLabLightTheme.textColors.primary,
      ),
  extensions: <ThemeExtension<dynamic>>[
    ThemeColors(
      textColors: quizLabLightTheme.textColors,
      backgroundColors: quizLabLightTheme.backgroundColors,
      mainColors: quizLabLightTheme.mainColors,
      difficultyColors: quizLabLightTheme.difficultyColors,
    ),
  ],
);
