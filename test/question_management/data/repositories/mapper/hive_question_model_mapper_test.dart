import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  late HiveQuestionModelMapper mapper;

  setUp(() {
    mapper = HiveQuestionModelMapper();
  });

  group('fromQuestion', () {
    group('err flow', () {});

    group('ok flow', () {
      parameterizedTest(
        'should parse question correctly',
        ParameterizedSource.values([
          [
            const Question(
              id: 'Nd3t!fjX',
              shortDescription: '',
              description: '',
              answerOptions: [],
              difficulty: QuestionDifficulty.easy,
              categories: [],
            ),
            const HiveQuestionModel(
              id: 'Nd3t!fjX',
              shortDescription: '',
              description: '',
              difficulty: 'easy',
              categories: [],
            ),
          ],
          [
            const Question(
              id: '@mWpWvZ',
              shortDescription: 'wcS',
              description: 'ML9ZGlsr',
              answerOptions: [],
              difficulty: QuestionDifficulty.medium,
              categories: [QuestionCategory(value: 'jQ@wco')],
            ),
            const HiveQuestionModel(
              id: '@mWpWvZ',
              shortDescription: 'wcS',
              description: 'ML9ZGlsr',
              difficulty: 'medium',
              categories: ['jQ@wco'],
            ),
          ],
        ]),
        (values) {
          final question = values[0] as Question;
          final expected = values[1] as HiveQuestionModel;

          final result = mapper.fromQuestion(question);

          expect(result, expected);
        },
      );
    });
  });
}
