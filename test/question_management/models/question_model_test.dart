import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/question_model.dart';

void main() {
  group('toString', () {
    for (final testCase in [
      const _ToStringTestCase(
        model: HiveQuestionModel(
          id: null,
          description: 'description',
          shortDescription: 'shortDescription',
          difficulty: 'difficulty',
          categories: [],
        ),
        expected:
            'QuestionModel{ id: null, shortDescription: shortDescription, '
            'description: description, difficulty: difficulty, '
            'categories: [], }',
      ),
      const _ToStringTestCase(
        model: HiveQuestionModel(
          id: 'PJ4',
          description: 'affair',
          shortDescription: 'exercise',
          difficulty: 'unless',
          categories: ['black', 'robbery', 'crown'],
        ),
        expected: 'QuestionModel{ id: PJ4, shortDescription: exercise, '
            'description: affair, difficulty: unless, '
            'categories: [black, robbery, crown], }',
      )
    ]) {
      test(testCase.expected, () {
        expect(testCase.model.toString(), testCase.expected);
      });
    }
  });

  group('toMap', () {
    for (final testCase in [
      const _ToMapTestCase(
        model: HiveQuestionModel(
          id: 'id',
          description: 'description',
          shortDescription: 'shortDescription',
          difficulty: 'difficulty',
          categories: [],
        ),
        expected: <String, dynamic>{
          'description': 'description',
          'shortDescription': 'shortDescription',
          'difficulty': 'difficulty',
          'categories': <String>[],
        },
      ),
      const _ToMapTestCase(
        model: HiveQuestionModel(
          id: null,
          description: 'upright',
          shortDescription: 'end',
          difficulty: 'lighten',
          categories: ['lead', 'pint', 'success'],
        ),
        expected: <String, dynamic>{
          'description': 'upright',
          'shortDescription': 'end',
          'difficulty': 'lighten',
          'categories': <String>[
            'lead',
            'pint',
            'success',
          ],
        },
      ), // const _ToStringTestCase(
    ]) {
      test(testCase.expected.toString(), () {
        expect(testCase.model.toMap(), testCase.expected);
      });
    }
  });
}

class _ToStringTestCase {
  const _ToStringTestCase({
    required this.model,
    required this.expected,
  });

  final HiveQuestionModel model;
  final String expected;
}

class _ToMapTestCase {
  const _ToMapTestCase({
    required this.model,
    required this.expected,
  });

  final HiveQuestionModel model;
  final Map<String, dynamic> expected;
}
