import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/difficulty_color.dart';
import 'package:quiz_lab/core/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/questions_overview_view_model.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/no_questions.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionsOverviewPage extends HookWidget {
  QuestionsOverviewPage({
    super.key,
    required QuestionsOverviewCubit questionsOverviewCubit,
  }) {
    _cubit = questionsOverviewCubit;
  }

  late final QuestionsOverviewCubit _cubit;

  @override
  Widget build(BuildContext context) {
    useBlocListener(
      _cubit,
      (_, QuestionsOverviewState current, BuildContext context) =>
          _handleOpenQuestionState(current, context),
      listenWhen: (QuestionsOverviewState currentState) =>
          currentState is QuestionsOverviewOpenQuestion,
    );

    final state = useBlocBuilder(
      _cubit,
      buildWhen: (QuestionsOverviewState current) => [
        QuestionsOverviewLoading,
        QuestionsOverviewViewModelUpdated,
        QuestionsOverviewErrorOccurred,
      ].contains(current.runtimeType),
    );

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: _Header(
              onAddQuestion: () =>
                  GoRouter.of(context).pushNamed(Routes.createQuestion.name),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state is QuestionsOverviewInitial) {
                  _cubit.updateQuestions();
                }

                if (state is QuestionsOverviewLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is QuestionsOverviewErrorOccurred) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is QuestionsOverviewViewModelUpdated) {
                  final viewModel = state.viewModel;

                  return Column(
                    children: [
                      Expanded(
                        child: _QuestionList(
                          questions: viewModel.questions,
                          onDeleteQuestion: _cubit.removeQuestion,
                          onSaveUpdatedQuestion: _cubit.onQuestionSaved,
                          onQuestionClick: _cubit.onQuestionClick,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _RandomQuestionButton(
                            enabled: viewModel.isRandomQuestionButtonEnabled,
                            onClick: _cubit.onOpenRandomQuestion,
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleOpenQuestionState(Object? current, BuildContext context) {
    final state = current! as QuestionsOverviewOpenQuestion;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).pushNamed(
        Routes.displayQuestion.name,
        params: {'id': state.questionId},
      );
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onAddQuestion,
  });

  final void Function() onAddQuestion;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PageSubtitle(title: S.of(context).questionsSectionDisplayName),
        _QuestionAddButton(
          onAddQuestion: onAddQuestion,
        ),
      ],
    );
  }
}

class _QuestionAddButton extends StatelessWidget {
  const _QuestionAddButton({
    required this.onAddQuestion,
  });

  final void Function() onAddQuestion;

  @override
  Widget build(BuildContext context) {
    final iconSize = _getIconSize(context);
    final buttonColor = _getButtonColor(context);
    final iconColor = _getIconColor(context);

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: buttonColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onAddQuestion,
        color: iconColor,
        iconSize: iconSize,
        icon: const Icon(Icons.add),
      ),
    );
  }

  double _getIconSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 25;
          case TabletBreakpoint:
            return 30;
          case DesktopBreakpoint:
            return 30;
          default:
            return 20;
        }
      },
    );
  }

  Color _getButtonColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final buttonColor = themeColors!.mainColors.accent;

    return buttonColor;
  }

  Color _getIconColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return themeColors!.textColors.secondary;
  }
}

class _RandomQuestionButton extends StatelessWidget {
  const _RandomQuestionButton({
    required this.enabled,
    required this.onClick,
  });

  final bool enabled;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled ? onClick : null,
      style: _buildButtonStyle(context, enabled),
      child: Row(
        children: [
          const Icon(Icons.shuffle),
          const SizedBox(width: 5),
          Text(S.of(context).openRandomQuestionButtonLabel),
        ],
      ),
    );
  }

  ButtonStyle _buildButtonStyle(BuildContext context, bool enabled) {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: enabled
                ? Theme.of(context).extension<ThemeColors>()!.mainColors.primary
                : Theme.of(context)
                    .extension<ThemeColors>()!
                    .backgroundColors
                    .disabled,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        enabled
            ? Theme.of(context)
                .extension<ThemeColors>()!
                .mainColors
                .primary
                .withAlpha(20)
            : Theme.of(context)
                .extension<ThemeColors>()!
                .backgroundColors
                .disabled
                .withAlpha(20),
      ),
    );
  }
}

class _QuestionList extends StatelessWidget {
  const _QuestionList({
    required this.questions,
    required this.onDeleteQuestion,
    required this.onSaveUpdatedQuestion,
    required this.onQuestionClick,
  });

  final List<QuestionsOverviewItemViewModel> questions;
  final void Function(QuestionsOverviewItemViewModel viewModel)
      onDeleteQuestion;
  final void Function(QuestionsOverviewItemViewModel viewModel)
      onSaveUpdatedQuestion;
  final void Function(QuestionsOverviewItemViewModel viewModel) onQuestionClick;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(
        child: NoQuestions(),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        return _QuestionItem(
          question: questions[index],
          onDelete: onDeleteQuestion,
          onClick: onQuestionClick,
        );
      },
      separatorBuilder: (BuildContext _, int __) => const SizedBox(height: 10),
    );
  }
}

class _QuestionItem extends StatelessWidget {
  const _QuestionItem({
    required this.question,
    required this.onDelete,
    required this.onClick,
  });

  final QuestionsOverviewItemViewModel question;
  final void Function(QuestionsOverviewItemViewModel viewModel) onDelete;
  final void Function(QuestionsOverviewItemViewModel viewModel) onClick;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: themeColors?.mainColors.secondary,
      ),
      child: Dismissible(
        key: ValueKey<String>(question.id),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection _) => onDelete(question),
        background: const _QuestionItemBackground(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => onClick(question),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _QuestionItemTitle(title: question.shortDescription),
                  ],
                ),
                _QuestionItemDifficulty(difficulty: question.difficulty),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionItemTitle extends StatelessWidget {
  const _QuestionItemTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);

    return Row(
      children: [
        Icon(
          MdiIcons.ballotOutline,
          color: textColor,
        ),
        Text(
          ' $title',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  Color? _getTextColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final textColor = themeColors?.textColors.secondary;
    return textColor;
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 20;
          case TabletBreakpoint:
            return 22;
          case DesktopBreakpoint:
            return 24;
          default:
            return 20;
        }
      },
    );
  }
}

class _QuestionItemDifficulty extends StatelessWidget {
  const _QuestionItemDifficulty({
    required this.difficulty,
  });

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);

    return Column(
      children: [
        Text(
          S.of(context).questionDifficultyLabel,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        DifficultyColor(difficulty: difficulty),
        Text(
          S.of(context).questionDifficultyValue(difficulty),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        )
      ],
    );
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 15;
          case TabletBreakpoint:
            return 17;
          case DesktopBreakpoint:
            return 19;
          default:
            return 15;
        }
      },
    );
  }

  Color? _getTextColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final textColor = themeColors?.textColors.secondary;
    return textColor;
  }
}

class _QuestionItemBackground extends StatelessWidget {
  const _QuestionItemBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.red,
      ),
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }
}
