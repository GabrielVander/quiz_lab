import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/answering_screen_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/loading.dart';

class QuestionTitle extends StatelessWidget {
  const QuestionTitle({required this.cubit, super.key});

  final AnsweringScreenCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is AnsweringScreenTitleUpdated);

        if (state is AnsweringScreenTitleUpdated) {
          return _QuestionTitleDisplay(value: state.value);
        }

        return const SimpleLoading();
      },
    );
  }
}

class _QuestionTitleDisplay extends StatelessWidget {
  const _QuestionTitleDisplay({
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.headlineSmall,
      softWrap: true,
    );
  }
}
