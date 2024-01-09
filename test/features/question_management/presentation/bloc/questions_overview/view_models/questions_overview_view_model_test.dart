import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_owner.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/view_models/questions_overview_view_model.dart';

void main() {
  group('fromQuestion', () {
    group('should return a valid QuestionOverviewViewModel', () {
      for (final values in [
        [
          const Question(
            id: QuestionId(''),
            shortDescription: '',
            description: '',
            answerOptions: [],
            difficulty: QuestionDifficulty.unknown,
            categories: [],
          ),
          const QuestionsOverviewItemViewModel(
            id: '',
            shortDescription: '',
            description: '',
            difficulty: 'unknown',
            categories: [],
            owner: null,
          ),
        ],
        [
          const Question(
            id: QuestionId('b5h'),
            shortDescription: 'ma8eVP%*',
            description: '0kt4S3',
            answerOptions: [
              AnswerOption(description: 'r*%*', isCorrect: false),
            ],
            difficulty: QuestionDifficulty.easy,
            categories: [QuestionCategory(value: r'7$P')],
            owner: QuestionOwner(displayName: '0RZ'),
          ),
          const QuestionsOverviewItemViewModel(
            id: 'b5h',
            shortDescription: 'ma8eVP%*',
            description: '0kt4S3',
            difficulty: 'easy',
            categories: [r'7$P'],
            owner: '0RZ',
          ),
        ],
        [
          const Question(
            id: QuestionId(r'$U!'),
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            answerOptions: [
              AnswerOption(description: '0*T', isCorrect: false),
              AnswerOption(description: 'ntZ', isCorrect: false),
              AnswerOption(description: '7QaXKo3', isCorrect: false),
            ],
            difficulty: QuestionDifficulty.medium,
            categories: [
              QuestionCategory(value: 'XldJ1LO'),
              QuestionCategory(value: '#NHS1bgU'),
              QuestionCategory(value: r'C^$D%QK'),
            ],
            owner: QuestionOwner(displayName: 'itlEvFR9'),
          ),
          const QuestionsOverviewItemViewModel(
            id: r'$U!',
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            difficulty: 'medium',
            categories: [
              'XldJ1LO',
              '#NHS1bgU',
              r'C^$D%QK',
            ],
            owner: 'itlEvFR9',
          ),
        ],
        [
          const Question(
            id: QuestionId(r'$U!'),
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            answerOptions: [],
            difficulty: QuestionDifficulty.hard,
            categories: [],
          ),
          const QuestionsOverviewItemViewModel(
            id: r'$U!',
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            difficulty: 'hard',
            categories: [],
            owner: null,
          ),
        ],
      ]) {
        test(values.toString(), () {
          final question = values[0] as Question;
          final expected = values[1] as QuestionsOverviewItemViewModel;

          final result = QuestionsOverviewItemViewModel.fromQuestion(question);

          expect(result, expected);
        });
      }
    });
  });

  group(
    'toQuestion should map correctly',
    () {
      for (final values in [
        [
          const QuestionsOverviewItemViewModel(
            id: '',
            shortDescription: '',
            description: '',
            categories: [],
            difficulty: 'unknown',
            owner: null,
          ),
          const Question(
            id: QuestionId(''),
            shortDescription: '',
            description: '',
            answerOptions: [],
            categories: [],
            difficulty: QuestionDifficulty.unknown,
          ),
        ],
        [
          const QuestionsOverviewItemViewModel(
            id: 'hiTGMK',
            shortDescription: 'Ico',
            description: '9J7c',
            categories: [
              'GcroY&',
              '9vmI4c',
              'Zra7R#',
            ],
            difficulty: 'easy',
            owner: '7u8Oc9',
          ),
          const Question(
            id: QuestionId('hiTGMK'),
            shortDescription: 'Ico',
            description: '9J7c',
            answerOptions: [],
            categories: [
              QuestionCategory(value: 'GcroY&'),
              QuestionCategory(value: '9vmI4c'),
              QuestionCategory(value: 'Zra7R#'),
            ],
            difficulty: QuestionDifficulty.easy,
            owner: QuestionOwner(displayName: '7u8Oc9'),
          ),
        ],
      ]) {
        test(values.toString(), () {
          final viewModel = values[0] as QuestionsOverviewItemViewModel;
          final expectedQuestion = values[1] as Question;

          final result = viewModel.toQuestion();

          expect(result, expectedQuestion);
        });
      }
    },
  );
}
