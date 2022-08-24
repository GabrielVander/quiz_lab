import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/quiz_lab_nav_bar.dart';

import '../manager/bottom_navigation/bottom_navigation_cubit.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
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
            body: Pager(
              dependencyInjection: dependencyInjection,
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
  const Pager({super.key, required this.dependencyInjection});

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    final cubit = dependencyInjection.get<BottomNavigationCubit>();
    final BottomNavigationState state = useBlocBuilder(cubit);

    switch (state.runtimeType) {
      case BottomNavigationIndexChangedState:
        return Page(
          index: (state as BottomNavigationIndexChangedState).newIndex,
        );
    }

    return Container();
  }
}

class Page extends StatelessWidget {
  const Page({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return Container();
      case 1:
        return Container();
      case 2:
        return Container();
    }

    return Container();
  }
}
