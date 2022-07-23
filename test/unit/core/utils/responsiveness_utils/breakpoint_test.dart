import 'package:flutter_parameterized_test/flutter_parameterized_test.dart'
    show ParameterizedSource, parameterizedTest;
import 'package:flutter_test/flutter_test.dart' show expect, group, setUp, test;
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart'
    show BoundType, MobileBreakpoint;

void main() {
  group('MobileBreakpoint', () {
    late MobileBreakpoint breakpoint;

    setUp(() {
      breakpoint = MobileBreakpoint();
    });

    test('value matches', () {
      expect(600, breakpoint.value);
    });

    test('bound type matches', () {
      expect(BoundType.lowerBound, breakpoint.boundType);
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
}
