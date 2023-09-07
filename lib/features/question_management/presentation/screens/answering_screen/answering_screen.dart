import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/answering_screen_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/answer_app_bar.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/answer_button.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/loading.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/question_info_display.dart';
import 'package:quiz_lab/generated/l10n.dart';

class AnsweringScreen extends HookWidget {
  const AnsweringScreen({
    required this.cubit,
    required this.questionId,
    super.key,
  });

  final AnsweringScreenCubit cubit;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    useBlocListener(
      cubit,
      (bloc, current, context) => WidgetsBinding.instance
          .addPostFrameCallback((_) => GoRouter.of(context).goNamed(Routes.questionsOverview.name)),
      listenWhen: (current) => current is QuestionDisplayGoHome,
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
          final state = useBlocBuilder(
            cubit,
            buildWhen: (current) =>
                [QuestionDisplayHideAnswerButton, QuestionDisplayShowAnswerButton].contains(current.runtimeType),
          );

          return Scaffold(
            appBar: const AnswerAppBar(),
            bottomSheet: state is QuestionDisplayHideAnswerButton ? null : AnswerButton(cubit: cubit),
            body: HookBuilder(
              builder: (context) {
                final state = useBlocBuilder(cubit);

                if (state is QuestionDisplayLoading || state is QuestionDisplayInitial) {
                  return const SimpleLoading();
                }

                if (state is QuestionDisplayError) {
                  return Center(child: Text(S.current.genericErrorMessage));
                }

                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: QuestionInfoDisplay(cubit: cubit),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
