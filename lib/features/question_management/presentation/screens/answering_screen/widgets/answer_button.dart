import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/design_system/button/primary.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/answering_screen_cubit.dart';
import 'package:quiz_lab/generated/l10n.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({required this.cubit, super.key});

  final AnsweringScreenCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HookBuilder(
        builder: (context) {
          final state = useBlocBuilder(
            cubit,
            buildWhen: (current) => [QuestionDisplayAnswerButtonEnabled].contains(current.runtimeType),
          );

          return QLPrimaryButton.text(
            onPressed: state is QuestionDisplayAnswerButtonEnabled ? cubit.onAnswer : null,
            text: S.of(context).answerQuestionButtonLabel,
          );
        },
      ),
    );
  }
}
