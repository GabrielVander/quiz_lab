import 'package:flutter/material.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/core/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/core/widgets/quiz_lab_nav_bar.dart';
import 'package:quiz_lab/core/widgets/under_construction.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

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
              dependencyInjection: dependencyInjection,
            ),
            body: const Center(
              child: UnderConstruction(),
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
