import 'package:flutter/material.dart';

class BackgroundColors {
  const BackgroundColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.disabled,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color disabled;
}

class MainColors {
  const MainColors({
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
}

class TextColors {
  const TextColors({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;
}

class DifficultyColors {
  const DifficultyColors({
    required this.easy,
    required this.medium,
    required this.hard,
  });

  final Color easy;
  final Color medium;
  final Color hard;
}
