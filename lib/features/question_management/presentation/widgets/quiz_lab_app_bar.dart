import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/common/ui/widgets/beta_banner_display.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/quiz_lab_icon.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Expanded(
                  child: QuizLabIcon(
                    key: ValueKey('appBarIcon'),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: Title(),
            ),
            SettingsAction(
              onPressed: () => GoRouter.of(context).pushNamed(Routes.configuration.name),
            ),
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
  const SettingsAction({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('appBarSettingsButton'),
      onPressed: onPressed,
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }
}
