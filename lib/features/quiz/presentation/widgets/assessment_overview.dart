import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/assessment_overview.dart';

class AssessmentOverview extends StatelessWidget {
  const AssessmentOverview({
    required Key key,
    required this.assessment,
  }) : super(key: key);

  final AssessmentOverviewViewModel assessment;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: themeColors?.mainColors.secondary,
      ),
      child: Column(
        children: [
          Title(title: assessment.title),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Questions(amount: assessment.amountOfQuestions),
                  const SizedBox(
                    height: 10,
                  ),
                  Answers(answers: assessment.answers)
                ],
              ),
              DueDate(dueDate: assessment.dueDate),
            ],
          )
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

class Questions extends StatelessWidget {
  const Questions({
    super.key,
    required this.amount,
  });

  final int amount;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);

    return Row(
      children: [
        Text(
          amount.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        Text(
          ' Questions',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
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

  Color? _getTextColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final textColor = themeColors?.textColors.secondary;
    return textColor;
  }
}

class Answers extends StatelessWidget {
  const Answers({
    super.key,
    required this.answers,
  });

  final AnswersViewModel answers;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);

    return Row(
      children: [
        if (answers.hasAnswerLimit)
          AnswersAmountWithLimit(
            amount: answers.amountOfAnswers,
            limit: answers.answerLimit!,
            textColor: textColor,
            fontSize: fontSize,
          )
        else
          AnswersAmountNoLimit(
            amount: answers.amountOfAnswers,
            textColor: textColor,
            fontSize: fontSize,
          ),
        Text(
          ' Answers',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
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

  Color? _getTextColor(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final textColor = themeColors?.textColors.secondary;
    return textColor;
  }
}

class AnswersAmountNoLimit extends StatelessWidget {
  const AnswersAmountNoLimit({
    super.key,
    required this.amount,
    required this.textColor,
    required this.fontSize,
  });

  final int amount;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$amount',
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}

class AnswersAmountWithLimit extends StatelessWidget {
  const AnswersAmountWithLimit({
    super.key,
    required this.amount,
    required this.limit,
    required this.textColor,
    required this.fontSize,
  });

  final int amount;
  final int limit;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$amount/$limit',
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}

class DueDate extends StatelessWidget {
  const DueDate({
    super.key,
    required this.dueDate,
  });

  final DueDateViewModel dueDate;

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final fontSize = _getFontSize(context);

    return dueDate.hasDueDate
        ? DueDateWithValue(
            textColor: textColor,
            fontSize: fontSize,
            dueDate: dueDate,
          )
        : NoDueDate(
            textColor: textColor,
            fontSize: fontSize,
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

class NoDueDate extends StatelessWidget {
  const NoDueDate({
    super.key,
    required this.textColor,
    required this.fontSize,
  });

  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      'No Due Date',
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}

class DueDateWithValue extends StatelessWidget {
  const DueDateWithValue({
    super.key,
    required this.textColor,
    required this.fontSize,
    required this.dueDate,
  });

  final Color? textColor;
  final double fontSize;
  final DueDateViewModel dueDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Due Date',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        Text(
          dueDate.dueDate!,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
