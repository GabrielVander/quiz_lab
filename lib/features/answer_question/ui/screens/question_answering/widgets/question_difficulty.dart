import 'package:flutter/material.dart';
import 'package:quiz_lab/common/ui/widgets/difficulty_color.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionDifficulty extends StatelessWidget {
  const QuestionDifficulty({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DifficultyColor(difficulty: value),
        const SizedBox(width: 5),
        Text(
          S.of(context).questionDifficultyValue(value),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
