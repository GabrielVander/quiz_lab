import 'package:flutter/material.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_description.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_difficulty.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_options.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_title.dart';

class QuestionInfoDisplay extends StatelessWidget {
  const QuestionInfoDisplay({required this.cubit, super.key});

  final QuestionAnsweringCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            QuestionTitle(cubit: cubit),
            const SizedBox(height: 10),
            QuestionDifficulty(cubit: cubit),
          ],
        ),
        Expanded(
          child: QuestionDescription(cubit: cubit),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: QuestionOptions(cubit: cubit),
        ),
      ],
    );
  }
}
