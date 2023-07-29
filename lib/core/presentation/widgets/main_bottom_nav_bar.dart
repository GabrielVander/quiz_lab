import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/generated/l10n.dart';

class MainBottomNavBar extends HookWidget {
  const MainBottomNavBar({
    required this.bottomNavigationCubit,
    super.key,
  });

  final BottomNavigationCubit bottomNavigationCubit;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    final buildWhen = [
      BottomNavigationInitial,
      BottomNavigationIndexChangedState,
    ];

    useBlocListener(
      bottomNavigationCubit,
      listenWhen: (current) => current is BottomNavigationNavigateToRoute,
      (bloc, current, context) {
        if (current is BottomNavigationNavigateToRoute) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).goNamed(current.route.name);
          });
        }
      },
    );

    final bottomNavigationState =
        useBlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      bottomNavigationCubit,
      buildWhen: (current) => buildWhen.contains(current.runtimeType),
    );

    final currentIndex =
        bottomNavigationState is BottomNavigationIndexChangedState
            ? bottomNavigationState.newIndex
            : NavigationIndex.questions.index;

    return HookBuilder(
      builder: (context) => BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: themeColors?.backgroundColors.tertiary,
        unselectedItemColor: themeColors?.textColors.primary,
        selectedIconTheme: const IconThemeData(size: 30),
        onTap: (int newIndex) =>
            bottomNavigationCubit.transitionTo(newIndex: newIndex),
        items: [
          BottomNavigationBarItem(
            label: S.of(context).assessmentsSectionDisplayName,
            icon: const Icon(Icons.ballot_outlined),
            activeIcon: const Icon(Icons.ballot),
          ),
          BottomNavigationBarItem(
            label: S.of(context).questionsSectionDisplayName,
            icon: const Icon(Icons.question_answer_outlined),
            activeIcon: const Icon(Icons.question_answer),
          ),
          BottomNavigationBarItem(
            label: S.of(context).resultsSectionDisplayName,
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
    );
  }
}
