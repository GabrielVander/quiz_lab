import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/common/manager_factory.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/widgets/assessments_page.dart';
import 'package:quiz_lab/core/presentation/widgets/network_checker.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_nav_bar.dart';
import 'package:quiz_lab/core/presentation/widgets/results_page.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/questions_overview_page.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.managerFactory,
  });

  final ManagerFactory managerFactory;

  @override
  Widget build(BuildContext context) {
    final bottomNavigationCubit = managerFactory.make(
      desiredManager: AvailableManagers.bottomNavigationCubit,
    );
    final networkCubit = managerFactory.make(
      desiredManager: AvailableManagers.networkCubit,
    );
    final questionsOverviewCubit = managerFactory.make(
      desiredManager: AvailableManagers.questionsOverviewCubit,
    );

    if (bottomNavigationCubit.isErr ||
        networkCubit.isErr ||
        questionsOverviewCubit.isErr) {
      return Container();
    }

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
              bottomNavigationCubit:
                  bottomNavigationCubit.unwrap() as BottomNavigationCubit,
            ),
            body: NetworkChecker(
              cubit: networkCubit.unwrap() as NetworkCubit,
              child: Pager(
                bottomNavigationCubit:
                    bottomNavigationCubit.unwrap() as BottomNavigationCubit,
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
  });

  final BottomNavigationCubit bottomNavigationCubit;

  @override
  Widget build(BuildContext context) {
    final BottomNavigationState state = useBlocBuilder(bottomNavigationCubit);

    switch (state.runtimeType) {
      case BottomNavigationIndexChangedState:
        return Page(
          bottomNavigationCubit: bottomNavigationCubit,
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
  });

  final BottomNavigationCubit bottomNavigationCubit;
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return AssessmentsPage(
          assessmentsOverviewCubit: AssessmentsOverviewCubit(),
        );
      case 1:
        return QuestionsOverviewPage();
      case 2:
        return const ResultsPage();
    }

    return Container();
  }
}
