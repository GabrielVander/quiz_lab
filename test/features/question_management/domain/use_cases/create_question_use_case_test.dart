import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late ResourceUuidGenerator mockUuidGenerator;
  late CreateQuestionUseCase useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    mockUuidGenerator = _MockResourceUuidGenerator();

    useCase = CreateQuestionUseCase(
      questionRepository: questionRepositoryMock,
      uuidGenerator: mockUuidGenerator,
    );
  });

  tearDown(resetMocktailState);

  group('err flow', () {
    setUp(() => registerFallbackValue(_FakeQuestion()));

    parameterizedTest(
      'unable to parse input',
      ParameterizedSource.values([
        [
          const QuestionCreationInput(
            shortDescription: '',
            description: '',
            difficulty: '',
            options: [],
            categories: [],
          ),
          CreateQuestionUseCaseFailure.unableToParseDifficulty(value: ''),
        ],
        [
          const QuestionCreationInput(
            shortDescription: '3Yd0',
            description: 'f19!t',
            difficulty: '8Fy',
            options: [],
            categories: ['Du0QQGO', 'O95eCUO'],
          ),
          CreateQuestionUseCaseFailure.unableToParseDifficulty(value: '8Fy'),
        ]
      ]),
      (values) async {
        final input = values[0] as QuestionCreationInput;
        final expectedFailure = values[1] as CreateQuestionUseCaseFailure;

        final result = await useCase.execute(input);

        expect(result.isErr, isTrue);
        expect(result.err, expectedFailure);
      },
    );

    parameterizedTest(
      'question repository fails',
      ParameterizedSource.values([
        [
          const QuestionCreationInput(
            shortDescription: '',
            description: '',
            difficulty: 'medium',
            options: [],
            categories: [],
          ),
          '',
          QuestionRepositoryFailure.unableToCreate(
            question: _FakeQuestion(),
            message: '8&tL6xjE',
          ),
          CreateQuestionUseCaseFailure.unableToCreate(
            receivedInput: const QuestionCreationInput(
              shortDescription: '',
              description: '',
              difficulty: 'medium',
              options: [],
              categories: [],
            ),
            message: '8&tL6xjE',
          ),
        ],
        [
          const QuestionCreationInput(
            shortDescription: 'short',
            description: 'description',
            difficulty: 'easy',
            options: [
              QuestionCreationOptionInput(
                description: 'description',
                isCorrect: false,
              )
            ],
            categories: ['category'],
          ),
          'uuid',
          QuestionRepositoryFailure.unableToParseEntity(message: ''),
          CreateQuestionUseCaseFailure.unableToCreate(
            receivedInput: const QuestionCreationInput(
              shortDescription: 'short',
              description: 'description',
              difficulty: 'easy',
              options: [
                QuestionCreationOptionInput(
                  description: 'description',
                  isCorrect: false,
                )
              ],
              categories: ['category'],
            ),
            message: '',
          ),
        ],
        [
          const QuestionCreationInput(
            shortDescription: '336dhR',
            description: '91A^*#Z',
            difficulty: 'hard',
            options: [
              QuestionCreationOptionInput(
                description: '3W55p',
                isCorrect: false,
              ),
              QuestionCreationOptionInput(
                description: 'n&!MLH1',
                isCorrect: true,
              ),
            ],
            categories: ['y6q729L', '3^*#Z'],
          ),
          'pvx',
          QuestionRepositoryFailure.unableToParseEntity(message: '4p&'),
          CreateQuestionUseCaseFailure.unableToCreate(
            receivedInput: const QuestionCreationInput(
              shortDescription: '336dhR',
              description: '91A^*#Z',
              difficulty: 'hard',
              options: [
                QuestionCreationOptionInput(
                  description: '3W55p',
                  isCorrect: false,
                ),
                QuestionCreationOptionInput(
                  description: 'n&!MLH1',
                  isCorrect: true,
                ),
              ],
              categories: ['y6q729L', '3^*#Z'],
            ),
            message: '4p&',
          ),
        ],
      ]),
      (values) async {
        final input = values[0] as QuestionCreationInput;
        final uuid = values[1] as String;
        final repositoryFailure = values[2] as QuestionRepositoryFailure;
        final expectedFailure = values[3] as CreateQuestionUseCaseFailure;

        when(() => mockUuidGenerator.generate()).thenReturn(uuid);

        when(() => questionRepositoryMock.createSingle(any()))
            .thenAnswer((_) async => Result.err(repositoryFailure));

        final result = await useCase.execute(input);

        expect(result.isErr, isTrue);
        expect(result.err, expectedFailure);
      },
    );
  });

  group('ok flow', () {
    parameterizedTest(
      'should call repository correctly',
      ParameterizedSource.values([
        [
          const QuestionCreationInput(
            shortDescription: 'shortDescription',
            description: 'description',
            difficulty: 'easy',
            options: [],
            categories: [],
          ),
          '',
          const Question(
            id: '',
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: [],
            difficulty: QuestionDifficulty.easy,
            categories: [],
          )
        ],
        [
          const QuestionCreationInput(
            shortDescription: 'nkl!',
            description: 'oaK',
            difficulty: 'medium',
            options: [
              QuestionCreationOptionInput(
                description: '!Iu6RU',
                isCorrect: false,
              ),
              QuestionCreationOptionInput(
                description: 'xBq',
                isCorrect: true,
              )
            ],
            categories: ['3@0lv*ip', '@1H7'],
          ),
          'LO^*8O*4',
          const Question(
            id: 'LO^*8O*4',
            shortDescription: 'nkl!',
            description: 'oaK',
            answerOptions: [
              AnswerOption(description: '!Iu6RU', isCorrect: false),
              AnswerOption(description: 'xBq', isCorrect: true),
            ],
            difficulty: QuestionDifficulty.medium,
            categories: [
              QuestionCategory(value: '3@0lv*ip'),
              QuestionCategory(value: '@1H7')
            ],
          )
        ],
      ]),
      (values) async {
        final input = values[0] as QuestionCreationInput;
        final uuid = values[1] as String;
        final expected = values[2] as Question;

        when(() => mockUuidGenerator.generate()).thenReturn(uuid);

        when(() => questionRepositoryMock.createSingle(any()))
            .thenAnswer((_) async => const Result.ok(unit));

        await useCase.execute(input);

        verify(() => questionRepositoryMock.createSingle(expected)).called(1);
      },
    );
  });
}

@immutable
class _FakeQuestion extends Fake with EquatableMixin implements Question {
  @override
  List<Object> get props => [];
}

class _QuestionRepositoryMock extends Mock implements QuestionRepository {}

class _MockResourceUuidGenerator extends Mock
    implements ResourceUuidGenerator {}
