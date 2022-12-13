import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  group('copyWith', () {
    group('shortDescription', () {
      for (final value in ['gift', 'prompt']) {
        test(value, () {
          final entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: const <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: const <QuestionCategory>[],
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
          final entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: const <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: const <QuestionCategory>[],
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
          final entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: const <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: const <QuestionCategory>[],
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
          final entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: const <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: const <QuestionCategory>[],
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
          final entity = Question(
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: const <AnswerOption>[],
            difficulty: QuestionDifficulty.easy,
            categories: const <QuestionCategory>[],
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
      Question(
        shortDescription: 'shortDescription',
        description: 'description',
        answerOptions: const <AnswerOption>[],
        difficulty: QuestionDifficulty.unknown,
        categories: const <QuestionCategory>[],
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
