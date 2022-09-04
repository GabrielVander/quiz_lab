import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/models/question_model.dart';
import 'package:quiz_lab/features/quiz/data/repositories/question_repository_firebase_impl.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';

void main() {
  late FirebaseDataSource dummyDataSource;
  late QuestionRepositoryFirebaseImpl repository;

  setUp(() {
    dummyDataSource = DummyFirebaseDataSource();
    repository = QuestionRepositoryFirebaseImpl(dataSource: dummyDataSource);
  });

  test('Should call data source correctly', () {
    when(() => dummyDataSource.fetchPublicQuestions())
        .thenAnswer((_) => const Stream<QuestionModel>.empty());

    repository.fetchAll();

    verify(() => dummyDataSource.fetchPublicQuestions()).called(1);
  });

  group('Should handle data source result', () {
    for (final stream in [
      const Stream<QuestionModel>.empty(),
      Stream<QuestionModel>.fromIterable([DummyQuestionModel()]),
    ]) {
      test(stream, () {
        final dummyQuestionEntity = DummyQuestion();

        final dummyModelsStream = stream.map((model) {
          when(() => model.toEntity()).thenReturn(dummyQuestionEntity);

          return model;
        });

        when(() => dummyDataSource.fetchPublicQuestions())
            .thenAnswer((_) => dummyModelsStream);

        repository.fetchAll().forEach((question) {
          expect(question, dummyQuestionEntity);
        });
      });
    }
  });
}

class DummyFirebaseDataSource extends Mock implements FirebaseDataSource {}

class DummyQuestionModel extends Mock implements QuestionModel {}

class DummyQuestion extends Mock implements Question {}
