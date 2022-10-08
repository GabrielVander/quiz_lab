import 'package:flutter/material.dart';
import 'package:quiz_lab/core/themes/colors.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.textColors,
    required this.backgroundColors,
    required this.mainColors,
    required this.difficultyColors,
  });

  final TextColors textColors;
  final BackgroundColors backgroundColors;
  final MainColors mainColors;
  final DifficultyColors difficultyColors;

  @override
  ThemeExtension<ThemeColors> copyWith({
    TextColors? textColors,
    BackgroundColors? backgroundColors,
    MainColors? mainColors,
    DifficultyColors? difficultyColors,
  }) =>
      ThemeColors(
        textColors: textColors ?? this.textColors,
        backgroundColors: backgroundColors ?? this.backgroundColors,
        mainColors: mainColors ?? this.mainColors,
        difficultyColors: difficultyColors ?? this.difficultyColors,
      );

  @override
  ThemeColors lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    return this;
  }
}
