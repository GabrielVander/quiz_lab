import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_mapper.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  late QuestionMapper mapper;

  setUp(() {
    mapper = QuestionMapper();
  });

  group('fromHiveModel', () {
    group('err flow', () {
      parameterizedTest(
        'should return expected failure',
        ParameterizedSource.values([
          [
            const HiveQuestionModel(
              id: null,
              shortDescription: null,
              description: '%79d',
              difficulty: 'easy',
              categories: [],
            ),
            QuestionMapperFailure.missingId(),
          ],
          [
            const HiveQuestionModel(
              id: '@X4v',
              shortDescription: null,
              description: '%79d',
              difficulty: 'easy',
              categories: [],
            ),
            QuestionMapperFailure.missingShortDescription(),
          ],
          [
            const HiveQuestionModel(
              id: 'Nd3t!fjX',
              shortDescription: '98ptG',
              description: null,
              difficulty: 'medium',
              categories: [],
            ),
            QuestionMapperFailure.missingDescription(),
          ],
          [
            const HiveQuestionModel(
              id: 'zVEw9rf',
              shortDescription: 'c&QW',
              description: r'$6Hf',
              difficulty: null,
              categories: [],
            ),
            QuestionMapperFailure.missingDifficulty(),
          ],
          [
            const HiveQuestionModel(
              id: r'$oXIp%',
              shortDescription: 'asE#8',
              description: 'ijbka^eK',
              difficulty: 'hard',
              categories: null,
            ),
            QuestionMapperFailure.missingCategories(),
          ],
          [
            const HiveQuestionModel(
              id: 'd%6*k^',
              shortDescription: '*ANk0',
              description: r'&$^@eZA3',
              difficulty: 'xYaH',
              categories: [],
            ),
            QuestionMapperFailure.unableToParseDifficulty(
              receivedValue: 'xYaH',
              possibleValues: const ['easy', 'medium', 'hard'],
            ),
          ],
          [
            const HiveQuestionModel(
              id: 'dtBn',
              shortDescription: 'n3Y2HS',
              description: 'c7c',
              difficulty: 'lb6',
              categories: [],
            ),
            QuestionMapperFailure.unableToParseDifficulty(
              receivedValue: 'lb6',
              possibleValues: const ['easy', 'medium', 'hard'],
            ),
          ],
        ]),
        (values) {
          final hiveModel = values[0] as HiveQuestionModel;
          final expectedFailure = values[1] as QuestionMapperFailure;

          final result = mapper.fromHiveModel(hiveModel);

          expect(result.isErr, true);
          expect(result.err, expectedFailure);
        },
      );
    });

    group('ok flow', () {
      parameterizedTest(
        'should map model correctly',
        ParameterizedSource.values([
          [
            const HiveQuestionModel(
              id: 'dtBn',
              shortDescription: 'n3Y2HS',
              description: 'c7c',
              difficulty: 'easy',
              categories: ['a', 'b', 'c'],
            ),
            const Question(
              id: 'dtBn',
              shortDescription: 'n3Y2HS',
              description: 'c7c',
              difficulty: QuestionDifficulty.easy,
              categories: [
                QuestionCategory(value: 'a'),
                QuestionCategory(value: 'b'),
                QuestionCategory(value: 'c')
              ],
              answerOptions: [],
            ),
          ],
          [
            const HiveQuestionModel(
              id: '!!LY',
              shortDescription: 'W7*',
              description: r'7$N8XGnF',
              difficulty: 'medium',
              categories: ['tagPaD', 'wkF5', '#s1ZIz#'],
            ),
            const Question(
              id: '!!LY',
              shortDescription: 'W7*',
              description: r'7$N8XGnF',
              difficulty: QuestionDifficulty.medium,
              categories: [
                QuestionCategory(value: 'tagPaD'),
                QuestionCategory(value: 'wkF5'),
                QuestionCategory(value: '#s1ZIz#')
              ],
              answerOptions: [],
            ),
          ],
          [
            const HiveQuestionModel(
              id: 'd%6*k^',
              shortDescription: '*ANk0',
              description: r'&$^@eZA3',
              difficulty: 'hard',
              categories: ['7D%&P2', 'TPAB', '3JB6^o'],
            ),
            const Question(
              id: 'd%6*k^',
              shortDescription: '*ANk0',
              description: r'&$^@eZA3',
              difficulty: QuestionDifficulty.hard,
              categories: [
                QuestionCategory(value: '7D%&P2'),
                QuestionCategory(value: 'TPAB'),
                QuestionCategory(value: '3JB6^o')
              ],
              answerOptions: [],
            ),
          ],
        ]),
        (values) {
          final hiveModel = values[0] as HiveQuestionModel;
          final expectedQuestion = values[1] as Question;

          final result = mapper.fromHiveModel(hiveModel);

          expect(result.isOk, true);
          expect(result.ok, expectedQuestion);
        },
      );
    });
  });
}
