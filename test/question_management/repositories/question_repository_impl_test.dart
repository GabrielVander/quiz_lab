import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/question_model.dart';
import 'package:quiz_lab/features/question_management/data/mappers/question_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late FirebaseDataSource dummyFirestoreDataSource;
  late HiveDataSource dummyHiveDataSource;
  late QuestionMapper dummyQuestionMapper;
  late QuestionRepositoryImpl repository;

  setUp(() {
    registerFallbackValue(_FakeQuestionModel());

    dummyFirestoreDataSource = _MockFirebaseDataSource();
    dummyHiveDataSource = _MockHiveDataSource();
    dummyQuestionMapper = _MockQuestionMapper();

    repository = QuestionRepositoryImpl(
      firebaseDataSource: dummyFirestoreDataSource,
      hiveDataSource: dummyHiveDataSource,
      questionMapper: dummyQuestionMapper,
    );
  });

  group('createSingle', () {
    group('Ok flow', () {
      test('should call dependencies correctly', () async {
        final fakeEntity = _FakeQuestion();
        final fakeHiveModel = _FakeQuestionModel();

        when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
            .thenReturn(Result.ok(fakeHiveModel));

        when(() => dummyHiveDataSource.saveQuestion(any()))
            .thenAnswer((_) async => const Result.ok(unit));

        await repository.createSingle(fakeEntity);

        verify(() => dummyHiveDataSource.saveQuestion(fakeHiveModel)).called(1);
      });

      test('should return Ok', () async {
        final fakeEntity = _FakeQuestion();
        final fakeHiveModel = _FakeQuestionModel();

        when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
            .thenReturn(Result.ok(fakeHiveModel));

        when(() => dummyHiveDataSource.saveQuestion(fakeHiveModel))
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await repository.createSingle(fakeEntity);

        expect(result.isOk, isTrue);
      });
    });

    group('Err flow', () {
      parameterizedTest(
          'Mapper failure',
          ParameterizedSource.values([
            [
              QuestionMapperFailure.unableToMapToHiveModel(message: ''),
              QuestionRepositoryFailure.unableToParseEntity(message: ''),
            ],
            [
              QuestionMapperFailure.unableToMapToHiveModel(message: 'ctCI4#A'),
              QuestionRepositoryFailure.unableToParseEntity(message: 'ctCI4#A'),
            ],
          ]), (values) async {
        final mapperFailure = values[0] as QuestionMapperFailure;
        final expectedRepositoryFailure =
            values[1] as QuestionRepositoryFailure;

        final fakeEntity = _FakeQuestion();

        when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
            .thenReturn(Result.err(mapperFailure));

        final result = await repository.createSingle(fakeEntity);

        expect(result.isErr, isTrue);
        expect(result.err, equals(expectedRepositoryFailure));
      });

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

        when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
            .thenReturn(Result.ok(fakeModel));

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
          ]), (values) async {
        final failure = values[0] as HiveDataSourceLibraryFailure;
        final expectedFailure = values[1] as QuestionRepositoryFailure;

        when(() => dummyHiveDataSource.watchAllQuestions())
            .thenAnswer((_) async => Result.err(failure));

        final result = await repository.watchAll();
        expect(result.isErr, isTrue);

        expect(result.err, expectedFailure);
      });

      parameterizedTest(
          'Mapper failure',
          ParameterizedSource.values([
            [
              (HiveQuestionModel model) =>
                  QuestionMapperFailure.unableToMapHiveModelToEntity(
                    model: model,
                  ),
              QuestionRepositoryFailure.unableToWatchAll(
                message: 'Unable to map hive model to entity',
              ),
            ],
          ]), (values) async {
        final mapperFailureBuilder =
            values[0] as QuestionMapperFailure Function(HiveQuestionModel);
        final expectedFailure = values[1] as QuestionRepositoryFailure;

        final fakeHiveModel = _FakeQuestionModel();

        when(() => dummyHiveDataSource.watchAllQuestions())
            .thenAnswer((_) async => Result.ok(Stream.value(fakeHiveModel)));

        when(() => dummyQuestionMapper.mapHiveModelToEntity(any()))
            .thenAnswer((_) => Result.err(mapperFailureBuilder(fakeHiveModel)));

        final result = await repository.watchAll();
        expect(result.isErr, isTrue);

        expect(result.err, expectedFailure);
      });
    });

    group('Ok flow', () {
      test('Should call hive data source correctly', () async {
        when(() => dummyHiveDataSource.watchAllQuestions()).thenAnswer(
          (_) async => const Result.ok(Stream<HiveQuestionModel>.empty()),
        );

        await repository.watchAll();

        verify(() => dummyHiveDataSource.watchAllQuestions()).called(1);
      });

      group('Should handle hive data source ok result', () {
        for (final stream in [
          const Stream<HiveQuestionModel>.empty(),
          Stream<HiveQuestionModel>.fromIterable([_FakeQuestionModel()]),
          Stream<HiveQuestionModel>.fromIterable([
            _FakeQuestionModel(),
            _FakeQuestionModel(),
            _FakeQuestionModel(),
          ]),
        ]) {
          test(stream, () async {
            when(() => dummyQuestionMapper.mapHiveModelToEntity(any()))
                .thenReturn(Result.ok(_FakeQuestion()));

            when(() => dummyHiveDataSource.watchAllQuestions())
                .thenAnswer((_) async => Result.ok(stream));

            final result = await repository.watchAll();
            expect(result.isOk, isTrue);

            await expectLater(
              result.ok,
              emitsInOrder(
                await stream.map((model) => _FakeQuestion()).toList(),
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
        'Mapper failure',
        ParameterizedSource.values([
          [
            QuestionMapperFailure.unableToMapToHiveModel(message: ''),
            QuestionRepositoryFailure.unableToParseEntity(message: ''),
          ],
          [
            QuestionMapperFailure.unableToMapToHiveModel(message: 'Ayrl35S'),
            QuestionRepositoryFailure.unableToParseEntity(message: 'Ayrl35S'),
          ],
        ]),
        (values) async {
          final mapperFailure = values[0] as QuestionMapperFailure;
          final expectedRepositoryFailure =
              values[1] as QuestionRepositoryFailure;

          final fakeEntity = _FakeQuestion();

          when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
              .thenReturn(Result.err(mapperFailure));

          final result = await repository.updateSingle(fakeEntity);

          expect(result.isErr, isTrue);
          expect(result.err, equals(expectedRepositoryFailure));
        },
      );

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

          when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
              .thenReturn(Result.ok(fakeModel));

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

        when(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
            .thenReturn(Result.ok(fakeModel));

        when(() => dummyHiveDataSource.saveQuestion(fakeModel))
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await repository.updateSingle(fakeEntity);

        expect(result.isOk, isTrue);

        verify(() => dummyQuestionMapper.mapEntityToHiveModel(fakeEntity))
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

class _FakeQuestionModel extends Fake implements HiveQuestionModel {}

class _FakeQuestion extends Fake with EquatableMixin implements Question {
  @override
  List<Object> get props => [];
}
