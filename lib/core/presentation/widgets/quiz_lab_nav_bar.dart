import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../themes/extensions.dart';

class QuizLabNavBar extends StatelessWidget {
  const QuizLabNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>();

    return BottomNavigationBar(
      backgroundColor: themeColors?.backgroundColors.tertiary,
      items: const [
        BottomNavigationBarItem(
          label: 'Assessments',
          icon: Icon(MdiIcons.schoolOutline),
        ),
        BottomNavigationBarItem(
          label: 'Questions',
          icon: Icon(MdiIcons.database),
        ),
        BottomNavigationBarItem(
          label: 'Results',
          icon: Icon(MdiIcons.cardBulleted),
        ),
      ],
    );
  }
}
