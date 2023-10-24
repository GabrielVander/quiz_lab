import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/design_system/button/primary.dart';
import 'package:quiz_lab/generated/l10n.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({required this.onPressed, required this.isButtonEnabled, super.key});

  final Future<void> Function() onPressed;
  final bool isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: QLPrimaryButton.text(
        onPressed: isButtonEnabled ? onPressed : null,
        text: S.of(context).answerQuestionButtonLabel,
      ),
    );
  }
}
