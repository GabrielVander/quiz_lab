import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/question_answering/widgets/loading.dart';

class QuestionDescription extends StatelessWidget {
  const QuestionDescription({required this.cubit, super.key});

  final QuestionAnsweringCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is AnsweringScreenDescriptionUpdated);

        if (state is AnsweringScreenDescriptionUpdated) {
          return _QuestionDescriptionDisplay(value: state.value);
        }

        return const SimpleLoading();
      },
    );
  }
}

class _QuestionDescriptionDisplay extends StatelessWidget {
  const _QuestionDescriptionDisplay({
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SingleChildScrollView(
        child: Text(
          value,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.bodyLarge,
          // textScaleFactor: 1.5,
        ),
      ),
    );
  }
}
