import 'package:flutter/material.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';

class ScreenBreakpoints {
  static final List<Breakpoint> breakpoints = [
    const MobileBreakpoint(),
    const TabletBreakpoint(),
    const DesktopBreakpoint(),
  ];

  static Breakpoint getBreakpointType(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    breakpoints.sort(
      (Breakpoint pnt1, Breakpoint pnt2) => pnt1.value > pnt2.value ? 1 : 0,
    );

    final currentScreenBreakpoint = breakpoints.lastWhere(
      (Breakpoint pnt) => pnt.applies(screenWidth),
      orElse: UnknownBreakpoint.new,
    );

    return currentScreenBreakpoint;
  }

  static T getValueForScreenType<T>({
    required BuildContext context,
    required T Function(Breakpoint breakpoint) map,
  }) {
    final breakpoint = getBreakpointType(context);

    return map(breakpoint);
  }
}
