import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

void main() {
  late QuestionEntityMapper mapper;

  setUp(() {
    mapper = QuestionEntityMapper();
  });

  group('singleFromQuestionOverviewItemViewModel', () {
    group('err flow', () {
      parameterizedTest(
        'should fail',
        ParameterizedSource.values([
          [
            const QuestionOverviewItemViewModel(
              id: '',
              shortDescription: '',
              description: '',
              categories: [],
              difficulty: '',
            ),
            QuestionEntityMapperFailure.unexpectedDifficultyValue(value: ''),
          ],
          [
            const QuestionOverviewItemViewModel(
              id: '6kP3Ec',
              shortDescription: '!Es2m4!',
              description: '2o5#^@',
              categories: ['3#I', '%8@N8Wm!', '*A&'],
              difficulty: '1W1R',
            ),
            QuestionEntityMapperFailure.unexpectedDifficultyValue(
              value: '1W1R',
            ),
          ],
        ]),
        (values) {
          final viewModel = values[0] as QuestionOverviewItemViewModel;
          final expectedFailure = values[1] as QuestionEntityMapperFailure;

          final result =
              mapper.singleFromQuestionOverviewItemViewModel(viewModel);

          expect(result.isErr, true);
          expect(result.err, expectedFailure);
        },
      );
    });

    group('ok flow', () {
      parameterizedTest(
        'should map correctly',
        ParameterizedSource.values([
          [
            const QuestionOverviewItemViewModel(
              id: '',
              shortDescription: '',
              description: '',
              categories: [],
              difficulty: 'unknown',
            ),
            const Question(
              id: '',
              shortDescription: '',
              description: '',
              answerOptions: [],
              categories: [],
              difficulty: QuestionDifficulty.unknown,
            )
          ],
          [
            const QuestionOverviewItemViewModel(
              id: 'hiTGMK',
              shortDescription: 'Ico',
              description: '9J7c',
              categories: [
                'GcroY&',
                '9vmI4c',
                'Zra7R#',
              ],
              difficulty: 'easy',
            ),
            const Question(
              id: 'hiTGMK',
              shortDescription: 'Ico',
              description: '9J7c',
              answerOptions: [],
              categories: [
                QuestionCategory(value: 'GcroY&'),
                QuestionCategory(value: '9vmI4c'),
                QuestionCategory(value: 'Zra7R#'),
              ],
              difficulty: QuestionDifficulty.easy,
            )
          ],
        ]),
        (values) {
          final viewModel = values[0] as QuestionOverviewItemViewModel;
          final expectedQuestion = values[1] as Question;

          final result =
              mapper.singleFromQuestionOverviewItemViewModel(viewModel);

          expect(result.isOk, true);
          expect(result.ok, expectedQuestion);
        },
      );
    });
  });
}
