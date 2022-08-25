import 'package:flutter/material.dart';
import 'package:quiz_lab/core/assets/images.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';

class UnderConstruction extends StatelessWidget {
  const UnderConstruction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          Images.forklift,
          height: _getForkliftImageHeight(context),
        ),
        const SizedBox(
          height: 25,
        ),
        const Description(),
      ],
    );
  }

  double _getForkliftImageHeight(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 175;
          case TabletBreakpoint:
            return 250;
          case DesktopBreakpoint:
            return 300;
          default:
            return 190;
        }
      },
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _getFontSize(context);

    return Text(
      "We're still working on that!",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 24;
          case TabletBreakpoint:
            return 28;
          case DesktopBreakpoint:
            return 32;
          default:
            return 26;
        }
      },
    );
  }
}
