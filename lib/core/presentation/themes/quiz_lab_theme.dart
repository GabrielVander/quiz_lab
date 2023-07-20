import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/colors.dart';

abstract class _QuizLabTheme {
  const _QuizLabTheme({
    required this.mainColors,
    required this.textColors,
    required this.backgroundColors,
    required this.difficultyColors,
  });

  final MainColors mainColors;
  final TextColors textColors;
  final BackgroundColors backgroundColors;
  final DifficultyColors difficultyColors;
}

class QuizLabTheme extends _QuizLabTheme {
  QuizLabTheme.light()
      : super(
          mainColors: const MainColors(
            primary: Color(0xFF00C3FE),
            secondary: Color(0xFF6791EC),
            accent: Color(0xFF837AD9),
          ),
          textColors: const TextColors(primary: Color(0xFF172B4D), secondary: Colors.white),
          backgroundColors: const BackgroundColors(
            primary: Color(0xFFFFFFFF),
            secondary: Color(0xFF48A7F8),
            tertiary: Color(0xFFD9F3FF),
            disabled: Color(0xABABABAB),
          ),
          difficultyColors: const DifficultyColors(
            easy: Color(0xFF006C04),
            medium: Color(0xFF00326C),
            hard: Color(0xFF6C0000),
          ),
        );
}
