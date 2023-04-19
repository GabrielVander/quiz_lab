import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/widgets/assessments_page.dart';
import 'package:quiz_lab/core/presentation/widgets/network_checker.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/core/presentation/widgets/results_page.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/questions_overview_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

class HomePage extends HookWidget {
  const HomePage({
    required this.networkCubit,
    required this.bottomNavigationCubit,
    required this.questionsOverviewCubit,
    super.key,
  });

  final NetworkCubit networkCubit;
  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;

  @override
  Widget build(BuildContext context) {
    final bottomNavigationState = useBlocBuilder(bottomNavigationCubit);

    if (bottomNavigationState is BottomNavigationInitial) {
      bottomNavigationCubit.transitionTo(
        newIndex: NavigationIndex.questions.index,
      );

      return const Center(child: CircularProgressIndicator());
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
            bottomNavigationBar: bottomNavigationState
                    is BottomNavigationIndexChangedState
                ? _BottomNavigationBar(
                    key: const ValueKey<String>('navBar'),
                    onItemTapped: (int newIndex) =>
                        bottomNavigationCubit.transitionTo(newIndex: newIndex),
                    index: bottomNavigationState.newIndex,
                  )
                : null,
            body: NetworkChecker(
              cubit: networkCubit,
              child: Builder(
                builder: (context) {
                  if (bottomNavigationState is BottomNavigationInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (bottomNavigationState
                      is BottomNavigationIndexChangedState) {
                    return _Screens(
                      currentScreenIndex: bottomNavigationState.newIndex,
                      screens: [
                        AssessmentsPage(
                          assessmentsOverviewCubit: AssessmentsOverviewCubit(),
                        ),
                        QuestionsOverviewPage(
                          questionsOverviewCubit: questionsOverviewCubit,
                        ),
                        const ResultsPage(),
                      ],
                    );
                  }

                  return Container();
                },
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

class _Screens extends StatelessWidget {
  const _Screens({
    required this.currentScreenIndex,
    required this.screens,
  });

  final int currentScreenIndex;
  final List<Widget> screens;

  @override
  Widget build(BuildContext context) {
    if (currentScreenIndex < 0 || currentScreenIndex >= screens.length) {
      return Container();
    }

    return screens.elementAt(currentScreenIndex);
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.index,
    required this.onItemTapped,
    super.key,
  });

  final int index;
  final void Function(int newIndex) onItemTapped;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return BottomNavigationBar(
      currentIndex: index,
      backgroundColor: themeColors?.backgroundColors.tertiary,
      unselectedItemColor: themeColors?.textColors.primary,
      selectedIconTheme: const IconThemeData(size: 30),
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          label: S.of(context).assessmentsSectionDisplayName,
          icon: const Icon(MdiIcons.schoolOutline),
          activeIcon: const Icon(MdiIcons.school),
        ),
        BottomNavigationBarItem(
          label: S.of(context).questionsSectionDisplayName,
          icon: const Icon(MdiIcons.databaseOutline),
          activeIcon: const Icon(MdiIcons.database),
        ),
        BottomNavigationBarItem(
          label: S.of(context).resultsSectionDisplayName,
          icon: const Icon(MdiIcons.cardBulletedOutline),
          activeIcon: const Icon(MdiIcons.cardBulleted),
        ),
      ],
    );
  }
}
