import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

void main() {
  late QuestionOverviewItemViewModelMapper mapper;

  setUp(() {
    mapper = QuestionOverviewItemViewModelMapper();
  });

  group('singleFromQuestionEntity', () {
    parameterizedTest(
      'should return a valid QuestionOverviewViewModel',
      ParameterizedSource.values([
        [
          const Question(
            id: '',
            shortDescription: '',
            description: '',
            answerOptions: [],
            difficulty: QuestionDifficulty.unknown,
            categories: [],
          ),
          const QuestionOverviewItemViewModel(
            id: '',
            shortDescription: '',
            description: '',
            difficulty: 'unknown',
            categories: [],
          ),
        ],
        [
          const Question(
            id: 'b5h',
            shortDescription: 'ma8eVP%*',
            description: '0kt4S3',
            answerOptions: [
              AnswerOption(description: 'r*%*', isCorrect: false),
            ],
            difficulty: QuestionDifficulty.easy,
            categories: [QuestionCategory(value: r'7$P')],
          ),
          const QuestionOverviewItemViewModel(
            id: 'b5h',
            shortDescription: 'ma8eVP%*',
            description: '0kt4S3',
            difficulty: 'easy',
            categories: [r'7$P'],
          ),
        ],
        [
          const Question(
            id: r'$U!',
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
          ),
          const QuestionOverviewItemViewModel(
            id: r'$U!',
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            difficulty: 'medium',
            categories: [
              'XldJ1LO',
              '#NHS1bgU',
              r'C^$D%QK',
            ],
          ),
        ],
        [
          const Question(
            id: r'$U!',
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            answerOptions: [],
            difficulty: QuestionDifficulty.hard,
            categories: [],
          ),
          const QuestionOverviewItemViewModel(
            id: r'$U!',
            shortDescription: 'cT3u&e5a',
            description: '!nBfpz&6',
            difficulty: 'hard',
            categories: [],
          ),
        ],
      ]),
      (values) {
        final question = values[0] as Question;
        final expected = values[1] as QuestionOverviewItemViewModel;

        final result = mapper.singleFromQuestionEntity(question);

        expect(result, expected);
      },
    );
  });

  group('multipleFromQuestionEntity', () {
    parameterizedTest(
      'should return valid QuestionOverviewViewModels',
      ParameterizedSource.values([
        [
          [
            const Question(
              id: '',
              shortDescription: '',
              description: '',
              answerOptions: [],
              difficulty: QuestionDifficulty.unknown,
              categories: [],
            ),
            const Question(
              id: 'b5h',
              shortDescription: 'ma8eVP%*',
              description: '0kt4S3',
              answerOptions: [
                AnswerOption(description: 'r*%*', isCorrect: false),
              ],
              difficulty: QuestionDifficulty.easy,
              categories: [QuestionCategory(value: r'7$P')],
            ),
            const Question(
              id: r'$U!',
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
            ),
            const Question(
              id: r'$U!',
              shortDescription: 'cT3u&e5a',
              description: '!nBfpz&6',
              answerOptions: [],
              difficulty: QuestionDifficulty.hard,
              categories: [],
            ),
          ],
          [
            const QuestionOverviewItemViewModel(
              id: '',
              shortDescription: '',
              description: '',
              difficulty: 'unknown',
              categories: [],
            ),
            const QuestionOverviewItemViewModel(
              id: 'b5h',
              shortDescription: 'ma8eVP%*',
              description: '0kt4S3',
              difficulty: 'easy',
              categories: [r'7$P'],
            ),
            const QuestionOverviewItemViewModel(
              id: r'$U!',
              shortDescription: 'cT3u&e5a',
              description: '!nBfpz&6',
              difficulty: 'medium',
              categories: [
                'XldJ1LO',
                '#NHS1bgU',
                r'C^$D%QK',
              ],
            ),
            const QuestionOverviewItemViewModel(
              id: r'$U!',
              shortDescription: 'cT3u&e5a',
              description: '!nBfpz&6',
              difficulty: 'hard',
              categories: [],
            ),
          ]
        ],
      ]),
      (values) {
        final questions = values[0] as List<Question>;
        final expected = values[1] as List<QuestionOverviewItemViewModel>;

        final result = mapper.multipleFromQuestionEntity(questions);

        expect(result, expected);
      },
    );
  });
}
