import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/utils/text_colors.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.textColors,
  });

  final TextColors textColors;

  @override
  ThemeExtension<ThemeColors> copyWith({
    TextColors? textColors,
  }) =>
      ThemeColors(
        textColors: textColors ?? this.textColors,
      );

  @override
  ThemeColors lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    return this;
  }
}
