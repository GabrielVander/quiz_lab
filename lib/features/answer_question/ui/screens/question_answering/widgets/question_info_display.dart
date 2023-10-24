import 'package:flutter/material.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_description.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_difficulty.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_options.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_title.dart';

class QuestionInfoDisplay extends StatelessWidget {
  const QuestionInfoDisplay({required this.question, required this.onAnswerSelected, super.key});

  final QuestionViewModel question;
  final void Function(String) onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            QuestionTitle(value: question.title),
            const SizedBox(height: 10),
            QuestionDifficulty(value: question.difficulty),
          ],
        ),
        Expanded(
          child: QuestionDescription(value: question.description),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: QuestionOptions(
            answers: question.answers,
            showResult: question.showResult,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ],
    );
  }
}
