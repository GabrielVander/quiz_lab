import 'package:flutter/material.dart';

import '../../assets/images.dart';
import '../../utils/responsiveness_utils/breakpoint.dart';
import '../../utils/responsiveness_utils/screen_breakpoints.dart';
import 'image_message.dart';

class ForkLiftMessage extends StatelessWidget {
  const ForkLiftMessage({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final forkliftImageHeight = _getForkliftImageHeight(context);
    final fontSize = _getFontSize(context);

    return ImageMessage(
      imageAssetName: Images.forklift,
      imageHeight: forkliftImageHeight,
      message: message,
      fontSize: fontSize,
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
