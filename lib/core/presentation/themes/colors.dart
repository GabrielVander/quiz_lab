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
    required this.subtle,
    required this.error,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color subtle;
  final Color error;
}

class TextColors {
  const TextColors({
    required this.primary,
    required this.contrast,
    required this.secondary,
  });

  final Color primary;
  final Color contrast;
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
