import 'package:flutter/material.dart';

abstract class MainColors {
  const MainColors({
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
}
