import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/answer_app_bar.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/answer_button.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/loading.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/widgets/question_info_display.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionAnsweringScreen extends HookWidget {
  const QuestionAnsweringScreen({
    required this.cubit,
    required this.questionId,
    super.key,
  });

  final QuestionAnsweringCubit cubit;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    useBlocListener(
      cubit,
      (bloc, current, context) => WidgetsBinding.instance
          .addPostFrameCallback((_) => GoRouter.of(context).goNamed(Routes.questionsOverview.name)),
      listenWhen: (current) => current is QuestionAnsweringGoHome,
    );

    useEffect(
      () {
        cubit.loadQuestion(questionId);

        return null;
      },
      [questionId],
    );

    return SafeArea(
      child: HookBuilder(
        builder: (context) {
          final state = useBlocBuilder(cubit);

          return Scaffold(
            appBar: const AnswerAppBar(),
            bottomSheet: state is QuestionAnsweringQuestionViewModelUpdated && state.viewModel.isAnswerButtonVisible
                ? AnswerButton(
                    onPressed: cubit.onAnswer,
                    isButtonEnabled: state.viewModel.isAnswerButtonEnabled,
                  )
                : null,
            body: HookBuilder(
              builder: (context) {
                final state = useBlocBuilder(cubit);

                if (state is QuestionAnsweringInitial || state is QuestionAnsweringLoading) {
                  return const SimpleLoading();
                }

                if (state is QuestionAnsweringError) {
                  return Center(child: Text(state.message));
                }

                if (state is QuestionAnsweringQuestionViewModelUpdated) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: QuestionInfoDisplay(
                      question: state.viewModel,
                      onAnswerSelected: cubit.onOptionSelected,
                    ),
                  );
                }

                return Center(child: Text(S.current.genericErrorMessage));
              },
            ),
          );
        },
      ),
    );
  }
}
