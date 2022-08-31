import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/themes/extensions.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/question_overview.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PageSubtitle(title: 'Questions'),
              AddButton(
                cubit: questionsOverviewCubit,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Content(
              cubit: questionsOverviewCubit,
            ),
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.cubit,
  });

  final QuestionsOverviewCubit cubit;

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
        onPressed: () => cubit.createNew(context),
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

class Content extends HookWidget {
  const Content({
    super.key,
    required this.cubit,
  });

  final QuestionsOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    if (state is QuestionsOverviewInitial) {
      cubit.getQuestions(context);
    }

    if (state is QuestionsOverviewLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is QuestionsOverviewLoaded) {
      final questions = state.questions;

      return ListView.separated(
        itemCount: questions.length,
        itemBuilder: (BuildContext context, int index) => Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (DismissDirection _) =>
              cubit.removeQuestion(questions[index]),
          background: Container(
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
          ),
          child: QuestionOverview(
            question: questions[index],
          ),
        ),
        separatorBuilder: (BuildContext _, int __) => const SizedBox(
          height: 10,
        ),
      );
    }

    return Container();
  }
}
