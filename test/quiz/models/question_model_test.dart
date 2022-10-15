import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/models/question_model.dart';

void main() {
  group('toString', () {
    for (final testCase in [
      const _ToStringTestCase(
        model: QuestionModel(
          id: 'id',
          description: 'description',
          shortDescription: 'shortDescription',
          difficulty: 'difficulty',
          categories: [],
        ),
        expected: 'QuestionModel{ id: id, shortDescription: shortDescription, '
            'description: description, difficulty: difficulty, '
            'categories: [], }',
      ),
      const _ToStringTestCase(
        model: QuestionModel(
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
}

class _ToStringTestCase {
  const _ToStringTestCase({
    required this.model,
    required this.expected,
  });

  final QuestionModel model;
  final String expected;
}
