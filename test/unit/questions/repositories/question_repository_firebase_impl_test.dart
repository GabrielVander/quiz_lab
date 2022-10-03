import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/models/question_model.dart';
import 'package:quiz_lab/features/quiz/data/repositories/question_repository_firebase_impl.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';

void main() {
  late FirebaseDataSource dummyDataSource;
  late QuestionRepositoryFirebaseImpl repository;

  setUp(() {
    dummyDataSource = DummyFirebaseDataSource();
    repository = QuestionRepositoryFirebaseImpl(dataSource: dummyDataSource);
  });

  group('Question watching', () {
    test('Should call data source correctly', () {
      when(() => dummyDataSource.watchPublicQuestions())
          .thenAnswer((_) => const Stream<List<QuestionModel>>.empty());

      repository.watchAll();

      verify(() => dummyDataSource.watchPublicQuestions()).called(1);
    });

    group('Should handle data source result', () {
      for (final stream in [
        const Stream<List<QuestionModel>>.empty(),
        Stream<List<QuestionModel>>.fromIterable([
          [DummyQuestionModel()]
        ]),
      ]) {
        test(stream, () {
          final dummyQuestionEntity = DummyQuestion();

          final dummyModelsStream = stream.map((models) {
            for (final model in models) {
              when(model.toEntity).thenReturn(dummyQuestionEntity);
            }

            return models;
          });

          when(() => dummyDataSource.watchPublicQuestions())
              .thenAnswer((_) => dummyModelsStream);

          repository.watchAll().forEach((question) {
            expect(question, [dummyQuestionEntity]);
          });
        });
      }
    });
  });

  group('Single question deletion', () {
    for (final id in ['', 'P9!^34', '%AFAXy7F']) {
      test('Question id: $id', () async {
        when(() => dummyDataSource.deletePublicQuestionById(any()))
            .thenAnswer((_) async {});

        await repository.deleteSingle(id);

        verify(() => dummyDataSource.deletePublicQuestionById(id)).called(1);
      });
    }
  });

  group('Single question creation', () {
    setUpAll(() {
      registerFallbackValue(FakeQuestionModel());
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
        when(() => dummyDataSource.createPublicQuestion(any()))
            .thenAnswer((_) async {});

        await repository.createSingle(input);

        verify(() => dummyDataSource.createPublicQuestion(expected)).called(1);
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

      when(() => dummyDataSource.updateQuestion(any()))
          .thenAnswer((_) async {});

      await repository.updateSingle(input);

      verify(() => dummyDataSource.updateQuestion(expected)).called(1);
    },
  );
}

class DummyFirebaseDataSource extends Mock implements FirebaseDataSource {}

class DummyQuestionModel extends Mock implements QuestionModel {}

class DummyQuestion extends Mock implements Question {}

class FakeQuestionModel extends Fake implements QuestionModel {}
