import 'package:flutter/material.dart';

abstract class TextColors {
  const TextColors({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;
}
