import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';

void main() {
  late RepositoryFactory mockRepositoryFactory;
  late DeleteQuestionUseCase useCase;

  setUp(() {
    mockRepositoryFactory = _MockRepositoryFactory();

    useCase = DeleteQuestionUseCase(
      repositoryFactory: mockRepositoryFactory,
    );
  });

  tearDown(resetMocktailState);

  parameterizedTest(
    'should call repository correctly',
    ParameterizedSource.value(['', '!ocOs9d', '*k^rVV']),
    (values) async {
      final questionId = values[0] as String;

      final mockQuestionRepository = _MockQuestionRepository();

      when(() => mockRepositoryFactory.makeQuestionRepository())
          .thenReturn(mockQuestionRepository);

      when(() => mockQuestionRepository.deleteSingle(any()))
          .thenAnswer((_) async => const Result.ok(unit));

      await useCase.execute(questionId);

      verify(() => mockQuestionRepository.deleteSingle(questionId)).called(1);
    },
  );
}

class _MockRepositoryFactory extends Mock implements RepositoryFactory {}

class _MockQuestionRepository extends Mock implements QuestionRepository {}
