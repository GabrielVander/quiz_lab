import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/button/default.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/button/primary.dart';
import 'package:quiz_lab/core/presentation/widgets/difficulty_color.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionDisplayPage extends HookWidget {
  const QuestionDisplayPage({
    required this.questionId,
    required this.dependencyInjection,
    super.key,
  });

  final DependencyInjection dependencyInjection;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    final cubit = dependencyInjection.get<QuestionDisplayCubit>();

    useEffect(
      () {
        cubit.loadQuestion(questionId);

        return () {};
      },
      [],
    );

    useBlocListener(
      cubit,
      (bloc, current, context) {
        if (current is QuestionDisplayGoHome) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).goNamed(Routes.questionsOverview.name);
          });
        }
      },
      listenWhen: (current) => current is QuestionDisplayGoHome,
    );

    final rebuildWhen = [
      QuestionDisplayFailure,
      QuestionDisplayViewModelUpdated,
      QuestionDisplayQuestionAnsweredCorrectly,
      QuestionDisplayQuestionAnsweredIncorrectly,
    ];

    final state = useBlocBuilder(
      cubit,
      buildWhen: (current) => rebuildWhen.contains(current.runtimeType),
    );

    return SafeArea(
      child: Scaffold(
        appBar: const _AppBar(),
        bottomSheet: [
          QuestionDisplayFailure,
          QuestionDisplayQuestionAnsweredCorrectly,
          QuestionDisplayQuestionAnsweredIncorrectly
        ].contains(state.runtimeType)
            ? null
            : _AnswerButton(
                cubit: cubit,
              ),
        body: HookBuilder(
          builder: (context) {
            if (state is QuestionDisplayFailure) {
              return const Center(
                child: Text('Oh no!'),
              );
            }

            if (state is QuestionDisplayViewModelUpdated) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: _QuestionDisplay(
                  viewModel: state.viewModel,
                  onOptionSelected: (o) => cubit.onOptionSelected(o.id),
                  onAnswer: cubit.onAnswer,
                ),
              );
            }

            if (state is QuestionDisplayQuestionAnsweredCorrectly) {
              return _CorrectAnswer(
                onGoHome: cubit.onGoHome,
              );
            }

            if (state is QuestionDisplayQuestionAnsweredIncorrectly) {
              return _IncorrectAnswer(
                correctAnswer: state.correctAnswer.title,
                shouldDisplayCorrectAnswer: true,
                onGoHome: cubit.onGoHome,
              );
            }

            return const _Loading();
          },
        ),
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
    required this.viewModel,
    required this.onOptionSelected,
    required this.onAnswer,
  });

  final QuestionDisplayViewModel viewModel;
  final void Function(QuestionDisplayOptionViewModel) onOptionSelected;
  final void Function() onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _QuestionTitle(viewModel: viewModel),
            const SizedBox(height: 10),
            _QuestionDifficulty(viewModel: viewModel),
          ],
        ),
        Expanded(child: _QuestionDescription(viewModel: viewModel)),
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: _QuestionOptions(
            options: viewModel.options,
            onOptionSelected: onOptionSelected,
          ),
        ),
      ],
    );
  }
}

class _QuestionTitle extends StatelessWidget {
  const _QuestionTitle({
    required this.viewModel,
  });

  final QuestionDisplayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Text(
      viewModel.title,
      style: Theme.of(context).textTheme.headlineSmall,
      softWrap: true,
    );
  }
}

class _QuestionDifficulty extends StatelessWidget {
  const _QuestionDifficulty({
    required this.viewModel,
  });

  final QuestionDisplayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DifficultyColor(difficulty: viewModel.difficulty),
        const SizedBox(width: 5),
        Text(
          S.of(context).questionDifficultyValue(viewModel.difficulty),
          style: Theme.of(context).textTheme.bodyLarge,
          textScaleFactor: 1.2,
        ),
      ],
    );
  }
}

class _QuestionDescription extends StatelessWidget {
  const _QuestionDescription({
    required this.viewModel,
  });

  final QuestionDisplayViewModel viewModel;

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
          viewModel.description,
          overflow: TextOverflow.fade,
          // textScaleFactor: 1.5,
        ),
      ),
    );
  }
}

class _QuestionOptions extends StatelessWidget {
  const _QuestionOptions({
    required this.options,
    required this.onOptionSelected,
  });

  final List<QuestionDisplayOptionViewModel> options;
  final void Function(QuestionDisplayOptionViewModel) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final option = options[index];

          return _QuestionSingleOption(
            option: option,
            onSelected: onOptionSelected,
          );
        },
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.cubit,
  });

  final QuestionDisplayCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HookBuilder(
        builder: (context) {
          final state = useBlocBuilder(
            cubit,
            buildWhen: (current) => current is QuestionDisplayAnswerButtonEnabled,
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
    required this.option,
    required this.onSelected,
  });

  final QuestionDisplayOptionViewModel option;
  final void Function(QuestionDisplayOptionViewModel) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          value: option.isSelected,
          onChanged: (_) => onSelected(option),
        ),
        Text(
          option.title,
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
    required this.correctAnswer,
    required this.onGoHome,
    this.shouldDisplayCorrectAnswer = false,
  });

  final String correctAnswer;
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
            )
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
