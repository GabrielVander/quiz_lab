import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_icon.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';

class QuizLabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuizLabAppBar({
    required this.height,
    required this.padding,
    super.key,
  });

  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BetaBannerDisplay(
      child: Padding(
        padding: padding,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: QuizLabIcon(
                    key: ValueKey('appBarIcon'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Title(),
            ),
            SettingsAction(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 26;
          case TabletBreakpoint:
            return 36;
          case DesktopBreakpoint:
            return 42;
          default:
            return 26;
        }
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz Lab',
          key: const ValueKey('appBarTitle'),
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }
}

class SettingsAction extends StatelessWidget {
  const SettingsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('appBarSettingsButton'),
      onPressed: () => {},
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }
}
