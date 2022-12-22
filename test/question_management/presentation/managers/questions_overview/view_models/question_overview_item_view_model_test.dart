import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

void main() {
  group('copyWith', () {
    parameterizedTest(
      'should copy correctly',
      ParameterizedSource.values([
        [
          const QuestionOverviewItemViewModel(
            id: '',
            shortDescription: '',
            description: '',
            categories: [],
            difficulty: '',
          ),
          const QuestionOverviewItemViewModel(
            id: '&6m',
            shortDescription: 'vZow',
            description: 'L#SHde',
            categories: ['wD1h', 'q#iUA', '2@C6'],
            difficulty: '6NZ',
          )
        ],
        [
          const QuestionOverviewItemViewModel(
            id: '&6m',
            shortDescription: 'vZow',
            description: 'L#SHde',
            categories: ['wD1h', 'q#iUA', '2@C6'],
            difficulty: '6NZ',
          ),
          const QuestionOverviewItemViewModel(
            id: '',
            shortDescription: '',
            description: '',
            categories: [],
            difficulty: '',
          )
        ]
      ]),
      (values) {
        final original = values[0] as QuestionOverviewItemViewModel;
        final expected = values[1] as QuestionOverviewItemViewModel;

        final actual = original.copyWith(
          id: expected.id,
          shortDescription: expected.shortDescription,
          description: expected.description,
          categories: expected.categories,
          difficulty: expected.difficulty,
        );

        expect(actual, expected);
      },
    );

    parameterizedTest(
      'should return original',
      ParameterizedSource.value([
        const QuestionOverviewItemViewModel(
          id: '',
          shortDescription: '',
          description: '',
          categories: [],
          difficulty: '',
        ),
        const QuestionOverviewItemViewModel(
          id: '&6m',
          shortDescription: 'vZow',
          description: 'L#SHde',
          categories: ['wD1h', 'q#iUA', '2@C6'],
          difficulty: '6NZ',
        ),
      ]),
      (values) {
        final original = values[0] as QuestionOverviewItemViewModel;

        final actual = original.copyWith();

        expect(actual, original);
      },
    );
  });
}
