import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';

void main() {
  group('toString', () {
    for (final testCase in [
      const _ToStringTestCase(
        entity: Question(
          shortDescription: 'shortDescription',
          description: 'description',
          answerOptions: [],
          difficulty: QuestionDifficulty.medium,
          categories: [],
        ),
        expectedResult: 'Question{ id: null, '
            'shortDescription: shortDescription, '
            'description: description, answerOptions: [], '
            'difficulty: QuestionDifficulty.medium, categories: [], }',
      ),
      const _ToStringTestCase(
        entity: Question(
          shortDescription: 'moral',
          description: 'ornament',
          answerOptions: [
            AnswerOption(description: 'father', isCorrect: false)
          ],
          difficulty: QuestionDifficulty.easy,
          categories: [QuestionCategory(value: 'ball')],
        ),
        expectedResult: 'Question{ id: null, '
            'shortDescription: moral, '
            'description: ornament, '
            'answerOptions: [AnswerOption{ description: father, '
            'isCorrect: false, }], '
            'difficulty: QuestionDifficulty.easy, '
            'categories: [QuestionCategory{ value: ball, }], }',
      )
    ]) {
      test(testCase.expectedResult, () {
        expect(testCase.entity.toString(), testCase.expectedResult);
      });
    }
  });

  group('copyWith', () {
    group('shortDescription', () {
      for (final value in ['gift', 'prompt']) {
        test(value, () {
          const entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: <QuestionCategory>[],
          );

          final copy = entity.copyWith(shortDescription: value);

          expect(copy.shortDescription, value);
          expect(copy.description, 'description');
          expect(copy.answerOptions, <AnswerOption>[]);
          expect(copy.difficulty, QuestionDifficulty.easy);
          expect(copy.categories, <QuestionCategory>[]);
        });
      }
    });

    group('description', () {
      for (final value in ['customer', 'aside']) {
        test(value, () {
          const entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: <QuestionCategory>[],
          );

          final copy = entity.copyWith(description: value);

          expect(copy.description, value);
          expect(copy.shortDescription, 'shortDescription');
          expect(copy.answerOptions, <AnswerOption>[]);
          expect(copy.difficulty, QuestionDifficulty.easy);
          expect(copy.categories, <QuestionCategory>[]);
        });
      }
    });

    group('answerOptions', () {
      for (final value in [
        <AnswerOption>[],
        [const AnswerOption(description: 'feel', isCorrect: true)]
      ]) {
        test(value, () {
          const entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: <QuestionCategory>[],
          );

          final copy = entity.copyWith(answerOptions: value);

          expect(copy.answerOptions, value);
          expect(copy.shortDescription, 'shortDescription');
          expect(copy.description, 'description');
          expect(copy.difficulty, QuestionDifficulty.easy);
          expect(copy.categories, <QuestionCategory>[]);
        });
      }
    });

    group('difficulty', () {
      for (final value in [
        QuestionDifficulty.unknown,
        QuestionDifficulty.easy,
        QuestionDifficulty.medium,
        QuestionDifficulty.hard,
      ]) {
        test(value, () {
          const entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: <QuestionCategory>[],
          );

          final copy = entity.copyWith(difficulty: value);

          expect(copy.difficulty, value);
          expect(copy.shortDescription, 'shortDescription');
          expect(copy.description, 'description');
          expect(copy.answerOptions, <AnswerOption>[]);
          expect(copy.categories, <QuestionCategory>[]);
        });
      }
    });

    group('categories', () {
      for (final value in [
        <QuestionCategory>[],
        [const QuestionCategory(value: 'dot')]
      ]) {
        test(value, () {
          const entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: <QuestionCategory>[],
          );

          final copy = entity.copyWith(categories: value);

          expect(copy.categories, value);
          expect(copy.shortDescription, 'shortDescription');
          expect(copy.description, 'description');
          expect(copy.answerOptions, <AnswerOption>[]);
          expect(copy.difficulty, QuestionDifficulty.easy);
        });
      }
    });
  });

  group('props', () {
    for (final entity in [
      const Question(
        shortDescription: 'shortDescription',
        description: 'description',
        answerOptions: <AnswerOption>[],
        difficulty: QuestionDifficulty.unknown,
        categories: <QuestionCategory>[],
      ),
    ]) {
      test(entity.toString(), () {
        expect(entity.props, [
          entity.id,
          entity.shortDescription,
          entity.description,
          entity.answerOptions,
          entity.difficulty,
          entity.categories,
        ]);
      });
    }
  });
}

class _ToStringTestCase {
  const _ToStringTestCase({
    required this.entity,
    required this.expectedResult,
  });

  final Question entity;
  final String expectedResult;
}
