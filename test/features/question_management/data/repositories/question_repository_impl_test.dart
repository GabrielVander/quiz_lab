import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_realtime_message_model.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late AppwriteDataSource appwriteDataSourceMock;
  late QuestionCollectionAppwriteDataSource questionsAppwriteDataSourceMock;
  late QuestionRepositoryImpl repository;

  setUp(() {
    appwriteDataSourceMock = _AppwriteDataSourceMock();
    questionsAppwriteDataSourceMock = _QuestionsAppwriteDataSourceMock();
    repository = QuestionRepositoryImpl(
      appwriteDataSource: appwriteDataSourceMock,
      questionsAppwriteDataSource: questionsAppwriteDataSourceMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

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
              id: QuestionId(''),
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
              id: QuestionId('hqWk^#'),
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
              id: QuestionId('H00D4'),
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
          .when(
            () => questionsAppwriteDataSourceMock.createSingle(mocktail.any()),
          )
          .thenAnswer(
            (_) async =>
                Result.err(QuestionsAppwriteDataSourceUnexpectedFailure('')),
          );

      await repository.createSingle(question);

      mocktail
          .verify(() => questionsAppwriteDataSourceMock.createSingle(expected))
          .called(1);
    });

    test('should return expected', () async {
      mocktail
          .when(
            () => questionsAppwriteDataSourceMock.createSingle(mocktail.any()),
          )
          .thenAnswer((_) async => Result.ok(_AppwriteQuestionModelMock()));

      final result = await repository.createSingle(
        const Question(
          id: QuestionId(''),
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

  group('watchAll()', () {
    parameterizedTest(
      'should fetch questions on every update',
      ParameterizedSource.value([
        0,
        // 1, mocktail does not register calls made inside a callback
        // 3, mocktail does not register calls made inside a callback
        // 99, mocktail does not register calls made inside a callback
      ]),
      (values) async {
        final amountOfUpdates = values[0] as int;

        final appwriteQuestionListModelMock = _AppwriteQuestionListModelMock();

        final updateMessages = List.generate(
          amountOfUpdates,
          (_) => _AppwriteRealtimeQuestionMessageModelMock(),
        );

        final stream = Stream.fromIterable(updateMessages);

        mocktail
            .when(
              () => appwriteDataSourceMock.watchForQuestionCollectionUpdate(),
            )
            .thenAnswer((_) => stream);

        mocktail.when(() => appwriteQuestionListModelMock.total).thenReturn(0);
        mocktail
            .when(() => appwriteQuestionListModelMock.questions)
            .thenReturn([]);

        mocktail
            .when(() => appwriteDataSourceMock.getAllQuestions())
            .thenAnswer((_) async => appwriteQuestionListModelMock);

        await repository.watchAll();

        mocktail.verify(
          () => appwriteDataSourceMock.watchForQuestionCollectionUpdate(),
        );

        mocktail
            .verify(() => appwriteDataSourceMock.getAllQuestions())
            .called(amountOfUpdates + 1);
      },
    );

    parameterizedTest(
      'should emit expected',
      ParameterizedSource.values([
        [
          const AppwriteQuestionListModel(total: 0, questions: []),
          <Question>[]
        ],
        [
          const AppwriteQuestionListModel(
            total: 1,
            questions: [
              AppwriteQuestionModel(
                id: '',
                createdAt: '',
                updatedAt: '',
                permissions: [],
                collectionId: '',
                databaseId: '',
                title: '',
                description: '',
                difficulty: '',
                options: [],
                categories: [],
              )
            ],
          ),
          <Question>[
            const Question(
              id: QuestionId(''),
              shortDescription: '',
              description: '',
              answerOptions: [],
              difficulty: QuestionDifficulty.unknown,
              categories: [],
            )
          ]
        ],
        [
          const AppwriteQuestionListModel(
            total: 3,
            questions: [
              AppwriteQuestionModel(
                id: r'PfZ*N22$',
                createdAt: 'J14ud1p^',
                updatedAt: 'GhC86Sv',
                permissions: ['OH@', '#k7', 'P3%9*Q9'],
                collectionId: 'qqB',
                databaseId: 'lJ4',
                title: 'ZosGBFx3',
                description: 'be%92n',
                difficulty: 'easy',
                options: [
                  AppwriteQuestionOptionModel(
                    description: '1Dj@',
                    isCorrect: false,
                  ),
                  AppwriteQuestionOptionModel(
                    description: 'Az^81FLU',
                    isCorrect: true,
                  ),
                  AppwriteQuestionOptionModel(
                    description: '6Wi',
                    isCorrect: false,
                  ),
                ],
                categories: ['@#Ij', '@s@urTl', '4UPz'],
              )
            ],
          ),
          <Question>[
            const Question(
              id: QuestionId(r'PfZ*N22$'),
              shortDescription: 'ZosGBFx3',
              description: 'be%92n',
              answerOptions: [
                AnswerOption(description: '1Dj@', isCorrect: false),
                AnswerOption(description: 'Az^81FLU', isCorrect: true),
                AnswerOption(description: '6Wi', isCorrect: false),
              ],
              difficulty: QuestionDifficulty.easy,
              categories: [
                QuestionCategory(value: '@#Ij'),
                QuestionCategory(value: '@s@urTl'),
                QuestionCategory(value: '4UPz'),
              ],
            )
          ]
        ],
      ]),
      (values) async {
        final appwriteQuestionListModel =
            values[0] as AppwriteQuestionListModel;
        final expected = values[1] as List<Question>;

        mocktail
            .when(
              () => appwriteDataSourceMock.watchForQuestionCollectionUpdate(),
            )
            .thenAnswer(
              (_) => const Stream.empty(),
            );

        mocktail
            .when(() => appwriteDataSourceMock.getAllQuestions())
            .thenAnswer((_) async => appwriteQuestionListModel);

        final result = await repository.watchAll();

        expect(result.isOk, true);
        expect(result.ok, emits(expected));
      },
    );
  });

  group(
    'deleteSingle()',
    () {
      parameterizedTest(
        'should call questions Appwrite data source correctly',
        ParameterizedSource.value([
          const QuestionId(''),
          const QuestionId('olp'),
        ]),
        (values) {
          final questionId = values[0] as QuestionId;

          mocktail
              .when(
                () => questionsAppwriteDataSourceMock
                    .deleteSingle(mocktail.any()),
              )
              .thenAnswer(
                (_) async => Result.err(
                  QuestionsAppwriteDataSourceUnexpectedFailure(r'T8$W7'),
                ),
              );

          repository.deleteSingle(questionId);

          mocktail
              .verify(
                () => questionsAppwriteDataSourceMock
                    .deleteSingle(questionId.value),
              )
              .called(1);
        },
      );

      test(
        'should call return nothing if questions Appwrite data source succeeds',
        () async {
          mocktail
              .when(
                () => questionsAppwriteDataSourceMock
                    .deleteSingle(mocktail.any()),
              )
              .thenAnswer(
                (_) async => const Result.ok(unit),
              );

          final result =
              await repository.deleteSingle(const QuestionId('6xSamAUC'));

          expect(result.isOk, true);
          expect(result.ok, unit);
        },
      );

      parameterizedTest(
        'should return expected failure when questions Appwrite data source '
        'fails',
        ParameterizedSource.values([
          [
            QuestionsAppwriteDataSourceUnexpectedFailure(''),
            const QuestionRepositoryUnexpectedFailure(message: ''),
          ],
          [
            QuestionsAppwriteDataSourceUnexpectedFailure('Nl5af77'),
            const QuestionRepositoryUnexpectedFailure(message: 'Nl5af77'),
          ],
          [
            QuestionsAppwriteDataSourceAppwriteFailure(''),
            const QuestionRepositoryExternalServiceErrorFailure(message: ''),
          ],
          [
            QuestionsAppwriteDataSourceAppwriteFailure(r'E!!$'),
            const QuestionRepositoryExternalServiceErrorFailure(
              message: r'E!!$',
            ),
          ],
        ]),
        (values) async {
          final dataSourceFailure =
              values[0] as QuestionsAppwriteDataSourceFailure;
          final expected = values[1] as QuestionRepositoryFailure;

          mocktail
              .when(
                () => questionsAppwriteDataSourceMock
                    .deleteSingle(mocktail.any()),
              )
              .thenAnswer((_) async => Result.err(dataSourceFailure));

          final result =
              await repository.deleteSingle(const QuestionId('cNPJl@*x'));

          expect(result.isErr, true);
          expect(result.err, expected);
        },
      );
    },
  );

  group('getSingle()', () {
    parameterizedTest(
      'should call questions Appwrite data source correctly',
      ParameterizedSource.value([
        '',
        'P6m74A',
      ]),
      (values) {
        final questionId = values[0] as String;

        mocktail
            .when(
              () => questionsAppwriteDataSourceMock.fetchSingle(mocktail.any()),
            )
            .thenAnswer(
              (_) async => Result.err(
                QuestionsAppwriteDataSourceUnexpectedFailure('X90^#SU'),
              ),
            );

        repository.getSingle(QuestionId(questionId));

        mocktail.verify(
              () => questionsAppwriteDataSourceMock.fetchSingle(questionId),
        );
      },
    );

    test(
      'should map question appwrite model to question entity and return it',
      () async {
        final appwriteQuestionModelMock = _AppwriteQuestionModelMock();
        final questionMock = _QuestionMock();

        mocktail
            .when(appwriteQuestionModelMock.toQuestion)
            .thenReturn(questionMock);

        mocktail
            .when(
              () => questionsAppwriteDataSourceMock.fetchSingle(mocktail.any()),
            )
            .thenAnswer((_) async => Result.ok(appwriteQuestionModelMock));

        final result = await repository.getSingle(const QuestionId('o^Y*lN'));

        expect(result.isOk, true);
        expect(result.ok, questionMock);
      },
    );

    parameterizedTest(
      'should return expected failure when questions Appwrite data source '
      'fails',
      ParameterizedSource.values([
        [
          QuestionsAppwriteDataSourceUnexpectedFailure(''),
          const QuestionRepositoryUnexpectedFailure(message: ''),
        ],
        [
          QuestionsAppwriteDataSourceUnexpectedFailure('RdR'),
          const QuestionRepositoryUnexpectedFailure(message: 'RdR'),
        ],
        [
          QuestionsAppwriteDataSourceAppwriteFailure(''),
          const QuestionRepositoryExternalServiceErrorFailure(message: ''),
        ],
        [
          QuestionsAppwriteDataSourceAppwriteFailure('VD4'),
          const QuestionRepositoryExternalServiceErrorFailure(
            message: 'VD4',
          ),
        ],
      ]),
      (values) async {
        final dataSourceFailure =
            values[0] as QuestionsAppwriteDataSourceFailure;
        final expected = values[1] as QuestionRepositoryFailure;

        mocktail
            .when(
              () => questionsAppwriteDataSourceMock.fetchSingle(mocktail.any()),
            )
            .thenAnswer((_) async => Result.err(dataSourceFailure));

        final result = await repository.getSingle(const QuestionId('2%E5%'));

        expect(result.isErr, true);
        expect(result.err, expected);
      },
    );
  });
}

class _AppwriteDataSourceMock extends mocktail.Mock
    implements AppwriteDataSource {}

class _AppwriteRealtimeQuestionMessageModelMock extends mocktail.Mock
    implements AppwriteRealtimeQuestionMessageModel {}

class _AppwriteQuestionListModelMock extends mocktail.Mock
    implements AppwriteQuestionListModel {}

class _QuestionsAppwriteDataSourceMock extends mocktail.Mock
    implements QuestionCollectionAppwriteDataSource {}

class _AppwriteQuestionModelMock extends mocktail.Mock
    implements AppwriteQuestionModel {}

class _QuestionMock extends mocktail.Mock implements Question {}
