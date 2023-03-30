import 'package:flutter/material.dart';
import 'package:quiz_lab/generated/l10n.dart';

class NoQuestions extends StatelessWidget {
  const NoQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      S.of(context).noQuestions,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
