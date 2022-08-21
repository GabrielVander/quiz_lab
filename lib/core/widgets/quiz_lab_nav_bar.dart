import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/themes/extensions.dart';

class QuizLabNavBar extends StatelessWidget {
  const QuizLabNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return BottomNavigationBar(
      backgroundColor: themeColors?.backgroundColors.tertiary,
      unselectedItemColor: themeColors?.textColors.primary,
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
}
