import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late DeleteQuestionUseCase useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    useCase = DeleteQuestionUseCase(
      questionRepository: questionRepositoryMock,
    );

    registerFallbackValue(_MockQuestionId());
  });

  tearDown(resetMocktailState);

  parameterizedTest(
    'should call repository correctly',
    ParameterizedSource.value(['', '!ocOs9d', '*k^rVV']),
    (values) async {
      final questionId = values[0] as String;

      when(() => questionRepositoryMock.deleteSingle(any()))
          .thenAnswer((_) async => const Result.ok(unit));

      await useCase.execute(questionId);

      verify(() => questionRepositoryMock.deleteSingle(QuestionId(questionId)))
          .called(1);
    },
  );
}

class _QuestionRepositoryMock extends Mock implements QuestionRepository {}

class _MockQuestionId extends Mock implements QuestionId {}
