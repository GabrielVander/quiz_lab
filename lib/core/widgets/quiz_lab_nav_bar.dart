import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/themes/extensions.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class QuizLabNavBar extends HookWidget {
  const QuizLabNavBar({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final cubit = dependencyInjection.get<BottomNavigationCubit>();
    final BottomNavigationState state = useBlocBuilder(cubit);
    final index = _getNavIndex(state);

    return BottomNavigationBar(
      currentIndex: index.indexNumber,
      backgroundColor: themeColors?.backgroundColors.tertiary,
      unselectedItemColor: themeColors?.textColors.primary,
      selectedIconTheme: const IconThemeData(size: 30.0),
      onTap: (int newIndex) =>
          cubit.transitionTo(newIndex: _intAsNavIndex(newIndex)),
      items: const [
        BottomNavigationBarItem(
          label: 'Assessments',
          icon: Icon(MdiIcons.schoolOutline),
          activeIcon: Icon(MdiIcons.school),
        ),
        BottomNavigationBarItem(
          label: 'Questions',
          icon: Icon(MdiIcons.databaseOutline),
          activeIcon: Icon(MdiIcons.database),
        ),
        BottomNavigationBarItem(
          label: 'Results',
          icon: Icon(MdiIcons.cardBulletedOutline),
          activeIcon: Icon(MdiIcons.cardBulleted),
        ),
      ],
    );
  }

  NavigationIndex _getNavIndex(BottomNavigationState state) {
    if (state is BottomNavigationIndexChangedState) {
      return state.newIndex;
    }

    return NavigationIndex.assessments;
  }

  NavigationIndex _intAsNavIndex(int numberIndex) {
    switch (numberIndex) {
      case 0:
        return NavigationIndex.assessments;
      case 1:
        return NavigationIndex.questions;
      case 2:
        return NavigationIndex.results;
      default:
        return NavigationIndex.assessments;
    }
  }
}
