import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:quiz_lab/core/presentation/widgets/network_checker.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.networkCubit,
    required this.bottomNavigationCubit,
    required this.questionsOverviewCubit,
    required this.child,
    super.key,
  });

  final NetworkCubit networkCubit;
  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;
  final Widget child;

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
            bottomNavigationBar: MainBottomNavBar(
              key: const ValueKey<String>('navBar'),
              bottomNavigationCubit: bottomNavigationCubit,
            ),
            body: NetworkChecker(
              cubit: networkCubit,
              child: child,
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
