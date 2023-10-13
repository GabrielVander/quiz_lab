import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/get_question_with_id.dart';

void main() {
  late QuizLabLogger logger;
  late QuestionRepository questionRepository;

  late GetQuestionWithId useCase;

  setUp(() {
    logger = _MockQuizLabLogger();
    questionRepository = _MockQuestionRepository();

    useCase = GetQuestionWithIdImpl(logger: logger, questionRepository: questionRepository);
  });

  tearDown(resetMocktailState);

  test('should log initial message', () async {
    await useCase.call(null);

    verify(() => logger.debug('Executing...')).called(1);
  });

  group('should return Err', () {
    test('if id is null', () async {
      final result = await useCase.call(null);

      verify(() => logger.error('Unable to get question: No id given')).called(1);
      expect(result, const Err<dynamic, Unit>(unit));
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
          expect(result, const Err<dynamic, Unit>(unit));
        });
      }
    });
  });

  group('should return Ok with expected question', () {
    for (final id in [r'f$FasG@%', 'bjS']) {
      test('with $id as id', () async {
        final expected = _MockQuestion();

        when(() => questionRepository.fetchQuestionWithId(any())).thenAnswer((_) async => Ok(expected));

        final result = await useCase.call(id);

        verify(() => questionRepository.fetchQuestionWithId(id)).called(1);
        verify(() => logger.debug('Question retrieved')).called(1);
        expect(result, Ok<Question, dynamic>(expected));
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockQuestionRepository extends Mock implements QuestionRepository {}

class _MockQuestion extends Mock implements Question {}
