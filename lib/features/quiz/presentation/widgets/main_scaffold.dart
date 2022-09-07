import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/core/widgets/network_checker.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/pages/assessments_page.dart';
import 'package:quiz_lab/features/quiz/presentation/pages/questions_page.dart';
import 'package:quiz_lab/features/quiz/presentation/pages/results_page.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/quiz_lab_nav_bar.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.bottomNavigationCubit,
    required this.networkCubit,
    required this.questionsOverviewCubit,
  });

  final BottomNavigationCubit bottomNavigationCubit;
  final NetworkCubit networkCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final appBarHeight = _getAppBarHeight(context);

          return Scaffold(
            appBar: QuizLabAppBar(
              key: const ValueKey<String>('quizLabAppBar'),
              padding: const EdgeInsets.all(10),
              height: appBarHeight,
            ),
            bottomNavigationBar: QuizLabNavBar(
              key: const ValueKey<String>('navBar'),
              bottomNavigationCubit: bottomNavigationCubit,
            ),
            body: NetworkChecker(
              cubit: networkCubit,
              child: Pager(
                bottomNavigationCubit: bottomNavigationCubit,
                questionsOverviewCubit: questionsOverviewCubit,
              ),
            ),
          );
        },
      ),
    );
  }

  double _getAppBarHeight(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 75;
          case TabletBreakpoint:
            return 90;
          case DesktopBreakpoint:
            return 95;
          default:
            return 100;
        }
      },
    );
  }
}

class Pager extends HookWidget {
  const Pager({
    super.key,
    required this.bottomNavigationCubit,
    required this.questionsOverviewCubit,
  });

  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;

  @override
  Widget build(BuildContext context) {
    final BottomNavigationState state = useBlocBuilder(bottomNavigationCubit);

    switch (state.runtimeType) {
      case BottomNavigationIndexChangedState:
        return Page(
          bottomNavigationCubit: bottomNavigationCubit,
          questionsOverviewCubit: questionsOverviewCubit,
          index: (state as BottomNavigationIndexChangedState).newIndex,
        );
    }

    return Container();
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.index,
    required this.bottomNavigationCubit,
    required this.questionsOverviewCubit,
  });

  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return AssessmentsPage(
          assessmentsOverviewCubit: AssessmentsOverviewCubit(),
        );
      case 1:
        return QuestionsPage(
          questionsOverviewCubit: questionsOverviewCubit,
        );
      case 2:
        return const ResultsPage();
    }

    return Container();
  }
}
