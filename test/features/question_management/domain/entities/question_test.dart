import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  group('copyWith', () {
    group(
      'id',
      () {
        for (final newValue in [
          '',
          '0h*GnqDx',
        ]) {
          test(newValue, () {
            const question = Question(
              id: QuestionId('id'),
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: [],
              difficulty: QuestionDifficulty.easy,
              categories: [],
            );

            final copy = question.copyWith(id: QuestionId(newValue));

            expect(copy.id.value, newValue);
            expect(copy.shortDescription, 'shortDescription');
            expect(copy.description, 'description');
            expect(copy.answerOptions, <AnswerOption>[]);
            expect(copy.difficulty, QuestionDifficulty.easy);
            expect(copy.categories, <QuestionCategory>[]);
          });
        }
      },
    );

    group(
      'shortDescription',
      () {
        for (final newValue in [
          'gift',
          'prompt',
        ]) {
          test(newValue, () {
            const entity = Question(
              id: QuestionId('id'),
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: <AnswerOption>[],
              difficulty: QuestionDifficulty.easy,
              categories: <QuestionCategory>[],
            );

            final copy = entity.copyWith(shortDescription: newValue);

            expect(copy.shortDescription, newValue);
            expect(copy.description, 'description');
            expect(copy.answerOptions, <AnswerOption>[]);
            expect(copy.difficulty, QuestionDifficulty.easy);
            expect(copy.categories, <QuestionCategory>[]);
          });
        }
      },
    );

    group(
      'description',
      () {
        for (final newValue in [
          'customer',
          'aside',
        ]) {
          test(newValue, () {
            const entity = Question(
              id: QuestionId('id'),
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: <AnswerOption>[],
              difficulty: QuestionDifficulty.easy,
              categories: <QuestionCategory>[],
            );

            final copy = entity.copyWith(description: newValue);

            expect(copy.description, newValue);
            expect(copy.shortDescription, 'shortDescription');
            expect(copy.answerOptions, <AnswerOption>[]);
            expect(copy.difficulty, QuestionDifficulty.easy);
            expect(copy.categories, <QuestionCategory>[]);
          });
        }
      },
    );

    group(
      'answerOptions',
      () {
        for (final newValue in [
          <AnswerOption>[],
          [const AnswerOption(description: 'feel', isCorrect: true)]
        ]) {
          test(newValue.toString(), () {
            const entity = Question(
              id: QuestionId('id'),
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: <AnswerOption>[],
              difficulty: QuestionDifficulty.easy,
              categories: <QuestionCategory>[],
            );

            final copy = entity.copyWith(answerOptions: newValue);

            expect(copy.answerOptions, newValue);
            expect(copy.shortDescription, 'shortDescription');
            expect(copy.description, 'description');
            expect(copy.difficulty, QuestionDifficulty.easy);
            expect(copy.categories, <QuestionCategory>[]);
          });
        }
      },
    );

    group(
      'difficulty',
      () {
        for (final newValue in [
          QuestionDifficulty.unknown,
          QuestionDifficulty.easy,
          QuestionDifficulty.medium,
          QuestionDifficulty.hard,
        ]) {
          test(newValue.toString(), () {
            const entity = Question(
              id: QuestionId('id'),
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: <AnswerOption>[],
              difficulty: QuestionDifficulty.easy,
              categories: <QuestionCategory>[],
            );

            final copy = entity.copyWith(difficulty: newValue);

            expect(copy.difficulty, newValue);
            expect(copy.shortDescription, 'shortDescription');
            expect(copy.description, 'description');
            expect(copy.answerOptions, <AnswerOption>[]);
            expect(copy.categories, <QuestionCategory>[]);
          });
        }
      },
    );

    group(
      'categories',
      () {
        for (final newValue in [
          <QuestionCategory>[],
          [const QuestionCategory(value: 'dot')]
        ]) {
          test(newValue.toString(), () {
            const entity = Question(
              id: QuestionId('id'),
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: <AnswerOption>[],
              difficulty: QuestionDifficulty.easy,
              categories: <QuestionCategory>[],
            );

            final copy = entity.copyWith(categories: newValue);

            expect(copy.categories, newValue);
            expect(copy.shortDescription, 'shortDescription');
            expect(copy.description, 'description');
            expect(copy.answerOptions, <AnswerOption>[]);
            expect(copy.difficulty, QuestionDifficulty.easy);
          });
        }
      },
    );
  });
}
