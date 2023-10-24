import 'package:flutter_test/flutter_test.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart';

void main() {
  group('answerWith', () {
    group('should return Ok with expected result', () {
      for (final testCase in [
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [Answer(id: '1a@l', description: 'f0&', isCorrect: true)],
          ),
          '1a@l',
          const QuestionResult(
            answeredCorrectly: true,
            correctAnswersIds: ['1a@l'],
          )
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          '1a@l',
          const QuestionResult(
            answeredCorrectly: true,
            correctAnswersIds: ['1a@l', 'G93@y', r'$!G'],
          )
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          'G93@y',
          const QuestionResult(
            answeredCorrectly: true,
            correctAnswersIds: ['1a@l', 'G93@y', r'$!G'],
          )
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          r'$!G',
          const QuestionResult(
            answeredCorrectly: true,
            correctAnswersIds: ['1a@l', 'G93@y', r'$!G'],
          )
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: false),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          '1a@l',
          const QuestionResult(
            answeredCorrectly: false,
            correctAnswersIds: ['G93@y', r'$!G'],
          )
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: false),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          'G93@y',
          const QuestionResult(
            answeredCorrectly: false,
            correctAnswersIds: ['1a@l', r'$!G'],
          )
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: false),
            ],
          ),
          r'$!G',
          const QuestionResult(
            answeredCorrectly: false,
            correctAnswersIds: ['1a@l', 'G93@y'],
          )
        ),
      ]) {
        final question = testCase.$1;
        final answerId = testCase.$2;
        final expectedResult = testCase.$3;

        test('when called with $question as question and $answerId as answerId should return $expectedResult', () {
          final result = question.answerWith(answerId);

          expect(result, Ok<QuestionResult, dynamic>(expectedResult));
        });
      }
    });

    group('should return Err with expected failure', () {
      for (final testCase in [
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [],
          ),
          'HoX#',
          NoAnswersFailure()
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: false),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: false),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: false),
            ],
          ),
          'x*%*',
          NoCorrectAnswerFailure()
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          'x*%*',
          AnswerNotFoundFailure('x*%*')
        ),
        (
          const AnswerableQuestion(
            id: '1q@l',
            title: 'f0&',
            description: 'a#tDj*11',
            difficulty: QuestionDifficulty.easy,
            answers: [
              Answer(id: '1a@l', description: 'f0&', isCorrect: true),
              Answer(id: 'G93@y', description: '6@0%1', isCorrect: true),
              Answer(id: r'$!G', description: r'^5qB%$7v', isCorrect: true),
            ],
          ),
          'KMOFP',
          AnswerNotFoundFailure('KMOFP')
        ),
      ]) {
        final question = testCase.$1;
        final answerId = testCase.$2;
        final expectedFailure = testCase.$3;

        test('when called with $question as question and $answerId as answerId should return $expectedFailure', () {
          final result = question.answerWith(answerId);

          expect(result, Err<dynamic, AnswerFailure>(expectedFailure));
        });
      }
    });
  });
}
