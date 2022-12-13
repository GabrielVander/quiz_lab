import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/themes/extensions.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuizLabNavBar extends HookWidget {
  const QuizLabNavBar({
    super.key,
    required this.bottomNavigationCubit,
  });

  final BottomNavigationCubit bottomNavigationCubit;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();
    final BottomNavigationState state = useBlocBuilder(bottomNavigationCubit);
    final index = _getNavIndex(state);

    return BottomNavigationBar(
      currentIndex: index,
      backgroundColor: themeColors?.backgroundColors.tertiary,
      unselectedItemColor: themeColors?.textColors.primary,
      selectedIconTheme: const IconThemeData(size: 30),
      onTap: (int newIndex) =>
          bottomNavigationCubit.transitionTo(newIndex: newIndex),
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

  int _getNavIndex(BottomNavigationState state) {
    if (state is BottomNavigationIndexChangedState) {
      return state.newIndex;
    }

    return 0;
  }
}
