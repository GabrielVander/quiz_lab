import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/answering_screen_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/loading.dart';
import 'package:quiz_lab/features/question_management/presentation/shared/widgets/difficulty_color.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionDifficulty extends StatelessWidget {
  const QuestionDifficulty({required this.cubit, super.key});

  final AnsweringScreenCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is AnsweringScreenDifficultyUpdated);

        if (state is AnsweringScreenDifficultyUpdated) {
          return _QuestionDifficultyDisplay(value: state.value);
        }

        return const SimpleLoading();
      },
    );
  }
}

class _QuestionDifficultyDisplay extends StatelessWidget {
  const _QuestionDifficultyDisplay({required this.value});

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
