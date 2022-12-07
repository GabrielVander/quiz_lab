import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class _DummyQuestion extends Mock implements Question {}

void main() {
  late FirebaseDataSource dummyFirestoreDataSource;
  late HiveDataSource dummyHiveDataSource;
  late QuestionRepositoryImpl repository;

  setUp(() {
    registerFallbackValue(_DummyQuestionModel());

    dummyFirestoreDataSource = _FirebaseDataSourceMock();
    dummyHiveDataSource = _HiveDataSourceMock();
    repository = QuestionRepositoryImpl(
      firebaseDataSource: dummyFirestoreDataSource,
      hiveDataSource: dummyHiveDataSource,
    );
  });

  group('Question watching', () {
    test('Should call hive data source correctly', () async {
      when(() => dummyHiveDataSource.watchAllQuestions()).thenAnswer(
        (_) async => const Result.ok(Stream<QuestionModel>.empty()),
      );

      await repository.watchAll();

      verify(() => dummyHiveDataSource.watchAllQuestions()).called(1);
    });

    group('Should handle hive data source ok result', () {
      for (final stream in [
        const Stream<QuestionModel>.empty(),
        Stream<QuestionModel>.fromIterable([_DummyQuestionModel()]),
        Stream<QuestionModel>.fromIterable([
          _DummyQuestionModel(),
          _DummyQuestionModel(),
          _DummyQuestionModel(),
        ]),
      ]) {
        test(stream, () async {
          await stream.forEach(
            (model) => when(model.toEntity).thenReturn(_DummyQuestion()),
          );

          when(() => dummyHiveDataSource.watchAllQuestions())
              .thenAnswer((_) async => Result.ok(stream));

          final result = await repository.watchAll();
          expect(result.isOk, isTrue);

          await expectLater(
            result.ok,
            emitsInOrder(
              await stream.map((model) {
                return model.toEntity();
              }).toList(),
            ),
          );
        });
      }
    });

    group('Should handle hive data source err result', () {
      for (final testCase in <List<dynamic>>[
        [
          HiveDataSourceLibraryFailure(message: ''),
          QuestionRepositoryLibraryFailure(
            message: 'Unable to watch questions: ',
          ),
        ],
        [
          HiveDataSourceLibraryFailure(message: '%ae'),
          QuestionRepositoryLibraryFailure(
            message: 'Unable to watch questions: %ae',
          ),
        ],
      ]) {
        test(testCase, () async {
          final failure = testCase[0] as HiveDataSourceLibraryFailure;
          final expectedFailure = testCase[1] as QuestionRepositoryFailure;

          when(() => dummyHiveDataSource.watchAllQuestions())
              .thenAnswer((_) async => Result.err(failure));

          final result = await repository.watchAll();
          expect(result.isErr, isTrue);

          expect(result.err, isA<QuestionRepositoryLibraryFailure>());
          expect(result.err, expectedFailure);
        });
      }
    });
  });

  group('Single question deletion', () {
    group('ok', () {
      for (final id in ['6tzlq', '8N5l87Qk']) {
        test(id, () async {
          when(() => dummyHiveDataSource.deleteQuestion(any()))
              .thenAnswer((_) async => const Result.ok(unit));

          final result = await repository.deleteSingle(id);
          expect(result.isOk, isTrue);

          verify(
            () => dummyHiveDataSource.deleteQuestion(
              any(that: predicate((q) => (q! as QuestionModel).id == id)),
            ),
          ).called(1);
        });
      }
    });

    group('err', () {
      for (final testCase in <List<dynamic>>[
        [
          '',
          HiveDataSourceInvalidIdFailure(message: ''),
          const QuestionRepositoryInvalidQuestionFailure(
            message: 'Unable to delete question with id : ',
          )
        ],
        [
          'UT8^',
          HiveDataSourceInvalidIdFailure(message: ''),
          const QuestionRepositoryInvalidQuestionFailure(
            message: 'Unable to delete question with id UT8^: ',
          )
        ],
        [
          r'w$0g8i',
          HiveDataSourceInvalidIdFailure(message: 'hpWnuo@'),
          const QuestionRepositoryInvalidQuestionFailure(
            message: r'Unable to delete question with id w$0g8i: hpWnuo@',
          )
        ],
        [
          r'w$0g8i',
          HiveDataSourceInvalidIdFailure(message: 'WOwT%'),
          const QuestionRepositoryInvalidQuestionFailure(
            message: r'Unable to delete question with id w$0g8i: WOwT%',
          )
        ],
      ]) {
        final id = testCase[0] as String;
        final failure = testCase[1] as HiveDataSourceFailure;
        final expectedFailure = testCase[2] as QuestionRepositoryFailure;

        test(testCase, () async {
          when(() => dummyHiveDataSource.deleteQuestion(any()))
              .thenAnswer((_) async => Result.err(failure));

          final result = await repository.deleteSingle(id);
          expect(result.isErr, isTrue);

          expect(result.err, expectedFailure);
        });
      }
    });
  });

  group('Single question creation', () {
    setUpAll(() {
      registerFallbackValue(_FakeQuestionModel());
    });

    for (final testCase in [
      [
        const Question(
          shortDescription: 'shortDescription',
          description: 'description',
          answerOptions: [],
          difficulty: QuestionDifficulty.easy,
          categories: [],
        ),
        const QuestionModel(
          id: null,
          shortDescription: 'shortDescription',
          description: 'description',
          difficulty: 'easy',
          categories: [],
        )
      ],
      [
        const Question(
          shortDescription: 'nkl!',
          description: 'oaK',
          answerOptions: [],
          difficulty: QuestionDifficulty.medium,
          categories: [
            QuestionCategory(value: '3@0lv*ip'),
            QuestionCategory(value: '@1H7')
          ],
        ),
        const QuestionModel(
          id: null,
          shortDescription: 'nkl!',
          description: 'oaK',
          difficulty: 'medium',
          categories: ['3@0lv*ip', '@1H7'],
        )
      ],
    ]) {
      final input = testCase[0] as Question;
      final expected = testCase[1] as QuestionModel;

      test('$input -> $expected', () async {
        when(() => dummyFirestoreDataSource.createPublicQuestion(any()))
            .thenAnswer((_) async {});

        await repository.createSingle(input);

        verify(() => dummyFirestoreDataSource.createPublicQuestion(expected))
            .called(1);
      });
    }
  });

  parameterizedTest(
    'updateQuestion',
    ParameterizedSource.values([
      [
        const Question(
          shortDescription: 'shortDescription',
          description: 'description',
          answerOptions: [],
          difficulty: QuestionDifficulty.easy,
          categories: [],
          id: 'd53fdabe-5325-432b-9f98-982b5867cabf',
        ),
        const QuestionModel(
          id: 'd53fdabe-5325-432b-9f98-982b5867cabf',
          shortDescription: 'shortDescription',
          description: 'description',
          difficulty: 'easy',
          categories: [],
        )
      ],
      [
        const Question(
          id: '70d53199-72c0-4cc9-8c95-c8f164062933',
          shortDescription: 'nkl!',
          description: 'oaK',
          answerOptions: [],
          difficulty: QuestionDifficulty.medium,
          categories: [
            QuestionCategory(value: '3@0lv*ip'),
            QuestionCategory(value: '@1H7')
          ],
        ),
        const QuestionModel(
          id: '70d53199-72c0-4cc9-8c95-c8f164062933',
          shortDescription: 'nkl!',
          description: 'oaK',
          difficulty: 'medium',
          categories: ['3@0lv*ip', '@1H7'],
        )
      ],
    ]),
    (values) async {
      final input = values[0] as Question;
      final expected = values[1] as QuestionModel;

      when(() => dummyFirestoreDataSource.updateQuestion(any()))
          .thenAnswer((_) async {});

      await repository.updateSingle(input);

      verify(() => dummyFirestoreDataSource.updateQuestion(expected)).called(1);
    },
  );
}

class _FirebaseDataSourceMock extends Mock implements FirebaseDataSource {}

class _HiveDataSourceMock extends Mock implements HiveDataSource {}

class _DummyQuestionModel extends Mock implements QuestionModel {}

class _FakeQuestionModel extends Fake implements QuestionModel {}
