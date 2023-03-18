import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late DataSourceFactory mockDataSourceFactory;
  late MapperFactory mockMapperFactory;
  late QuestionRepositoryImpl repository;

  setUp(() {
    mocktail.registerFallbackValue(_FakeQuestionModel());

    mockDataSourceFactory = _MockDataSourceFactory();
    mockMapperFactory = _MockMapperFactory();

    repository = QuestionRepositoryImpl(
      dataSourceFactory: mockDataSourceFactory,
      mapperFactory: mockMapperFactory,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('createSingle', () {
    group('err flow', () {
      parameterizedTest(
          'hive data source failure',
          ParameterizedSource.values([
            [
              HiveDataSourceFailure.hiveError(message: ''),
              (Question question) => QuestionRepositoryFailure.unableToCreate(
                    question: question,
                    message: '',
                  ),
            ],
          ]), (values) async {
        final dataSourceFailure = values[0] as HiveDataSourceFailure;
        final expectedRepositoryFailureBuilder =
            values[1] as QuestionRepositoryFailure Function(Question question);

        final mockHiveDataSource = _MockHiveDataSource();
        final mockHiveQuestionModelMapper = _MockHiveQuestionModelMapper();

        final fakeEntity = _FakeQuestion();
        final fakeModel = _FakeQuestionModel();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(() => mockMapperFactory.makeHiveQuestionModelMapper())
            .thenReturn(mockHiveQuestionModelMapper);

        mocktail
            .when(() => mockHiveDataSource.saveQuestion(fakeModel))
            .thenAnswer((_) async => Result.err(dataSourceFailure));

        mocktail
            .when(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeModel);

        final result = await repository.createSingle(fakeEntity);

        expect(result.isErr, isTrue);
        expect(
          result.err,
          equals(expectedRepositoryFailureBuilder(fakeEntity)),
        );
      });
    });

    group('ok flow', () {
      test('should call dependencies correctly', () async {
        final mockHiveDataSource = _MockHiveDataSource();
        final mockHiveQuestionModelMapper = _MockHiveQuestionModelMapper();

        final fakeEntity = _FakeQuestion();
        final fakeHiveModel = _FakeQuestionModel();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(() => mockMapperFactory.makeHiveQuestionModelMapper())
            .thenReturn(mockHiveQuestionModelMapper);

        mocktail
            .when(() => mockHiveDataSource.saveQuestion(mocktail.any()))
            .thenAnswer((_) async => const Result.ok(unit));

        mocktail
            .when(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeHiveModel);

        await repository.createSingle(fakeEntity);

        mocktail
            .verify(() => mockHiveDataSource.saveQuestion(fakeHiveModel))
            .called(1);
      });

      test('should return Ok', () async {
        final mockHiveDataSource = _MockHiveDataSource();
        final mockHiveQuestionModelMapper = _MockHiveQuestionModelMapper();

        final fakeEntity = _FakeQuestion();
        final fakeHiveModel = _FakeQuestionModel();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(() => mockMapperFactory.makeHiveQuestionModelMapper())
            .thenReturn(mockHiveQuestionModelMapper);

        mocktail
            .when(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeHiveModel);

        mocktail
            .when(() => mockHiveDataSource.saveQuestion(mocktail.any()))
            .thenAnswer((_) async => const Result.ok(unit));

        mocktail
            .when(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeHiveModel);

        final result = await repository.createSingle(fakeEntity);

        expect(result.isOk, isTrue);
      });
    });
  });

  group('watchAll', () {
    group('err flow', () {
      parameterizedTest(
          'hive data source failure',
          ParameterizedSource.values([
            [
              HiveDataSourceFailure.hiveError(message: ''),
              QuestionRepositoryFailure.unableToWatchAll(message: ''),
            ],
            [
              HiveDataSourceFailure.hiveError(message: '%ae'),
              QuestionRepositoryFailure.unableToWatchAll(message: '%ae'),
            ],
          ]), (values) async {
        final failure = values[0] as HiveDataSourceFailure;
        final expectedFailure = values[1] as QuestionRepositoryFailure;

        final mockHiveDataSource = _MockHiveDataSource();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(mockHiveDataSource.watchAllQuestions)
            .thenReturn(Result.err(failure));

        final result = await repository.watchAll();

        expect(result.isErr, isTrue);
        expect(result.err, expectedFailure);
      });

      parameterizedTest(
          'Mapper failure',
          ParameterizedSource.values([
            [
              <HiveQuestionModel>[_FakeQuestionModel()],
              <Result<Question, QuestionMapperFailure>>[
                Result.err(
                  QuestionMapperFailure.missingId(),
                ),
              ],
              <Question>[],
            ],
            [
              <HiveQuestionModel>[
                _FakeQuestionModel(),
                _FakeQuestionModel(),
                _FakeQuestionModel(),
              ],
              <Result<Question, QuestionMapperFailure>>[
                Result.err(
                  QuestionMapperFailure.missingCategories(),
                ),
                Result.err(
                  QuestionMapperFailure.missingDifficulty(),
                ),
                Result.err(
                  QuestionMapperFailure.missingDescription(),
                ),
              ],
              <Question>[],
            ],
            [
              <HiveQuestionModel>[
                _FakeQuestionModel(),
                _FakeQuestionModel(),
                _FakeQuestionModel(),
              ],
              <Result<Question, QuestionMapperFailure>>[
                Result.ok(_FakeQuestion()),
                Result.err(
                  QuestionMapperFailure.unableToParseDifficulty(
                    receivedValue: r'$uqO8n5',
                    possibleValues: const [],
                  ),
                ),
                Result.ok(_FakeQuestion()),
              ],
              <Question>[_FakeQuestion(), _FakeQuestion()],
            ],
          ]), (values) async {
        final hiveModels = values[0] as List<HiveQuestionModel>;
        final mapperResults =
            values[1] as List<Result<Question, QuestionMapperFailure>>;
        final expectedQuestions = values[2] as List<Question>;

        final mockHiveDataSource = _MockHiveDataSource();
        final mockQuestionEntityMapper = _MockQuestionEntityMapper();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(() => mockMapperFactory.makeQuestionEntityMapper())
            .thenReturn(mockQuestionEntityMapper);

        mocktail
            .when(mockHiveDataSource.watchAllQuestions)
            .thenReturn(Result.ok(Stream.value(hiveModels)));

        mocktail
            .when(() => mockQuestionEntityMapper.fromHiveModel(mocktail.any()))
            .thenAnswer((_) => mapperResults.removeAt(0));

        final result = await repository.watchAll();

        expect(result.isOk, isTrue);
        expect(result.ok, emits(expectedQuestions));
      });
    });

    group('ok flow', () {
      test('should call hive data source correctly', () {
        final mockHiveDataSource = _MockHiveDataSource();
        final mockQuestionEntityMapper = _MockQuestionEntityMapper();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(() => mockMapperFactory.makeQuestionEntityMapper())
            .thenReturn(mockQuestionEntityMapper);

        mocktail.when(mockHiveDataSource.watchAllQuestions).thenReturn(
              const Result.ok(Stream<List<HiveQuestionModel>>.empty()),
            );

        repository.watchAll();

        mocktail.verify(mockHiveDataSource.watchAllQuestions).called(1);
      });

      parameterizedTest(
        'should handle hive data source ok result',
        ParameterizedSource.value([
          const Stream<List<HiveQuestionModel>>.empty(),
          Stream<List<HiveQuestionModel>>.fromIterable([[]]),
          Stream<List<HiveQuestionModel>>.fromIterable([
            [_FakeQuestionModel()]
          ]),
          Stream<List<HiveQuestionModel>>.fromIterable([
            [_FakeQuestionModel()],
            [_FakeQuestionModel(), _FakeQuestionModel()],
            [_FakeQuestionModel(), _FakeQuestionModel(), _FakeQuestionModel()],
          ]),
        ]),
        (values) async {
          final hiveModelStream = values[0] as Stream<List<HiveQuestionModel>>;

          final mockHiveDataSource = _MockHiveDataSource();
          final mockQuestionEntityMapper = _MockQuestionEntityMapper();

          mocktail
              .when(() => mockDataSourceFactory.makeHiveDataSource())
              .thenReturn(mockHiveDataSource);

          mocktail
              .when(() => mockMapperFactory.makeQuestionEntityMapper())
              .thenReturn(mockQuestionEntityMapper);

          mocktail
              .when(mockHiveDataSource.watchAllQuestions)
              .thenReturn(Result.ok(hiveModelStream));

          mocktail
              .when(
                () => mockQuestionEntityMapper.fromHiveModel(mocktail.any()),
              )
              .thenReturn(Result.ok(_FakeQuestion()));

          final result = await repository.watchAll();

          expect(result.isOk, isTrue);

          await expectLater(
            result.ok,
            emitsInOrder(
              await hiveModelStream
                  .map(
                    (models) => models.map((_) => _FakeQuestion()).toList(),
                  )
                  .toList(),
            ),
          );
        },
      );
    });
  });

  group('updateSingle', () {
    group('err flow', () {
      parameterizedTest(
        'hive data source failure',
        ParameterizedSource.values([
          [
            '',
            HiveDataSourceFailure.hiveError(message: ''),
            (Question question) =>
                QuestionRepositoryFailure.unableToUpdate(id: '', details: ''),
          ],
          [
            r'V$KkL',
            HiveDataSourceFailure.hiveError(message: '2xWvVjk'),
            (Question question) => QuestionRepositoryFailure.unableToUpdate(
                  id: r'V$KkL',
                  details: '2xWvVjk',
                ),
          ],
        ]),
        (values) async {
          final id = values[0] as String;
          final dataSourceFailure = values[1] as HiveDataSourceFailure;
          final expectedRepositoryFailureBuilder = values[2]
              as QuestionRepositoryFailure Function(Question question);

          final mockHiveDataSource = _MockHiveDataSource();
          final mockHiveQuestionModelMapper = _MockHiveQuestionModelMapper();

          final fakeEntity = _FakeQuestion.id(id);
          final fakeModel = _FakeQuestionModel();

          mocktail
              .when(() => mockDataSourceFactory.makeHiveDataSource())
              .thenReturn(mockHiveDataSource);

          mocktail
              .when(() => mockMapperFactory.makeHiveQuestionModelMapper())
              .thenReturn(mockHiveQuestionModelMapper);

          mocktail
              .when(() => mockHiveDataSource.saveQuestion(fakeModel))
              .thenAnswer((_) async => Result.err(dataSourceFailure));

          mocktail
              .when(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
              .thenReturn(fakeModel);

          final result = await repository.updateSingle(fakeEntity);

          expect(result.isErr, isTrue);
          expect(
            result.err,
            equals(expectedRepositoryFailureBuilder(fakeEntity)),
          );
        },
      );
    });

    group('ok flow', () {
      test('should call dependencies correctly and return Ok', () async {
        final mockHiveDataSource = _MockHiveDataSource();
        final mockHiveQuestionModelMapper = _MockHiveQuestionModelMapper();

        final fakeEntity = _FakeQuestion();
        final fakeModel = _FakeQuestionModel();

        mocktail
            .when(() => mockDataSourceFactory.makeHiveDataSource())
            .thenReturn(mockHiveDataSource);

        mocktail
            .when(() => mockMapperFactory.makeHiveQuestionModelMapper())
            .thenReturn(mockHiveQuestionModelMapper);

        mocktail
            .when(() => mockHiveDataSource.saveQuestion(fakeModel))
            .thenAnswer((_) async => const Result.ok(unit));

        mocktail
            .when(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeModel);

        final result = await repository.updateSingle(fakeEntity);

        expect(result.isOk, isTrue);

        mocktail
            .verify(() => mockHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .called(1);
        mocktail
            .verify(() => mockHiveDataSource.saveQuestion(fakeModel))
            .called(1);
      });
    });
  });

  group('deleteSingle', () {
    group('ok flow', () {
      parameterizedTest(
        'should call dependencies correctly and return Ok',
        ParameterizedSource.value([
          '6tzlq',
          '8N5l87Qk',
        ]),
        (values) async {
          final id = values[0] as String;

          final mockHiveDataSource = _MockHiveDataSource();

          mocktail
              .when(() => mockDataSourceFactory.makeHiveDataSource())
              .thenReturn(mockHiveDataSource);

          mocktail
              .when(() => mockHiveDataSource.deleteQuestion(mocktail.any()))
              .thenAnswer((_) async => const Result.ok(unit));

          final result = await repository.deleteSingle(id);
          expect(result.isOk, isTrue);

          mocktail
              .verify(
                () => mockHiveDataSource.deleteQuestion(
                  mocktail.any(
                    that: predicate((q) => (q! as HiveQuestionModel).id == id),
                  ),
                ),
              )
              .called(1);
        },
      );
    });

    group('err flow', () {
      parameterizedTest(
        'hive data source failure',
        ParameterizedSource.values([
          [
            '',
            HiveDataSourceFailure.emptyId(),
            QuestionRepositoryFailure.unableToDelete(id: '')
          ],
          [
            'UT8^',
            HiveDataSourceFailure.emptyId(),
            QuestionRepositoryFailure.unableToDelete(id: 'UT8^')
          ],
          [
            'UT8^',
            HiveDataSourceFailure.emptyId(),
            QuestionRepositoryFailure.unableToDelete(id: 'UT8^')
          ],
          [
            'jn&@',
            HiveDataSourceFailure.hiveError(message: ''),
            QuestionRepositoryFailure.unableToDelete(id: 'jn&@')
          ],
          [
            'jn&@',
            HiveDataSourceFailure.hiveError(message: 'WOwT%'),
            QuestionRepositoryFailure.unableToDelete(id: 'jn&@')
          ],
        ]),
        (values) async {
          final id = values[0] as String;
          final failure = values[1] as HiveDataSourceFailure;
          final expectedFailure = values[2] as QuestionRepositoryFailure;

          final mockHiveDataSource = _MockHiveDataSource();

          mocktail
              .when(() => mockDataSourceFactory.makeHiveDataSource())
              .thenReturn(mockHiveDataSource);

          mocktail
              .when(() => mockHiveDataSource.deleteQuestion(mocktail.any()))
              .thenAnswer((_) async => Result.err(failure));

          final result = await repository.deleteSingle(id);
          expect(result.isErr, isTrue);

          expect(result.err, expectedFailure);
        },
      );
    });
  });
}

class _MockDataSourceFactory extends mocktail.Mock
    implements DataSourceFactory {}

class _MockMapperFactory extends mocktail.Mock implements MapperFactory {}

class _MockHiveDataSource extends mocktail.Mock implements HiveDataSource {}

class _MockQuestionEntityMapper extends mocktail.Mock
    implements QuestionEntityMapper {}

class _MockHiveQuestionModelMapper extends mocktail.Mock
    implements HiveQuestionModelMapper {}

class _FakeQuestionModel extends Fake implements HiveQuestionModel {}

class _FakeQuestion extends Fake with EquatableMixin implements Question {
  factory _FakeQuestion() => _FakeQuestion._(id: 'F3w5L');

  factory _FakeQuestion.id(String id) => _FakeQuestion._(id: id);

  _FakeQuestion._({required this.id});

  @override
  final String id;

  @override
  List<Object> get props => [];
}
