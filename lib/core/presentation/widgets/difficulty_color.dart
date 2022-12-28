import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';

class DifficultyColor extends StatelessWidget {
  const DifficultyColor({super.key, required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _getDifficultyColor(context);

    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: difficultyColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getDifficultyColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final difficultyColors = themeColors!.difficultyColors;

    switch (difficulty) {
      case 'easy':
        return difficultyColors.easy;
      case 'medium':
        return difficultyColors.medium;
      case 'hard':
        return difficultyColors.hard;
      default:
        return Colors.pink;
    }
  }
}
