import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late FirebaseDataSource dummyFirestoreDataSource;
  late HiveDataSource dummyHiveDataSource;
  late QuestionMapper dummyQuestionMapper;
  late HiveQuestionModelMapper dummyHiveQuestionModelMapper;
  late QuestionRepositoryImpl repository;

  setUp(() {
    registerFallbackValue(_FakeQuestionModel());

    dummyFirestoreDataSource = _MockFirebaseDataSource();
    dummyHiveDataSource = _MockHiveDataSource();
    dummyQuestionMapper = _MockQuestionMapper();
    dummyHiveQuestionModelMapper = _MockHiveQuestionModelMapper();

    repository = QuestionRepositoryImpl(
      firebaseDataSource: dummyFirestoreDataSource,
      hiveDataSource: dummyHiveDataSource,
      questionMapper: dummyQuestionMapper,
      hiveQuestionModelMapper: dummyHiveQuestionModelMapper,
    );
  });

  group('createSingle', () {
    group('Ok flow', () {
      test('should call dependencies correctly', () async {
        final fakeEntity = _FakeQuestion();
        final fakeHiveModel = _FakeQuestionModel();

        when(() => dummyHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeHiveModel);

        when(() => dummyHiveDataSource.saveQuestion(any()))
            .thenAnswer((_) async => const Result.ok(unit));

        await repository.createSingle(fakeEntity);

        verify(() => dummyHiveDataSource.saveQuestion(fakeHiveModel)).called(1);
      });

      test('should return Ok', () async {
        final fakeEntity = _FakeQuestion();
        final fakeHiveModel = _FakeQuestionModel();

        when(() => dummyHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeHiveModel);

        when(() => dummyHiveDataSource.saveQuestion(fakeHiveModel))
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await repository.createSingle(fakeEntity);

        expect(result.isOk, isTrue);
      });
    });

    group('Err flow', () {
      parameterizedTest(
          'Hive data source failure',
          ParameterizedSource.values([
            [
              HiveDataSourceFailure.libraryFailure(message: ''),
              (Question question) =>
                  QuestionRepositoryFailure.unableToCreate(question: question),
            ],
          ]), (values) async {
        final dataSourceFailure = values[0] as HiveDataSourceFailure;
        final expectedRepositoryFailureBuilder =
            values[1] as QuestionRepositoryFailure Function(Question question);

        final fakeEntity = _FakeQuestion();
        final fakeModel = _FakeQuestionModel();

        when(() => dummyHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeModel);

        when(() => dummyHiveDataSource.saveQuestion(fakeModel))
            .thenAnswer((_) async => Result.err(dataSourceFailure));

        final result = await repository.createSingle(fakeEntity);

        expect(result.isErr, isTrue);
        expect(
          result.err,
          equals(expectedRepositoryFailureBuilder(fakeEntity)),
        );
      });
    });
  });

  group('watchAll', () {
    group('Err flow', () {
      parameterizedTest(
          'Hive data source failure',
          ParameterizedSource.values([
            [
              HiveDataSourceFailure.libraryFailure(message: ''),
              QuestionRepositoryFailure.unableToWatchAll(message: ''),
            ],
            [
              HiveDataSourceFailure.libraryFailure(message: '%ae'),
              QuestionRepositoryFailure.unableToWatchAll(message: '%ae'),
            ],
          ]), (values) {
        final failure = values[0] as HiveDataSourceLibraryFailure;
        final expectedFailure = values[1] as QuestionRepositoryFailure;

        when(() => dummyHiveDataSource.watchAllQuestions())
            .thenReturn(Result.err(failure));

        final result = repository.watchAll();
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
          ]), (values) {
        final hiveModels = values[0] as List<HiveQuestionModel>;
        final mapperResults =
            values[1] as List<Result<Question, QuestionMapperFailure>>;
        final expectedQuestions = values[2] as List<Question>;

        when(() => dummyHiveDataSource.watchAllQuestions())
            .thenReturn(Result.ok(Stream.value(hiveModels)));

        when(() => dummyQuestionMapper.fromHiveModel(any()))
            .thenAnswer((_) => mapperResults.removeAt(0));

        final result = repository.watchAll();
        expect(result.isOk, isTrue);

        expect(result.ok, emits(expectedQuestions));
      });
    });

    group('Ok flow', () {
      test('Should call hive data source correctly', () {
        when(() => dummyHiveDataSource.watchAllQuestions()).thenReturn(
          const Result.ok(Stream<List<HiveQuestionModel>>.empty()),
        );

        repository.watchAll();

        verify(() => dummyHiveDataSource.watchAllQuestions()).called(1);
      });

      group('Should handle hive data source ok result', () {
        for (final stream in [
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
        ]) {
          test(stream, () async {
            when(() => dummyQuestionMapper.fromHiveModel(any()))
                .thenReturn(Result.ok(_FakeQuestion()));

            when(() => dummyHiveDataSource.watchAllQuestions())
                .thenReturn(Result.ok(stream));

            final result = repository.watchAll();
            expect(result.isOk, isTrue);

            await expectLater(
              result.ok,
              emitsInOrder(
                await stream
                    .map(
                      (models) => models.map((_) => _FakeQuestion()).toList(),
                    )
                    .toList(),
              ),
            );
          });
        }
      });
    });
  });

  group('updateSingle', () {
    group('Err flow', () {
      parameterizedTest(
        'Hive data source failure',
        ParameterizedSource.values([
          [
            HiveDataSourceFailure.libraryFailure(message: ''),
            (Question question) =>
                QuestionRepositoryFailure.unableToUpdate(question: question),
          ],
          [
            HiveDataSourceFailure.libraryFailure(message: '2xWvVjk'),
            (Question question) =>
                QuestionRepositoryFailure.unableToUpdate(question: question),
          ],
        ]),
        (values) async {
          final dataSourceFailure = values[0] as HiveDataSourceFailure;
          final expectedRepositoryFailureBuilder = values[1]
              as QuestionRepositoryFailure Function(Question question);

          final fakeEntity = _FakeQuestion();
          final fakeModel = _FakeQuestionModel();

          when(() => dummyHiveQuestionModelMapper.fromQuestion(fakeEntity))
              .thenReturn(fakeModel);

          when(() => dummyHiveDataSource.saveQuestion(fakeModel))
              .thenAnswer((_) async => Result.err(dataSourceFailure));

          final result = await repository.updateSingle(fakeEntity);

          expect(result.isErr, isTrue);
          expect(
            result.err,
            equals(expectedRepositoryFailureBuilder(fakeEntity)),
          );
        },
      );
    });

    group('Ok flow', () {
      test('Should call dependencies correctly and return Ok', () async {
        final fakeEntity = _FakeQuestion();
        final fakeModel = _FakeQuestionModel();

        when(() => dummyHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .thenReturn(fakeModel);

        when(() => dummyHiveDataSource.saveQuestion(fakeModel))
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await repository.updateSingle(fakeEntity);

        expect(result.isOk, isTrue);

        verify(() => dummyHiveQuestionModelMapper.fromQuestion(fakeEntity))
            .called(1);
        verify(() => dummyHiveDataSource.saveQuestion(fakeModel)).called(1);
      });
    });
  });

  group('deleteSingle', () {
    group('Ok flow', () {
      parameterizedTest(
        'Should call dependencies correctly and return Ok',
        ParameterizedSource.value([
          '6tzlq',
          '8N5l87Qk',
        ]),
        (values) async {
          final id = values[0] as String;

          when(() => dummyHiveDataSource.deleteQuestion(any()))
              .thenAnswer((_) async => const Result.ok(unit));

          final result = await repository.deleteSingle(id);
          expect(result.isOk, isTrue);

          verify(
            () => dummyHiveDataSource.deleteQuestion(
              any(that: predicate((q) => (q! as HiveQuestionModel).id == id)),
            ),
          ).called(1);
        },
      );
    });

    group('Err flow', () {
      parameterizedTest(
        'Hive data source failure',
        ParameterizedSource.values([
          [
            '',
            HiveDataSourceFailure.invalidId(message: ''),
            QuestionRepositoryFailure.unableToDelete(id: '')
          ],
          [
            'UT8^',
            HiveDataSourceFailure.invalidId(message: ''),
            QuestionRepositoryFailure.unableToDelete(id: 'UT8^')
          ],
          [
            'UT8^',
            HiveDataSourceFailure.invalidId(message: 'hpWnuo@'),
            QuestionRepositoryFailure.unableToDelete(id: 'UT8^')
          ],
          [
            'jn&@',
            HiveDataSourceFailure.libraryFailure(message: ''),
            QuestionRepositoryFailure.unableToDelete(id: 'jn&@')
          ],
          [
            'jn&@',
            HiveDataSourceFailure.libraryFailure(message: 'WOwT%'),
            QuestionRepositoryFailure.unableToDelete(id: 'jn&@')
          ],
        ]),
        (values) async {
          final id = values[0] as String;
          final failure = values[1] as HiveDataSourceFailure;
          final expectedFailure = values[2] as QuestionRepositoryFailure;

          when(() => dummyHiveDataSource.deleteQuestion(any()))
              .thenAnswer((_) async => Result.err(failure));

          final result = await repository.deleteSingle(id);
          expect(result.isErr, isTrue);

          expect(result.err, expectedFailure);
        },
      );
    });
  });
}

class _MockFirebaseDataSource extends Mock implements FirebaseDataSource {}

class _MockHiveDataSource extends Mock implements HiveDataSource {}

class _MockQuestionMapper extends Mock implements QuestionMapper {}

class _MockHiveQuestionModelMapper extends Mock
    implements HiveQuestionModelMapper {}

class _FakeQuestionModel extends Fake implements HiveQuestionModel {}

class _FakeQuestion extends Fake with EquatableMixin implements Question {
  @override
  List<Object> get props => [];
}
