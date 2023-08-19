import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_realtime_message_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late QuizLabLogger logger;
  late AppwriteDataSource appwriteDataSourceMock;
  late QuestionCollectionAppwriteDataSourceImpl questionsAppwriteDataSourceMock;

  late QuestionRepositoryImpl repository;

  setUp(() {
    logger = _MockQuizLabLogger();
    appwriteDataSourceMock = _MockAppwriteDataSource();
    questionsAppwriteDataSourceMock = _MockQuestionsAppwriteDataSource();

    repository = QuestionRepositoryImpl(
      logger: logger,
      appwriteDataSource: appwriteDataSourceMock,
      questionsAppwriteDataSource: questionsAppwriteDataSourceMock,
    );
  });

  tearDown(resetMocktailState);

  group(
    'createSingle()',
    () {
      setUp(
        () => registerFallbackValue(
          const AppwriteQuestionCreationModel(
            title: '',
            description: '',
            options: [],
            difficulty: 'easy',
            categories: [],
            id: '',
          ),
        ),
      );

      test('should log initial message', () {
        when(() => questionsAppwriteDataSourceMock.createSingle(any())).thenAnswer((_) async => const Err('dALlzcb'));

        repository.createSingle(
          const Question(
            id: QuestionId(''),
            shortDescription: '',
            description: '',
            answerOptions: [],
            difficulty: QuestionDifficulty.easy,
            categories: [],
          ),
        );

        verify(() => logger.debug('Creating question...')).called(1);
      });

      for (final values in [
        (
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
        ),
        (
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
            isPublic: true,
          ),
          AppwriteQuestionCreationModel(
            id: 'hqWk^#',
            title: r'1HFm$Ny',
            description: 'g18QU',
            options: const [
              AppwriteQuestionOptionModel(
                description: '!nC#',
                isCorrect: false,
              ),
            ],
            difficulty: 'medium',
            categories: const [
              'Az75%p8',
            ],
            permissions: [AppwritePermissionTypeModel.read(AppwritePermissionRoleModel.any())],
          )
        ),
        (
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
        ),
      ]) {
        final question = values.$1;
        final expected = values.$2;

        group(
          'when given $question should call appwrite data source with $expected',
          () {
            setUp(() {
              registerFallbackValue(
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

            for (final message in ['dyu7oXw', 'c4cnG6i']) {
              test(
                'and return error if it fails with message $message',
                () async {
                  when(
                    () => questionsAppwriteDataSourceMock.createSingle(expected),
                  ).thenAnswer((_) async => Err(message));

                  final result = await repository.createSingle(question);

                  verify(() => logger.error(message)).called(1);
                  expect(
                    result,
                    const Err<Unit, String>('Failed to create question'),
                  );
                },
              );
            }

            test('and return ok if it succeeds', () async {
              when(() => questionsAppwriteDataSourceMock.createSingle(expected))
                  .thenAnswer((_) async => Ok(_MockAppwriteQuestionModel()));

              final result = await repository.createSingle(question);

              verify(() => logger.debug('Question created successfully')).called(1);
              expect(result, const Ok<Unit, String>(unit));
            });
          },
        );
      }
    },
  );

  group('watchAll()', () {
    group(
      'should fetch questions on every update',
      () {
        for (final amountOfUpdates in [
          0,
          // 1, mocktail does not register calls made inside a callback
          // 3, mocktail does not register calls made inside a callback
          // 99, mocktail does not register calls made inside a callback
        ]) {
          test(amountOfUpdates.toString(), () async {
            final appwriteQuestionListModelMock = _MockAppwriteQuestionListModel();

            final updateMessages = List.generate(
              amountOfUpdates,
              (_) => _MockAppwriteRealtimeQuestionMessageModel(),
            );

            final stream = Stream.fromIterable(updateMessages);

            when(
              () => appwriteDataSourceMock.watchForQuestionCollectionUpdate(),
            ).thenAnswer((_) => stream);

            when(() => appwriteQuestionListModelMock.total).thenReturn(0);
            when(() => appwriteQuestionListModelMock.questions).thenReturn([]);

            when(() => appwriteDataSourceMock.getAllQuestions()).thenAnswer((_) async => appwriteQuestionListModelMock);

            await repository.watchAll();

            verify(
              () => appwriteDataSourceMock.watchForQuestionCollectionUpdate(),
            );

            verify(() => appwriteDataSourceMock.getAllQuestions()).called(amountOfUpdates + 1);
          });
        }
      },
    );

    group(
      'should emit expected',
      () {
        for (final values in [
          [const AppwriteQuestionListModel(total: 0, questions: []), <Question>[]],
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
                ),
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
              ),
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
                ),
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
              ),
            ]
          ],
        ]) {
          test(values.toString(), () async {
            final appwriteQuestionListModel = values[0] as AppwriteQuestionListModel;
            final expected = values[1] as List<Question>;

            when(
              () => appwriteDataSourceMock.watchForQuestionCollectionUpdate(),
            ).thenAnswer(
              (_) => const Stream.empty(),
            );

            when(() => appwriteDataSourceMock.getAllQuestions()).thenAnswer((_) async => appwriteQuestionListModel);

            final result = await repository.watchAll();

            expect(result.isOk, true);
            expect(result.unwrap(), emits(expected));
          });
        }
      },
    );
  });

  group(
    'deleteSingle()',
    () {
      group(
        'should call questions Appwrite data source correctly',
        () {
          for (final questionId in [
            const QuestionId(''),
            const QuestionId('olp'),
          ]) {
            test(questionId.toString(), () {
              when(
                () => questionsAppwriteDataSourceMock.deleteSingle(any()),
              ).thenAnswer(
                (_) async => Err(
                  QuestionsAppwriteDataSourceUnexpectedFailure(r'T8$W7'),
                ),
              );

              repository.deleteSingle(questionId);

              verify(
                () => questionsAppwriteDataSourceMock.deleteSingle(questionId.value),
              ).called(1);
            });
          }
        },
      );

      test(
        'should call return nothing if questions Appwrite data source succeeds',
        () async {
          when(
            () => questionsAppwriteDataSourceMock.deleteSingle(any()),
          ).thenAnswer(
            (_) async => const Ok(unit),
          );

          final result = await repository.deleteSingle(const QuestionId('6xSamAUC'));

          expect(result.isOk, true);
          expect(result.unwrap(), unit);
        },
      );

      group(
        'should return expected failure when questions Appwrite data source '
        'fails',
        () {
          for (final values in [
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
          ]) {
            test(values.toString(), () async {
              final dataSourceFailure = values[0] as QuestionsAppwriteDataSourceFailure;
              final expected = values[1] as QuestionRepositoryFailure;

              when(
                () => questionsAppwriteDataSourceMock.deleteSingle(any()),
              ).thenAnswer((_) async => Err(dataSourceFailure));

              final result = await repository.deleteSingle(const QuestionId('cNPJl@*x'));

              expect(result.isErr, true);
              expect(result.unwrapErr(), expected);
            });
          }
        },
      );
    },
  );

  group('getSingle()', () {
    group(
      'should call questions Appwrite data source correctly',
      () {
        for (final questionId in [
          '',
          'P6m74A',
        ]) {
          test(questionId, () {
            when(
              () => questionsAppwriteDataSourceMock.fetchSingle(any()),
            ).thenAnswer(
              (_) async => Err(
                QuestionsAppwriteDataSourceUnexpectedFailure('X90^#SU'),
              ),
            );

            repository.getSingle(QuestionId(questionId));

            verify(
              () => questionsAppwriteDataSourceMock.fetchSingle(questionId),
            );
          });
        }
      },
    );

    test(
      'should map question appwrite model to question entity and return it',
      () async {
        final appwriteQuestionModelMock = _MockAppwriteQuestionModel();
        final questionMock = _MockQuestion();

        when(appwriteQuestionModelMock.toQuestion).thenReturn(questionMock);

        when(
          () => questionsAppwriteDataSourceMock.fetchSingle(any()),
        ).thenAnswer((_) async => Ok(appwriteQuestionModelMock));

        final result = await repository.getSingle(const QuestionId('o^Y*lN'));

        expect(result.isOk, true);
        expect(result.unwrap(), questionMock);
      },
    );

    group(
      'should return expected failure when questions Appwrite data source '
      'fails',
      () {
        for (final values in [
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
        ]) {
          test(values.toString(), () async {
            final dataSourceFailure = values[0] as QuestionsAppwriteDataSourceFailure;
            final expected = values[1] as QuestionRepositoryFailure;

            when(
              () => questionsAppwriteDataSourceMock.fetchSingle(any()),
            ).thenAnswer((_) async => Err(dataSourceFailure));

            final result = await repository.getSingle(const QuestionId('2%E5%'));

            expect(result.isErr, true);
            expect(result.unwrapErr(), expected);
          });
        }
      },
    );
  });

  group('updateSingle', () {
    test('unimplemented', () {
      expect(
        () async => repository.updateSingle(_MockQuestion()),
        throwsUnimplementedError,
      );
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockAppwriteDataSource extends Mock implements AppwriteDataSource {}

class _MockAppwriteRealtimeQuestionMessageModel extends Mock implements AppwriteRealtimeQuestionMessageModel {}

class _MockAppwriteQuestionListModel extends Mock implements AppwriteQuestionListModel {}

class _MockQuestionsAppwriteDataSource extends Mock implements QuestionCollectionAppwriteDataSourceImpl {}

class _MockAppwriteQuestionModel extends Mock implements AppwriteQuestionModel {}

class _MockQuestion extends Mock implements Question {}
