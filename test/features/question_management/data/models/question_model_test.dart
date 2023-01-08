import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';

void main() {
  group('toMap', () {
    for (final testCase in [
      const _ToMapTestCase(
        model: HiveQuestionModel(
          id: 'id',
          description: 'description',
          shortDescription: 'shortDescription',
          difficulty: 'difficulty',
          categories: [],
          options: [],
        ),
        expected: <String, dynamic>{
          'description': 'description',
          'shortDescription': 'shortDescription',
          'difficulty': 'difficulty',
          'options': <Map<String, dynamic>>[],
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
          options: [
            {'description': 'Dia%K', 'isCorrect': false},
            {'description': '@eKc%C#6', 'isCorrect': true},
          ],
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
          'options': <Map<String, dynamic>>[
            <String, dynamic>{
              'description': 'Dia%K',
              'isCorrect': false,
            },
            <String, dynamic>{
              'description': '@eKc%C#6',
              'isCorrect': true,
            },
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

class _ToMapTestCase {
  const _ToMapTestCase({
    required this.model,
    required this.expected,
  });

  final HiveQuestionModel model;
  final Map<String, dynamic> expected;
}
