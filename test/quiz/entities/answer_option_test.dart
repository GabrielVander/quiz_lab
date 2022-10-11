import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/quiz/domain/entities/answer_option.dart';

void main() {
  group('toString', () {
    for (final testCase in [
      const _ToStringTestCase(
        description: 'description',
        isCorrect: false,
        expectedResult:
            'AnswerOption{ description: description, isCorrect: false, }',
      ),
      const _ToStringTestCase(
        description: 'medicine',
        isCorrect: true,
        expectedResult:
            'AnswerOption{ description: medicine, isCorrect: true, }',
      )
    ]) {
      test(testCase.expectedResult, () {
        final entity = AnswerOption(
          description: testCase.description,
          isCorrect: testCase.isCorrect,
        );

        expect(entity.toString(), testCase.expectedResult);
      });
    }
  });

  group('copyWith', () {
    group('description', () {
      for (final value in ['profit', 'mouse']) {
        test(value, () {
          const entity =
              AnswerOption(description: 'description', isCorrect: false);

          final copy = entity.copyWith(description: value);

          expect(copy.description, value);
          expect(copy.isCorrect, false);
        });
      }
    });
    group('isCorrect', () {
      for (final value in [true, false]) {
        test(value, () {
          const entity =
              AnswerOption(description: 'description', isCorrect: false);

          final copy = entity.copyWith(isCorrect: value);

          expect(copy.isCorrect, value);
          expect(copy.description, 'description');
        });
      }
    });
  });

  group('props', () {
    for (final entity in [
      const AnswerOption(description: 'description', isCorrect: false),
      const AnswerOption(description: 'draw', isCorrect: true),
    ]) {
      test(entity.toString(), () {
        expect(entity.props, [entity.description, entity.isCorrect]);
      });
    }
  });
}

class _ToStringTestCase {
  const _ToStringTestCase({
    required this.description,
    required this.isCorrect,
    required this.expectedResult,
  });

  final String description;
  final bool isCorrect;
  final String expectedResult;
}
