import 'package:flutter/material.dart';

abstract class BackgroundColors {
  const BackgroundColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
}
