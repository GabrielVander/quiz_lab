import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/get_question_with_id.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late GetQuestionWithId useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    useCase = GetQuestionWithId(questionRepository: questionRepositoryMock);

    mocktail.registerFallbackValue(_QuestionIdMock());
  });

  tearDown(mocktail.resetMocktailState);

  group('err flow', () {
    test(
      'should return nothing if question repository fails',
      () async {
        mocktail.when(() => questionRepositoryMock.getSingle(mocktail.any())).thenAnswer(
              (_) async => const Err(
                QuestionRepositoryUnexpectedFailure(message: 'B19^Qwu4'),
              ),
            );

        final result = await useCase.execute('5iPj@0V');

        expect(result.isErr, true);
        expect(result.unwrapErr(), unit);
      },
    );

    test('should return question not found message for null id', () async {
      final result = await useCase.execute(null);

      expect(result.isErr, true);
      expect(result.unwrapErr(), unit);
    });
  });

  group('ok flow', () {
    group(
      'should return question from question repository',
      () {
        for (final targetQuestionId in [
          '',
          'bjS',
        ]) {
          test(targetQuestionId, () async {
            final questionMock = _QuestionMock();

            mocktail
                .when(
                  () => questionRepositoryMock.getSingle(QuestionId(targetQuestionId)),
                )
                .thenAnswer((_) async => Ok(questionMock));

            final result = await useCase.execute(targetQuestionId);

            expect(result.isOk, true);
            expect(result.unwrap(), questionMock);
          });
        }
      },
    );
  });
}

class _QuestionRepositoryMock extends mocktail.Mock implements QuestionRepository {}

class _QuestionMock extends mocktail.Mock implements Question {}

class _QuestionIdMock extends mocktail.Mock implements QuestionId {}
