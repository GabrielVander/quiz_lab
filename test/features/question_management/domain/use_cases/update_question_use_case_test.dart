import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late UpdateQuestionUseCase useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    useCase = UpdateQuestionUseCase(
      questionRepository: questionRepositoryMock,
    );
  });

  tearDown(resetMocktailState);

  group('err flow', () {
    parameterizedTest(
      'should fail if repository fails',
      ParameterizedSource.values([
        [
          _FakeQuestion.id(''),
          QuestionRepositoryFailure.unableToUpdate(
            id: '',
            details: '',
          ),
          UpdateQuestionUseCaseFailure.repositoryFailure(
            'Unable to update question with id : ',
          ),
        ],
        [
          _FakeQuestion.id('&RV'),
          QuestionRepositoryFailure.unableToUpdate(
            id: '&RV',
            details: 'eg3381',
          ),
          UpdateQuestionUseCaseFailure.repositoryFailure(
            'Unable to update question with id &RV: eg3381',
          ),
        ],
      ]),
      (values) async {
        final question = values[0] as Question;
        final repoFailure = values[1] as QuestionRepositoryFailure;
        final expectedFailure = values[2] as UpdateQuestionUseCaseFailure;

        when(() => questionRepositoryMock.updateSingle(question))
            .thenAnswer((_) async => Result.err(repoFailure));

        final result = await useCase.execute(question);

        expect(result.isErr, isTrue);
        expect(result.err, expectedFailure);
      },
    );
  });

  group('ok flow', () {
    parameterizedTest(
      'should return ok',
      ParameterizedSource.value([
        const Question(
          id: '',
          shortDescription: '',
          description: '',
          categories: [],
          difficulty: QuestionDifficulty.unknown,
          answerOptions: [],
        ),
        const Question(
          id: 'a019cc50-db0b-42e2-895a-ac5a37a79faa',
          shortDescription: 'hunger',
          description: 'Nuptias ire, tanquam superbus hippotoxota.',
          categories: [
            QuestionCategory(value: 'sail'),
            QuestionCategory(value: 'pen'),
            QuestionCategory(value: 'station'),
          ],
          difficulty: QuestionDifficulty.hard,
          answerOptions: [
            AnswerOption(description: 'fort charles ', isCorrect: false),
            AnswerOption(description: 'yardarm ', isCorrect: true),
            AnswerOption(description: 'fortune ', isCorrect: false),
          ],
        )
      ]),
      (values) async {
        final input = values[0] as Question;

        when(() => questionRepositoryMock.updateSingle(input))
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await useCase.execute(input);

        expect(result.isOk, isTrue);
        expect(result.ok, unit);
      },
    );
  });
}

class _QuestionRepositoryMock extends Mock implements QuestionRepository {}

class _FakeQuestion extends Fake with EquatableMixin implements Question {
  factory _FakeQuestion.id(String id) => _FakeQuestion._(id: id);

  _FakeQuestion._({required this.id});

  @override
  final String id;

  @override
  List<Object> get props => [id];
}
