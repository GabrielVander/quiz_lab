import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/view_models/questions_overview_view_model.dart';

void main() {
  group('copyWith', () {
    group(
      'should copy correctly',
      () {
        for (final values in [
          [
            const QuestionsOverviewItemViewModel(
              id: '',
              shortDescription: '',
              description: '',
              categories: [],
              difficulty: '',
            ),
            const QuestionsOverviewItemViewModel(
              id: '&6m',
              shortDescription: 'vZow',
              description: 'L#SHde',
              categories: ['wD1h', 'q#iUA', '2@C6'],
              difficulty: '6NZ',
            ),
          ],
          [
            const QuestionsOverviewItemViewModel(
              id: '&6m',
              shortDescription: 'vZow',
              description: 'L#SHde',
              categories: ['wD1h', 'q#iUA', '2@C6'],
              difficulty: '6NZ',
            ),
            const QuestionsOverviewItemViewModel(
              id: '',
              shortDescription: '',
              description: '',
              categories: [],
              difficulty: '',
            ),
          ]
        ]) {
          test(values.toString(), () {
            final original = values[0];
            final expected = values[1];

            final actual = original.copyWith(
              id: expected.id,
              shortDescription: expected.shortDescription,
              description: expected.description,
              categories: expected.categories,
              difficulty: expected.difficulty,
            );

            expect(actual, expected);
          });
        }
      },
    );

    group(
      'should return original',
      () {
        for (final original in [
          const QuestionsOverviewItemViewModel(
            id: '',
            shortDescription: '',
            description: '',
            categories: [],
            difficulty: '',
          ),
          const QuestionsOverviewItemViewModel(
            id: '&6m',
            shortDescription: 'vZow',
            description: 'L#SHde',
            categories: ['wD1h', 'q#iUA', '2@C6'],
            difficulty: '6NZ',
          ),
        ]) {
          test(original.toString(), () {
            final actual = original.copyWith();

            expect(actual, original);
          });
        }
      },
    );
  });
}
