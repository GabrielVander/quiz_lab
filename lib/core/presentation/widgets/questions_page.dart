import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/presentation/manager/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/view_models/question_overview.dart';
import 'package:quiz_lab/core/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/core/themes/extensions.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionsPage extends HookWidget {
  const QuestionsPage({
    super.key,
    required this.questionsOverviewCubit,
  });

  final QuestionsOverviewCubit questionsOverviewCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Header(
              onAddQuestion: () => questionsOverviewCubit.createNew(context),
            ),
          ),
          Expanded(
            child: MainContent(
              cubit: questionsOverviewCubit,
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.onAddQuestion,
  });

  final void Function() onAddQuestion;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PageSubtitle(title: S.of(context).questionsSectionDisplayName),
        QuestionAddButton(
          onAddQuestion: onAddQuestion,
        ),
      ],
    );
  }
}

class QuestionAddButton extends StatelessWidget {
  const QuestionAddButton({
    super.key,
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

class MainContent extends HookWidget {
  const MainContent({
    super.key,
    required this.cubit,
  });

  final QuestionsOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    if (state is QuestionsOverviewInitial) {
      cubit.watchQuestions(context);
    }

    if (state is QuestionsOverviewLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is QuestionOverviewListUpdated) {
      return QuestionList(
        list: state.questions,
        cubit: cubit,
      );
    }

    if (state is QuestionsOverviewError) {
      return Center(
        child: Text(state.message),
      );
    }

    return Container();
  }
}

class QuestionList extends StatelessWidget {
  const QuestionList({
    super.key,
    required this.list,
    required this.cubit,
  });

  final List<QuestionOverviewViewModel> list;
  final QuestionsOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return QuestionItem(
          question: list[index],
          onDelete: cubit.removeQuestion,
          onClick: (viewModel) {
            showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              builder: (context) => QuestionEditBottomSheet(
                viewModel: viewModel,
                onSave: cubit.updateQuestion,
              ),
            );
          },
        );
      },
      separatorBuilder: (BuildContext _, int __) => const SizedBox(
        height: 10,
      ),
    );
  }
}

class QuestionEditBottomSheet extends StatelessWidget {
  const QuestionEditBottomSheet({
    super.key,
    required this.viewModel,
    required this.onSave,
  });

  final QuestionOverviewViewModel viewModel;
  final void Function(QuestionOverviewViewModel updatedViewModel) onSave;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController()
      ..text = viewModel.shortDescription;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    label: Text(S.of(context).questionShortDescriptionLabel),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _saveQuestion(controller.text),
                  child: Text(S.of(context).saveLabel),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveQuestion(String updatedShortDescription) {
    final updatedViewModel =
        viewModel.copyWith(shortDescription: updatedShortDescription);

    onSave(updatedViewModel);
  }
}

class QuestionItem extends StatelessWidget {
  const QuestionItem({
    super.key,
    required this.question,
    required this.onDelete,
    required this.onClick,
  });

  final QuestionOverviewViewModel question;
  final void Function(QuestionOverviewViewModel viewModel) onDelete;
  final void Function(QuestionOverviewViewModel viewModel) onClick;

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
        background: const ItemBackground(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => onClick(question),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionTitle(title: question.shortDescription),
                    const SizedBox(
                      height: 15,
                    ),
                    Categories(categories: question.categories),
                  ],
                ),
                Difficulty(difficulty: question.difficulty),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionTitle extends StatelessWidget {
  const QuestionTitle({
    super.key,
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

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.categories,
  });

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);
    final categoryFontSize = _getCategoryFontSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Text(
                S.of(context).questionCategoriesLabel,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: categories
              .map(
                (c) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: textColor,
                    ),
                  ),
                  child: Text(
                    c,
                    style: TextStyle(
                      color: textColor,
                      fontSize: categoryFontSize,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
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

  double _getCategoryFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 12;
          case TabletBreakpoint:
            return 14;
          case DesktopBreakpoint:
            return 16;
          default:
            return 12;
        }
      },
    );
  }

  Color _getTextColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final textColor = themeColors!.textColors.secondary;

    return textColor;
  }
}

class Difficulty extends StatelessWidget {
  const Difficulty({
    super.key,
    required this.difficulty,
  });

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);
    final difficultyColor = _getDifficultyColor(context);

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
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: difficultyColor,
            shape: BoxShape.circle,
          ),
        ),
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

  Color _getDifficultyColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final difficultyColors = themeColors!.difficultyColors;

    switch (difficulty) {
      case 'easy':
        return difficultyColors.easy;
      case 'medium':
        return difficultyColors.medium;
      case 'hard':
        return difficultyColors.hard;
      default:
        return difficultyColors.hard;
    }
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

class ItemBackground extends StatelessWidget {
  const ItemBackground({
    super.key,
  });

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