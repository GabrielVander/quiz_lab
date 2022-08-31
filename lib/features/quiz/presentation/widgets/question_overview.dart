import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/themes/extensions.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_overview.dart';

class QuestionOverview extends StatelessWidget {
  const QuestionOverview({
    super.key,
    required this.question,
  });

  final QuestionOverviewViewModel question;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: themeColors?.mainColors.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title(title: question.shortDescription),
              const SizedBox(
                height: 15,
              ),
              Categories(categories: question.categories),
            ],
          ),
          Difficulty(difficulty: question.difficulty),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
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
          MdiIcons.noteTextOutline,
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

  final List<QuestionCategoryViewModel> categories;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);
    final categoryFontSize = _getCategoryFontSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: categories
              .map(
                (e) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    e.value,
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

  Color? _getTextColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final textColor = themeColors?.textColors.secondary;
    return textColor;
  }
}

class Difficulty extends StatelessWidget {
  const Difficulty({
    super.key,
    required this.difficulty,
  });

  final QuestionDifficultyViewModel difficulty;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);
    final difficultyColor = _getDifficultyColor(context);

    return Column(
      children: [
        Text(
          'Difficulty',
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
          difficulty.value,
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

    switch (difficulty.value) {
      case 'Easy':
        return difficultyColors.easy;
      case 'Medium':
        return difficultyColors.medium;
      case 'Hard':
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
