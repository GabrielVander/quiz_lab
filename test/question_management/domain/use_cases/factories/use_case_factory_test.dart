import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

void main() {
  late RepositoryFactory mockRepositoryFactory;
  late UseCaseFactory useCaseFactory;

  setUp(() {
    mockRepositoryFactory = _MockRepositoryFactory();
    useCaseFactory = UseCaseFactory(
      repositoryFactory: mockRepositoryFactory,
    );
  });

  tearDown(resetMocktailState);

  group('makeWatchAllQuestionsUseCase', () {
    test('should return WatchAllQuestionsUseCase', () {
      final mockQuestionRepository = _MockQuestionRepository();

      when(() => mockRepositoryFactory.makeQuestionRepository())
          .thenReturn(mockQuestionRepository);

      final result = useCaseFactory.makeWatchAllQuestionsUseCase();

      expect(result, isA<WatchAllQuestionsUseCase>());
    });
  });

  group('makeCreateQuestionUseCase', () {
    test('should return CreateQuestionUseCase', () {
      final mockQuestionRepository = _MockQuestionRepository();

      when(() => mockRepositoryFactory.makeQuestionRepository())
          .thenReturn(mockQuestionRepository);

      final result = useCaseFactory.makeCreateQuestionUseCase();

      expect(result, isA<CreateQuestionUseCase>());
    });
  });

  group('makeUpdateQuestionUseCase', () {
    test('should return UpdateQuestionUseCase', () {
      final mockQuestionRepository = _MockQuestionRepository();

      when(() => mockRepositoryFactory.makeQuestionRepository())
          .thenReturn(mockQuestionRepository);

      final result = useCaseFactory.makeUpdateQuestionUseCase();

      expect(result, isA<UpdateQuestionUseCase>());
    });
  });

  group('makeDeleteQuestionUseCase', () {
    test('should return DeleteQuestionUseCase', () {
      final mockQuestionRepository = _MockQuestionRepository();

      when(() => mockRepositoryFactory.makeQuestionRepository())
          .thenReturn(mockQuestionRepository);

      final result = useCaseFactory.makeDeleteQuestionUseCase();

      expect(result, isA<DeleteQuestionUseCase>());
    });
  });
}

class _MockRepositoryFactory extends Mock implements RepositoryFactory {}

class _MockQuestionRepository extends Mock implements QuestionRepository {}
