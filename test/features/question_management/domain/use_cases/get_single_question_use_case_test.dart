import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late GetSingleQuestionUseCase useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    useCase =
        GetSingleQuestionUseCase(questionRepository: questionRepositoryMock);
  });

  group('err flow', () {
    parameterizedTest(
      'should return repository error message',
      ParameterizedSource.values([
        [
          QuestionRepositoryFailure.unableToWatchAll(message: ''),
          '',
        ],
        [
          QuestionRepositoryFailure.unableToWatchAll(message: 'rL4Rv%KV'),
          'rL4Rv%KV',
        ],
      ]),
      (values) async {
        final questionRepositoryFailure =
            values[0] as QuestionRepositoryFailure;
        final expected = values[1] as String;

        mocktail
            .when(() => questionRepositoryMock.watchAll())
            .thenAnswer((_) => Result.err(questionRepositoryFailure));

        final result = await useCase.execute('5iPj@0V');

        expect(result.isErr, true);
        expect(result.err, expected);
      },
    );

    test('should return question not found message for null id', () async {
      final result = await useCase.execute(null);

      expect(result.isErr, true);
      expect(result.err, 'Unable to find question');
    });

    parameterizedTest(
      'should return question not found message',
      ParameterizedSource.value([
        const Stream<List<Question>>.empty(),
        Stream<List<Question>>.fromIterable([
          [
            _FakeQuestion(),
            _FakeQuestion(),
            _FakeQuestion(),
          ],
        ]),
      ]),
      (values) async {
        final questionsStream = values[0] as Stream<List<Question>>;

        mocktail
            .when(() => questionRepositoryMock.watchAll())
            .thenAnswer((_) => Result.ok(questionsStream));

        final result = await useCase.execute('6EyuF!KL');

        expect(result.isErr, true);
        expect(result.err, 'Unable to find question');
      },
    );
  });

  group('ok flow', () {
    const targetQuestionId = 'n201';

    parameterizedTest(
      'should return question',
      ParameterizedSource.value([
        Stream<List<Question>>.value(
          [_FakeTargetQuestion(targetQuestionId: targetQuestionId)],
        ),
        Stream<List<Question>>.fromIterable([
          [
            _FakeTargetQuestion(targetQuestionId: targetQuestionId),
            _FakeQuestion(),
            _FakeQuestion(),
          ],
        ]),
        Stream<List<Question>>.fromIterable([
          [
            _FakeQuestion(),
            _FakeTargetQuestion(targetQuestionId: targetQuestionId),
            _FakeQuestion(),
          ],
        ]),
        Stream<List<Question>>.fromIterable([
          [
            _FakeQuestion(),
            _FakeQuestion(),
            _FakeTargetQuestion(targetQuestionId: targetQuestionId),
          ],
        ]),
      ]),
      (values) async {
        final questionsStream = values[0] as Stream<List<Question>>;

        mocktail
            .when(() => questionRepositoryMock.watchAll())
            .thenAnswer((_) => Result.ok(questionsStream));

        final result = await useCase.execute(targetQuestionId);

        expect(result.isOk, true);
        expect(
          result.ok,
          _FakeTargetQuestion(targetQuestionId: targetQuestionId),
        );
      },
    );
  });
}

class _QuestionRepositoryMock extends mocktail.Mock
    implements QuestionRepository {}

class _FakeQuestion extends mocktail.Fake implements Question {
  @override
  String get id => 'Q4Rj35I';
}

class _FakeTargetQuestion extends mocktail.Fake
    with EquatableMixin
    implements Question {
  _FakeTargetQuestion({required this.targetQuestionId});

  final String targetQuestionId;

  @override
  String get id => targetQuestionId;

  @override
  List<Object?> get props => [id];
}
