import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/design_system/button/default.dart';
import 'package:quiz_lab/core/presentation/design_system/button/primary.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/question_answering_screen/bloc/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/shared/widgets/beta_banner_display.dart';
import 'package:quiz_lab/features/question_management/presentation/shared/widgets/difficulty_color.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionDisplayPage extends HookWidget {
  const QuestionDisplayPage({
    required this.cubit,
    required this.questionId,
    super.key,
  });

  final QuestionDisplayCubit cubit;
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
            appBar: const _AppBar(),
            bottomSheet: state is QuestionDisplayHideAnswerButton ? null : _AnswerButton(cubit: cubit),
            body: HookBuilder(
              builder: (context) {
                final state = useBlocBuilder(cubit);

                print('-----> $state');

                if (state is QuestionDisplayLoading || state is QuestionDisplayInitial) {
                  return const _Loading();
                }

                if (state is QuestionDisplayError) {
                  return Center(child: Text(S.current.genericErrorMessage));
                }

                if (state is QuestionDisplayQuestionAnsweredCorrectly) {
                  return _CorrectAnswer(
                    onGoHome: cubit.onGoHome,
                  );
                }

                if (state is QuestionDisplayQuestionAnsweredIncorrectly) {
                  return _IncorrectAnswer(
                    shouldDisplayCorrectAnswer: true,
                    onGoHome: cubit.onGoHome,
                  );
                }

                if ([
                  QuestionDisplayTitleUpdated,
                  QuestionDisplayDifficultyUpdated,
                  QuestionDisplayDescriptionUpdated,
                  QuestionDisplayAnswersUpdated,
                  QuestionDisplayAnswerOptionWasSelected,
                  QuestionDisplayAnswerButtonEnabled,
                  QuestionDisplayHideAnswerButton,
                ].contains(state.runtimeType)) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: _QuestionDisplay(cubit: cubit),
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

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return BetaBannerDisplay(
      child: AppBar(
        title: Text(
          S.of(context).questionAnswerPageTitle,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _QuestionDisplay extends StatelessWidget {
  const _QuestionDisplay({
    required this.cubit,
  });

  final QuestionDisplayCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _QuestionTitle(cubit: cubit),
            const SizedBox(height: 10),
            _QuestionDifficulty(cubit: cubit),
          ],
        ),
        Expanded(
          child: _QuestionDescription(cubit: cubit),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: _QuestionOptions(cubit: cubit),
        ),
      ],
    );
  }
}

class _QuestionTitle extends StatelessWidget {
  const _QuestionTitle({required this.cubit});

  final QuestionDisplayCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is QuestionDisplayTitleUpdated);

        if (state is QuestionDisplayTitleUpdated) {
          return _QuestionTitleDisplay(value: state.value);
        }

        return const _Loading();
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

class _QuestionDifficulty extends StatelessWidget {
  const _QuestionDifficulty({required this.cubit});

  final QuestionDisplayCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is QuestionDisplayDifficultyUpdated);

        if (state is QuestionDisplayDifficultyUpdated) {
          return _QuestionDifficultyDisplay(value: state.value);
        }

        return const _Loading();
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
          style: Theme.of(context).textTheme.bodyLarge,
          textScaleFactor: 1.2,
        ),
      ],
    );
  }
}

class _QuestionDescription extends StatelessWidget {
  const _QuestionDescription({required this.cubit});

  final QuestionDisplayCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is QuestionDisplayDescriptionUpdated);

        if (state is QuestionDisplayDescriptionUpdated) {
          return _QuestionDescriptionDisplay(value: state.value);
        }

        return const _Loading();
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
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
        ),
      ),*/
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Text(
          softWrap: true,
          value,
          overflow: TextOverflow.fade,
          // textScaleFactor: 1.5,
        ),
      ),
    );
  }
}

class _QuestionOptions extends StatelessWidget {
  const _QuestionOptions({required this.cubit});

  final QuestionDisplayCubit cubit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      ),
      child: HookBuilder(
        builder: (context) {
          final state = useBlocBuilder(cubit, buildWhen: (current) => current is QuestionDisplayAnswersUpdated);

          if (state is QuestionDisplayAnswersUpdated) {
            return _QuestionOptionsDisplay(cubit: cubit, options: state.value);
          }

          return const _Loading();
        },
      ),
    );
  }
}

class _QuestionOptionsDisplay extends StatelessWidget {
  const _QuestionOptionsDisplay({
    required this.cubit,
    required this.options,
  });

  final QuestionDisplayCubit cubit;
  final List<QuestionAnswerInfo> options;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _QuestionSingleOption(
        cubit: cubit,
        info: options[index],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({required this.cubit});

  final QuestionDisplayCubit cubit;

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

class _QuestionSingleOption extends StatelessWidget {
  const _QuestionSingleOption({
    required this.cubit,
    required this.info,
  });

  final QuestionDisplayCubit cubit;
  final QuestionAnswerInfo info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HookBuilder(
          builder: (context) {
            final state = useBlocComparativeBuilder(
              cubit,
              buildWhen: (previous, current) => current is QuestionDisplayAnswerOptionWasSelected,
            );

            return Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              value: state is QuestionDisplayAnswerOptionWasSelected && state.id == info.id,
              onChanged: (_) => cubit.onOptionSelected(info.id),
            );
          },
        ),
        Text(
          info.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _CorrectAnswer extends StatelessWidget {
  const _CorrectAnswer({
    required this.onGoHome,
  });

  final void Function() onGoHome;

  @override
  Widget build(BuildContext context) {
    return _ResultDisplay(
      backgroundColor: Colors.green,
      message: S.of(context).questionDisplayCorrectAnswer,
      onGoHome: onGoHome,
      icon: Icons.check_circle,
    );
  }
}

class _IncorrectAnswer extends StatelessWidget {
  const _IncorrectAnswer({
    required this.onGoHome,
    this.shouldDisplayCorrectAnswer = false,
  });

  final bool shouldDisplayCorrectAnswer;
  final void Function() onGoHome;

  @override
  Widget build(BuildContext context) {
    return _ResultDisplay(
      backgroundColor: Colors.red,
      message: S.of(context).questionDisplayIncorrectAnswer,
      icon: Icons.cancel,
      onGoHome: onGoHome,
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  const _ResultDisplay({
    required this.backgroundColor,
    required this.message,
    required this.icon,
    required this.onGoHome,
  });

  final Color backgroundColor;
  final String message;
  final IconData icon;
  final void Function() onGoHome;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 150,
                      ),
                    ],
                  ),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            QLDefaultButton.text(
              onPressed: onGoHome,
              text: S.of(context).goHomeLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
