import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  late QuestionEntityMapper mapper;

  setUp(() {
    mapper = QuestionEntityMapper();
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
              options: [],
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
              options: [],
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
              options: [],
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
              options: [],
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
              options: [],
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
              options: [],
            ),
            QuestionMapperFailure.unableToParseDifficulty(
              receivedValue: 'xYaH',
              possibleValues: const ['easy', 'medium', 'hard', 'unknown'],
            ),
          ],
          [
            const HiveQuestionModel(
              id: 'dtBn',
              shortDescription: 'n3Y2HS',
              description: 'c7c',
              difficulty: 'lb6',
              categories: [],
              options: [],
            ),
            QuestionMapperFailure.unableToParseDifficulty(
              receivedValue: 'lb6',
              possibleValues: const ['easy', 'medium', 'hard', 'unknown'],
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
              options: [
                {'description': 'p%y@@4E', 'isCorrect': true},
                {'description': '1@9qmkr3', 'isCorrect': false},
              ],
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
              answerOptions: [
                AnswerOption(description: 'p%y@@4E', isCorrect: true),
                AnswerOption(description: '1@9qmkr3', isCorrect: false),
              ],
            ),
          ],
          [
            const HiveQuestionModel(
              id: '!!LY',
              shortDescription: 'W7*',
              description: r'7$N8XGnF',
              difficulty: 'medium',
              categories: ['tagPaD', 'wkF5', '#s1ZIz#'],
              options: [
                {'description': 'K@4v#6', 'isCorrect': true},
                {'description': r'K6443$x@', 'isCorrect': false},
              ],
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
              answerOptions: [
                AnswerOption(description: 'K@4v#6', isCorrect: true),
                AnswerOption(description: r'K6443$x@', isCorrect: false),
              ],
            ),
          ],
          [
            const HiveQuestionModel(
              id: 'd%6*k^',
              shortDescription: '*ANk0',
              description: r'&$^@eZA3',
              difficulty: 'hard',
              categories: ['7D%&P2', 'TPAB', '3JB6^o'],
              options: [
                {'description': 'Ddo', 'isCorrect': true},
                {'description': r'*!$', 'isCorrect': false},
              ],
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
              answerOptions: [
                AnswerOption(description: 'Ddo', isCorrect: true),
                AnswerOption(description: r'*!$', isCorrect: false),
              ],
            ),
          ],
          [
            const HiveQuestionModel(
              id: 'd%6*k^',
              shortDescription: '*ANk0',
              description: r'&$^@eZA3',
              difficulty: 'unknown',
              categories: ['7D%&P2', 'TPAB', '3JB6^o'],
              options: [
                {'description': '0RK', 'isCorrect': true},
                {'description': 'sQaD7!Y', 'isCorrect': false},
              ],
            ),
            const Question(
              id: 'd%6*k^',
              shortDescription: '*ANk0',
              description: r'&$^@eZA3',
              difficulty: QuestionDifficulty.unknown,
              categories: [
                QuestionCategory(value: '7D%&P2'),
                QuestionCategory(value: 'TPAB'),
                QuestionCategory(value: '3JB6^o')
              ],
              answerOptions: [
                AnswerOption(
                  description: '0RK',
                  isCorrect: true,
                ),
                AnswerOption(
                  description: 'sQaD7!Y',
                  isCorrect: false,
                ),
              ],
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
