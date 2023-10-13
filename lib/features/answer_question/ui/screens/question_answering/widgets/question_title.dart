import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/loading.dart';

class QuestionTitle extends StatelessWidget {
  const QuestionTitle({required this.cubit, super.key});

  final QuestionAnsweringCubit cubit;

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
