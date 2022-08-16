import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/background_colors.dart';
import 'package:quiz_lab/core/presentation/themes/text_colors.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.textColors,
    required this.backgroundColors,
  });

  final TextColors textColors;
  final BackgroundColors backgroundColors;

  @override
  ThemeExtension<ThemeColors> copyWith({
    TextColors? textColors,
    BackgroundColors? backgroundColors
  }) =>
      ThemeColors(
        textColors: textColors ?? this.textColors,
        backgroundColors: backgroundColors ?? this.backgroundColors,
      );

  @override
  ThemeColors lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    return this;
  }
}
