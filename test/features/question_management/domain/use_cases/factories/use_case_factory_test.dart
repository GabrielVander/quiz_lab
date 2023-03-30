import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

void main() {
  late WatchAllQuestionsUseCase watchAllQuestionsUseCaseMock;
  late CreateQuestionUseCase createQuestionUseCaseMock;
  late UpdateQuestionUseCase updateQuestionUseCaseMock;
  late DeleteQuestionUseCase deleteQuestionUseCaseMock;

  late UseCaseFactory useCaseFactory;

  setUp(() {
    watchAllQuestionsUseCaseMock = _WatchAllQuestionsUseCaseMock();
    createQuestionUseCaseMock = _CreateQuestionUseCaseMock();
    updateQuestionUseCaseMock = _UpdateQuestionUseCaseMock();
    deleteQuestionUseCaseMock = _DeleteQuestionUseCaseMock();
    useCaseFactory = UseCaseFactory(
      watchAllQuestionsUseCase: watchAllQuestionsUseCaseMock,
      createQuestionUseCase: createQuestionUseCaseMock,
      updateQuestionUseCase: updateQuestionUseCaseMock,
      deleteQuestionUseCase: deleteQuestionUseCaseMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('makeWatchAllQuestionsUseCase', () {
    test('should return WatchAllQuestionsUseCase', () {
      final result = useCaseFactory.makeWatchAllQuestionsUseCase();

      expect(result, watchAllQuestionsUseCaseMock);
    });
  });

  group('makeCreateQuestionUseCase', () {
    test('should return CreateQuestionUseCase', () {
      final result = useCaseFactory.makeCreateQuestionUseCase();

      expect(result, createQuestionUseCaseMock);
    });
  });

  group('makeUpdateQuestionUseCase', () {
    test('should return UpdateQuestionUseCase', () {
      final result = useCaseFactory.makeUpdateQuestionUseCase();

      expect(result, updateQuestionUseCaseMock);
    });
  });

  group('makeDeleteQuestionUseCase', () {
    test('should return DeleteQuestionUseCase', () {
      final result = useCaseFactory.makeDeleteQuestionUseCase();

      expect(result, deleteQuestionUseCaseMock);
    });
  });
}

class _WatchAllQuestionsUseCaseMock extends mocktail.Mock
    implements WatchAllQuestionsUseCase {}

class _CreateQuestionUseCaseMock extends mocktail.Mock
    implements CreateQuestionUseCase {}

class _UpdateQuestionUseCaseMock extends mocktail.Mock
    implements UpdateQuestionUseCase {}

class _DeleteQuestionUseCaseMock extends mocktail.Mock
    implements DeleteQuestionUseCase {}
