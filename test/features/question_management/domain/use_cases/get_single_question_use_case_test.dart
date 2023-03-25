import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late GetSingleQuestionUseCase useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    useCase =
        GetSingleQuestionUseCase(questionRepository: questionRepositoryMock);

    mocktail.registerFallbackValue(_QuestionIdMock());
  });

  tearDown(mocktail.resetMocktailState);

  group('err flow', () {
    test(
      'should return nothing if question repository fails',
      () async {
        mocktail
            .when(() => questionRepositoryMock.getSingle(mocktail.any()))
            .thenAnswer(
              (_) async => const Result.err(
                QuestionRepositoryUnexpectedFailure(message: 'B19^Qwu4'),
              ),
            );

        final result = await useCase.execute('5iPj@0V');

        expect(result.isErr, true);
        expect(result.err, unit);
      },
    );

    test('should return question not found message for null id', () async {
      final result = await useCase.execute(null);

      expect(result.isErr, true);
      expect(result.err, unit);
    });
  });

  group('ok flow', () {
    parameterizedTest(
      'should return question from question repository',
      ParameterizedSource.value([
        '',
        'bjS',
      ]),
      (values) async {
        final targetQuestionId = values[0] as String;
        final questionMock = _QuestionMock();

        mocktail
            .when(
              () => questionRepositoryMock
                  .getSingle(QuestionId(targetQuestionId)),
            )
            .thenAnswer((_) async => Result.ok(questionMock));

        final result = await useCase.execute(targetQuestionId);

        expect(result.isOk, true);
        expect(result.ok, questionMock);
      },
    );
  });
}

class _QuestionRepositoryMock extends mocktail.Mock
    implements QuestionRepository {}

class _QuestionMock extends mocktail.Mock implements Question {}

class _QuestionIdMock extends mocktail.Mock implements QuestionId {}
