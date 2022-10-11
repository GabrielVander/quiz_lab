import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';

void main() {
  group('toString', () {
    for (final testCase in [
      const _ToStringTestCase(
        entity: QuestionCategory(value: 'value'),
        expectedResult: 'QuestionCategory{ value: value, }',
      ),
      const _ToStringTestCase(
        entity: QuestionCategory(value: 'indoor'),
        expectedResult: 'QuestionCategory{ value: indoor, }',
      )
    ]) {
      test(testCase.expectedResult, () {
        expect(testCase.entity.toString(), testCase.expectedResult);
      });
    }
  });

  group('copyWith', () {
    group('value', () {
      for (final value in ['delay', '0E2Jj^T']) {
        test(value, () {
          const entity = QuestionCategory(value: 'value');

          final copy = entity.copyWith(value: value);

          expect(copy.value, value);
        });
      }
    });
  });

  group('props', () {
    for (final entity in [
      const QuestionCategory(value: 'value'),
    ]) {
      test(entity.toString(), () {
        expect(entity.props, [
          entity.value,
        ]);
      });
    }
  });
}

class _ToStringTestCase {
  const _ToStringTestCase({
    required this.entity,
    required this.expectedResult,
  });

  final QuestionCategory entity;
  final String expectedResult;
}
