import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_appwrite_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  late AppwriteDataSource appwriteDataSourceMock;

  late QuestionRepositoryAppwriteImpl repository;

  setUp(() {
    appwriteDataSourceMock = _AppwriteDataSourceMock();

    repository = QuestionRepositoryAppwriteImpl(
      appwriteDataSource: appwriteDataSourceMock,
    );
  });

  group('createSingle()', () {
    setUp(() {
      mocktail.registerFallbackValue(
        const AppwriteQuestionCreationModel(
          title: '',
          description: '',
          options: [],
          difficulty: 'easy',
          categories: [],
          id: '',
        ),
      );
    });

    parameterizedTest(
        'should call Appwrite data source correctly',
        ParameterizedSource.values([
          [
            const Question(
              id: '',
              shortDescription: '',
              description: '',
              answerOptions: [],
              difficulty: QuestionDifficulty.easy,
              categories: [],
            ),
            const AppwriteQuestionCreationModel(
              title: '',
              description: '',
              options: [],
              difficulty: 'easy',
              categories: [],
              id: '',
            )
          ],
          [
            const Question(
              id: 'hqWk^#',
              shortDescription: r'1HFm$Ny',
              description: 'g18QU',
              answerOptions: [
                AnswerOption(description: '!nC#', isCorrect: false),
              ],
              difficulty: QuestionDifficulty.medium,
              categories: [
                QuestionCategory(value: 'Az75%p8'),
              ],
            ),
            const AppwriteQuestionCreationModel(
              id: 'hqWk^#',
              title: r'1HFm$Ny',
              description: 'g18QU',
              options: [
                AppwriteQuestionOptionModel(
                  description: '!nC#',
                  isCorrect: false,
                ),
              ],
              difficulty: 'medium',
              categories: [
                'Az75%p8',
              ],
            )
          ],
          [
            const Question(
              id: 'H00D4',
              shortDescription: '79FgDD',
              description: r'N915*v$R',
              answerOptions: [
                AnswerOption(description: 'nh92Pe6', isCorrect: true),
                AnswerOption(description: r'0N2W%S$', isCorrect: true),
                AnswerOption(description: '@W2', isCorrect: true),
              ],
              difficulty: QuestionDifficulty.hard,
              categories: [
                QuestionCategory(value: '40eb2q'),
                QuestionCategory(value: 'k4h'),
                QuestionCategory(value: '7h5M!fse'),
                QuestionCategory(value: 'Ea5'),
              ],
            ),
            const AppwriteQuestionCreationModel(
              id: 'H00D4',
              title: '79FgDD',
              description: r'N915*v$R',
              options: [
                AppwriteQuestionOptionModel(
                  description: 'nh92Pe6',
                  isCorrect: true,
                ),
                AppwriteQuestionOptionModel(
                  description: r'0N2W%S$',
                  isCorrect: true,
                ),
                AppwriteQuestionOptionModel(
                  description: '@W2',
                  isCorrect: true,
                ),
              ],
              difficulty: 'hard',
              categories: [
                '40eb2q',
                'k4h',
                '7h5M!fse',
                'Ea5',
              ],
            )
          ],
        ]), (values) async {
      final question = values[0] as Question;
      final expected = values[1] as AppwriteQuestionCreationModel;

      mocktail
          .when(() => appwriteDataSourceMock.createQuestion(mocktail.any()))
          .thenAnswer(
            (_) async =>
                Result.err(AppwriteDataSourceFailure.unexpected(Exception())),
          );

      await repository.createSingle(question);

      mocktail
          .verify(() => appwriteDataSourceMock.createQuestion(expected))
          .called(1);
    });

    test('should return expected', () async {
      mocktail
          .when(() => appwriteDataSourceMock.createQuestion(mocktail.any()))
          .thenAnswer(
            (_) async => Result.ok(_AppwriteQuestionCreationModelMock()),
          );

      final result = await repository.createSingle(
        const Question(
          id: '',
          shortDescription: '',
          description: '',
          answerOptions: [],
          difficulty: QuestionDifficulty.easy,
          categories: [],
        ),
      );

      expect(result.isOk, true);
      expect(result.ok, unit);
    });
  });

  group('watchAll()', () {});
}

class _AppwriteDataSourceMock extends mocktail.Mock
    implements AppwriteDataSource {}

class _AppwriteQuestionCreationModelMock extends mocktail.Mock
    implements AppwriteQuestionCreationModel {}
