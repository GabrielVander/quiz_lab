import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_list_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_realtime_message_dto.dart';
import 'package:quiz_lab/common/data/dto/create_appwrite_question_dto.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_permission_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_profile_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_question_option_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_user_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/profile_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_owner.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late QuizLabLogger logger;
  late AuthAppwriteDataSource authAppwriteDataSource;
  late QuestionCollectionAppwriteDataSourceImpl questionsAppwriteDataSource;
  late ProfileCollectionAppwriteDataSource profileAppwriteDataSource;

  late QuestionRepository repository;

  setUp(() {
    logger = _MockQuizLabLogger();
    authAppwriteDataSource = _MockAuthAppwriteDataSource();
    questionsAppwriteDataSource = _MockQuestionsAppwriteDataSource();
    profileAppwriteDataSource = _MockProfileCollectionAppwriteDataSource();

    repository = QuestionRepositoryImpl(
      logger: logger,
      questionsAppwriteDataSource: questionsAppwriteDataSource,
      profileAppwriteDataSource: profileAppwriteDataSource,
      authAppwriteDataSource: authAppwriteDataSource,
    );
  });

  tearDown(resetMocktailState);

  group('createSingle()', () {
    setUp(
      () => registerFallbackValue(
        const CreateAppwriteQuestionDto(
          ownerId: null,
          title: '',
          description: '',
          options: [],
          difficulty: 'easy',
          categories: [],
        ),
      ),
    );

    test('should log initial message', () {
      when(() => authAppwriteDataSource.getCurrentUser()).thenAnswer((_) async => const Err('dALlzcb'));
      when(() => questionsAppwriteDataSource.createSingle(any())).thenAnswer((_) async => const Err('q7249j'));

      repository.createSingle(
        const DraftQuestion(
          title: '',
          description: '',
          options: [],
          difficulty: QuestionDifficulty.easy,
          categories: [],
        ),
      );

      verify(() => logger.debug('Creating question...')).called(1);
    });

    for (final values in [
      (
        const DraftQuestion(
          title: '',
          description: '',
          options: [],
          difficulty: QuestionDifficulty.easy,
          categories: [],
        ),
        const Err<String, String>('SfpYD4d'),
        const CreateAppwriteQuestionDto(
          ownerId: null,
          title: '',
          description: '',
          options: [],
          difficulty: 'easy',
          categories: [],
        )
      ),
      (
        const DraftQuestion(
          title: r'1HFm$Ny',
          description: 'g18QU',
          options: [
            AnswerOption(description: '!nC#', isCorrect: false),
          ],
          difficulty: QuestionDifficulty.medium,
          categories: [
            QuestionCategory(value: 'Az75%p8'),
          ],
          isPublic: true,
        ),
        const Err<String, String>('y7g'),
        CreateAppwriteQuestionDto(
          ownerId: null,
          title: r'1HFm$Ny',
          description: 'g18QU',
          options: const [
            AppwriteQuestionOptionDto(
              description: '!nC#',
              isCorrect: false,
            ),
          ],
          difficulty: 'medium',
          categories: const [
            'Az75%p8',
          ],
          permissions: [AppwritePermissionTypeDto.read(AppwritePermissionRoleDto.any())],
        )
      ),
      (
        const DraftQuestion(
          title: '79FgDD',
          description: r'N915*v$R',
          options: [
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
        const Ok<String, String>('RF6fL'),
        const CreateAppwriteQuestionDto(
          ownerId: 'RF6fL',
          title: '79FgDD',
          description: r'N915*v$R',
          options: [
            AppwriteQuestionOptionDto(
              description: 'nh92Pe6',
              isCorrect: true,
            ),
            AppwriteQuestionOptionDto(
              description: r'0N2W%S$',
              isCorrect: true,
            ),
            AppwriteQuestionOptionDto(
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
      final currentUserId = values.$2;
      final expected = values.$3;

      group(
        'when given question $question and current user id $currentUserId should call appwrite data source with $expected',
        () {
          setUp(() {
            registerFallbackValue(
              const CreateAppwriteQuestionDto(
                ownerId: null,
                title: '',
                description: '',
                options: [],
                difficulty: 'easy',
                categories: [],
              ),
            );
          });

          for (final message in ['dyu7oXw', 'c4cnG6i']) {
            test('and return error if it fails with message $message', () async {
              when(() => authAppwriteDataSource.getCurrentUser()).thenAnswer(
                (_) async => currentUserId.map((value) {
                  final user = _MockUserModel();
                  when(() => user.$id).thenReturn(value);

                  return user;
                }),
              );
              when(() => questionsAppwriteDataSource.createSingle(expected)).thenAnswer((_) async => Err(message));

              final result = await repository.createSingle(question);

              verify(() => logger.debug('Retrieving owner id...')).called(1);
              verify(() => logger.error(message)).called(1);
              expect(result, const Err<Unit, String>('Failed to create question'));
            });
          }

          test('and return ok if it succeeds', () async {
            when(() => authAppwriteDataSource.getCurrentUser()).thenAnswer(
              (_) async => currentUserId.map((value) {
                final user = _MockUserModel();
                when(() => user.$id).thenReturn(value);

                return user;
              }),
            );
            when(() => questionsAppwriteDataSource.createSingle(expected))
                .thenAnswer((_) async => Ok(_MockAppwriteQuestionDto()));

            final result = await repository.createSingle(question);

            verify(() => logger.debug('Question created successfully')).called(1);
            expect(result, const Ok<Unit, String>(unit));
          });
        },
      );
    }
  });

  group('watchAll()', () {
    group('should fetch questions on every update', () {
      for (final amountOfUpdates in [
        0,
        // 1, mocktail does not register calls made inside a callback
        // 3, mocktail does not register calls made inside a callback
        // 99, mocktail does not register calls made inside a callback
      ]) {
        test(amountOfUpdates.toString(), () async {
          final appwriteQuestionListModelMock = _MockAppwriteQuestionListModel();
          final updateMessages = List.generate(amountOfUpdates, (_) => _MockAppwriteRealtimeQuestionMessageModel());
          final stream = Stream.fromIterable(updateMessages);

          when(() => questionsAppwriteDataSource.watchForUpdate()).thenAnswer((_) async => Ok(stream));
          when(() => appwriteQuestionListModelMock.total).thenReturn(0);
          when(() => appwriteQuestionListModelMock.questions).thenReturn([]);
          when(() => questionsAppwriteDataSource.getAll()).thenAnswer((_) async => Ok(appwriteQuestionListModelMock));

          await repository.watchAll();

          verify(() => questionsAppwriteDataSource.watchForUpdate()).called(1);
          verify(() => questionsAppwriteDataSource.getAll()).called(amountOfUpdates + 1);
        });
      }
    });

    group('should emit expected', () {
      for (final values in [
        ((const AppwriteQuestionListDto(total: 0, questions: []), <Question>[])),
        (
          const AppwriteQuestionListDto(
            total: 1,
            questions: [
              AppwriteQuestionDto(
                id: '',
                createdAt: '',
                updatedAt: '',
                collectionId: '',
                databaseId: '',
                title: '',
                description: '',
                difficulty: '',
                options: [],
                categories: [],
                profile: null,
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
        ),
        (
          const AppwriteQuestionListDto(
            total: 3,
            questions: [
              AppwriteQuestionDto(
                id: r'PfZ*N22$',
                createdAt: 'J14ud1p^',
                updatedAt: 'GhC86Sv',
                collectionId: 'qqB',
                databaseId: 'lJ4',
                title: 'ZosGBFx3',
                description: 'be%92n',
                difficulty: 'easy',
                options: [
                  AppwriteQuestionOptionDto(
                    description: '1Dj@',
                    isCorrect: false,
                  ),
                  AppwriteQuestionOptionDto(
                    description: 'Az^81FLU',
                    isCorrect: true,
                  ),
                  AppwriteQuestionOptionDto(
                    description: '6Wi',
                    isCorrect: false,
                  ),
                ],
                categories: ['@#Ij', '@s@urTl', '4UPz'],
                profile: '8c8O9R6x',
              ),
            ],
          ),
          [
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
              owner: QuestionOwner(displayName: '8c8O9R6x'),
            ),
          ]
        ),
      ]) {
        test(values.toString(), () async {
          final appwriteQuestionListModel = values.$1;
          final expected = values.$2;

          when(() => questionsAppwriteDataSource.watchForUpdate()).thenAnswer((_) async => const Ok(Stream.empty()));
          when(() => questionsAppwriteDataSource.getAll()).thenAnswer((_) async => Ok(appwriteQuestionListModel));
          when(() => profileAppwriteDataSource.fetchSingle(any()))
              .thenAnswer((_) async => const Ok(AppwriteProfileDto(id: 'hi2jW', displayName: '8c8O9R6x')));

          final result = await repository.watchAll();

          expect(result.isOk, true);
          expect(result.unwrap(), emits(expected));
        });
      }
    });
  });

  group('deleteSingle()', () {
    group('should call questions Appwrite data source correctly', () {
      for (final questionId in [
        const QuestionId(''),
        const QuestionId('olp'),
      ]) {
        test(questionId.toString(), () {
          when(() => questionsAppwriteDataSource.deleteSingle(any()))
              .thenAnswer((_) async => Err(QuestionsAppwriteDataSourceUnexpectedFailure(r'T8$W7')));

          repository.deleteSingle(questionId);

          verify(() => questionsAppwriteDataSource.deleteSingle(questionId.value)).called(1);
        });
      }
    });

    test('should return nothing if questions appwrite data source succeeds', () async {
      when(() => questionsAppwriteDataSource.deleteSingle(any())).thenAnswer((_) async => const Ok(unit));

      final result = await repository.deleteSingle(const QuestionId('6xSamAUC'));

      expect(result, const Ok<Unit, QuestionRepositoryFailure>(unit));
    });

    group(
        'should return expected failure when questions Appwrite data source '
        'fails', () {
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
          const QuestionRepositoryExternalServiceErrorFailure(message: r'E!!$'),
        ],
      ]) {
        test(values.toString(), () async {
          final dataSourceFailure = values[0] as QuestionsAppwriteDataSourceFailure;
          final expected = values[1] as QuestionRepositoryFailure;

          when(() => questionsAppwriteDataSource.deleteSingle(any())).thenAnswer((_) async => Err(dataSourceFailure));

          final result = await repository.deleteSingle(const QuestionId('cNPJl@*x'));

          expect(result, Err<Unit, QuestionRepositoryFailure>(expected));
        });
      }
    });
  });

  group('updateSingle', () {
    test('unimplemented', () {
      expect(() async => repository.updateSingle(_MockQuestion()), throwsUnimplementedError);
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockAuthAppwriteDataSource extends Mock implements AuthAppwriteDataSource {}

class _MockAppwriteRealtimeQuestionMessageModel extends Mock implements AppwriteRealtimeQuestionMessageDto {}

class _MockAppwriteQuestionListModel extends Mock implements AppwriteQuestionListDto {}

class _MockQuestionsAppwriteDataSource extends Mock implements QuestionCollectionAppwriteDataSourceImpl {}

class _MockAppwriteQuestionDto extends Mock implements AppwriteQuestionDto {}

class _MockQuestion extends Mock implements Question {}

class _MockUserModel extends Mock implements AppwriteUserDto {}

class _MockProfileCollectionAppwriteDataSource extends Mock implements ProfileCollectionAppwriteDataSource {}
