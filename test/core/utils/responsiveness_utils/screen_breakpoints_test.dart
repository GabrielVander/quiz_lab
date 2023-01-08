import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';

void main() {
  group('getBreakpointType', () {
    test('breakpoints', () {
      expect(ScreenBreakpoints.breakpoints, [
        const MobileBreakpoint(),
        const TabletBreakpoint(),
        const DesktopBreakpoint(),
      ]);
    });
  });
}
