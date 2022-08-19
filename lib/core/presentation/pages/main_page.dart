import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_nav_bar.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final appBarHeight = ScreenBreakpoints.getValueForScreenType<double>(
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

          return Scaffold(
            appBar: QuizLabAppBar(
              key: const ValueKey<String>('quizLabAppBar'),
              padding: const EdgeInsets.all(10),
              height: appBarHeight,
            ),
            bottomNavigationBar: const QuizLabNavBar(
              key: ValueKey<String>('navBar'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text('Hello World!'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
