import 'package:flutter/material.dart';
import 'package:quiz_lab/core/ui/themes/colors.dart';

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
            primary: Color(0xFF0C66E4),
            secondary: Color(0xFF6791EC),
            accent: Color(0xFF837AD9),
            subtle: Color(0xFFCFCFCF),
            error: Colors.red,
            success: Colors.green,
            warning: Colors.yellow,
          ),
          textColors: const TextColors(
            primary: Color(0xFF172B4D),
            contrast: Colors.white,
            secondary: Color(0xFF626F86),
          ),
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
