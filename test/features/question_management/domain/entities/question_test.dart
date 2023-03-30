import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

void main() {
  group('copyWith', () {
    parameterizedTest(
      'id',
      ParameterizedSource.value([
        '',
        '0h*GnqDx',
      ]),
      (values) {
        final newValue = values[0] as String;

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
      },
    );

    parameterizedTest(
      'shortDescription',
      ParameterizedSource.value(['gift', 'prompt']),
      (values) {
        final newValue = values[0] as String;

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
      },
    );

    parameterizedTest(
      'description',
      ParameterizedSource.value(['customer', 'aside']),
      (values) {
        final newValue = values[0] as String;

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
      },
    );

    parameterizedTest(
        'answerOptions',
        ParameterizedSource.value([
          <AnswerOption>[],
          [const AnswerOption(description: 'feel', isCorrect: true)]
        ]), (values) {
      final newValue = values[0] as List<AnswerOption>;

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

    parameterizedTest(
      'difficulty',
      ParameterizedSource.value([
        QuestionDifficulty.unknown,
        QuestionDifficulty.easy,
        QuestionDifficulty.medium,
        QuestionDifficulty.hard,
      ]),
      (values) {
        final newValue = values[0] as QuestionDifficulty;

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
      },
    );

    parameterizedTest(
      'categories',
      ParameterizedSource.value([
        <QuestionCategory>[],
        [const QuestionCategory(value: 'dot')]
      ]),
      (values) {
        final newValue = values[0] as List<QuestionCategory>;

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
      },
    );
  });
}
