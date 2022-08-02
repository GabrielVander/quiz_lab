import 'package:flutter_parameterized_test/flutter_parameterized_test.dart'
    show ParameterizedSource, parameterizedTest;
import 'package:flutter_test/flutter_test.dart' show expect, group, setUp, test;
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart'
    show BoundType, DesktopBreakpoint, MobileBreakpoint, TabletBreakpoint;

void main() {
  group('MobileBreakpoint', () {
    late MobileBreakpoint breakpoint;

    setUp(() {
      breakpoint = MobileBreakpoint();
    });

    test('value matches', () {
      expect(breakpoint.value, 600);
    });

    test('bound type matches', () {
      expect(breakpoint.boundType, BoundType.upperBound);
    });

    parameterizedTest(
      'applies',
      ParameterizedSource.values([
        [.0, true],
        [.9, true],
        [1.0, true],
        [300.0, true],
        [599.9, true],
        [600.0, true],
        [600.1, false],
        [601.0, false],
        [999.9, false],
      ]),
      (List<dynamic> testCases) {
        final measurement = testCases[0] as double;
        final shouldApply = testCases[1] as bool;

        final result = breakpoint.applies(measurement);

        expect(result, shouldApply);
      },
    );
  });

  group('TabletBreakpoint', () {
    late TabletBreakpoint breakpoint;

    setUp(() {
      breakpoint = TabletBreakpoint();
    });

    test('value matches', () {
      expect(breakpoint.value, 600);
    });

    test('bound type matches', () {
      expect(breakpoint.boundType, BoundType.lowerBound);
    });

    parameterizedTest(
      'applies',
      ParameterizedSource.values([
        [599.0, false],
        [599.9, false],
        [600.0, true],
        [600.1, true],
        [601.0, true],
        [999.9, true],
      ]),
      (List<dynamic> testCases) {
        final measurement = testCases[0] as double;
        final shouldApply = testCases[1] as bool;

        final result = breakpoint.applies(measurement);

        expect(result, shouldApply);
      },
    );
  });

  group('DesktopBreakpoint', () {
    late DesktopBreakpoint breakpoint;

    setUp(() {
      breakpoint = DesktopBreakpoint();
    });

    test('value matches', () {
      expect(breakpoint.value, 992);
    });

    test('bound type matches', () {
      expect(breakpoint.boundType, BoundType.lowerBound);
    });

    parameterizedTest(
      'applies',
      ParameterizedSource.values([
        [991.0, false],
        [991.9, false],
        [992.0, true],
        [992.1, true],
        [999.9, true],
      ]),
      (List<dynamic> testCases) {
        final measurement = testCases[0] as double;
        final shouldApply = testCases[1] as bool;

        final result = breakpoint.applies(measurement);

        expect(result, shouldApply);
      },
    );
  });
}
