import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/retrieve_question.dart';
import 'package:rust_core/result.dart';

void main() {
  late QuizLabLogger logger;
  late QuestionRepository questionRepository;

  late RetrieveQuestion useCase;

  setUp(() {
    logger = _MockQuizLabLogger();
    questionRepository = _MockQuestionRepository();

    useCase = RetrieveQuestionImpl(logger: logger, questionRepository: questionRepository);
  });

  tearDown(resetMocktailState);

  test('should log initial message', () async {
    await useCase.call(null);

    verify(() => logger.debug('Executing...')).called(1);
  });

  group('should return Err', () {
    test('if id is null', () async {
      final result = await useCase.call(null);

      expect(result, const Err<dynamic, String>('Unable to get question: No id given'));
    });

    group('when question repository fails', () {
      for (final testCase in [('60xnIL', 'LTnu'), ('Q3U861*#', 'QD&6')]) {
        final id = testCase.$1;
        final message = testCase.$2;

        test('with $id as id and $message as error message', () async {
          when(() => questionRepository.fetchQuestionWithId(any())).thenAnswer((_) async => Err(message));

          final result = await useCase.call(id);

          verify(() => questionRepository.fetchQuestionWithId(id)).called(1);
          verify(() => logger.error(message)).called(1);
          expect(result, const Err<dynamic, String>('Unable to retrieve question'));
        });
      }
    });
  });

  group('should return Ok with expected question', () {
    for (final id in [r'f$FasG@%', 'bjS']) {
      test('with $id as id', () async {
        final expected = _MockAnswerableQuestion();

        when(() => questionRepository.fetchQuestionWithId(any())).thenAnswer((_) async => Ok(expected));

        final result = await useCase.call(id);

        verify(() => questionRepository.fetchQuestionWithId(id)).called(1);
        verify(() => logger.debug('Question retrieved')).called(1);
        expect(result, Ok<AnswerableQuestion, String>(expected));
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockQuestionRepository extends Mock implements QuestionRepository {}

class _MockAnswerableQuestion extends Mock implements AnswerableQuestion {}
