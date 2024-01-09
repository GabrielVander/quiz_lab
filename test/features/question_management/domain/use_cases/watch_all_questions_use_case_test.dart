import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

void main() {
  late QuestionRepository questionRepositoryMock;
  late WatchAllQuestionsUseCase useCase;

  setUp(() {
    questionRepositoryMock = _QuestionRepositoryMock();
    useCase = WatchAllQuestionsUseCase(
      questionRepository: questionRepositoryMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('err flow', () {
    group(
      'question repository fails',
      () {
        for (final values in [
          ['', WatchAllQuestionsFailure.generic(message: '')],
          ['f9T', WatchAllQuestionsFailure.generic(message: 'f9T')],
        ]) {
          test(values.toString(), () async {
            final repositoryFailure = values[0] as String;
            final expectedFailure = values[1] as WatchAllQuestionsFailure;

            mocktail.when(questionRepositoryMock.watchAll).thenAnswer((_) async => Err(repositoryFailure));

            final result = await useCase.execute();

            expect(result.isErr, true);
            expect(result.unwrapErr(), expectedFailure);
          });
        }
      },
    );
  });

  group('ok flow', () {
    group(
      'Use case should return stream from repository',
      () {
        for (final streamValues in [
          <List<Question>>[],
          [
            [
              const Question(
                id: QuestionId('15e194a8-8fa9-4b04-af8f-8d71491ac7e8'),
                shortDescription: 'shortDescription',
                description: 'description',
                answerOptions: [],
                difficulty: QuestionDifficulty.hard,
                categories: [],
              ),
            ]
          ],
          [
            [
              const Question(
                id: QuestionId('15e194a8-8fa9-4b04-af8f-8d71491ac7e8'),
                shortDescription: 'shortDescription',
                description: 'description',
                answerOptions: [],
                difficulty: QuestionDifficulty.hard,
                categories: [],
              ),
              const Question(
                id: QuestionId('56d6a3c9-ebd5-4572-9c86-da328b986927'),
                shortDescription: 'shortDescription',
                description: 'description',
                answerOptions: [],
                difficulty: QuestionDifficulty.hard,
                categories: [],
              ),
              const Question(
                id: QuestionId('d377713b-dfb7-4c22-88a4-3f6d340285dc'),
                shortDescription: 'shortDescription',
                description: 'description',
                answerOptions: [],
                difficulty: QuestionDifficulty.hard,
                categories: [],
              ),
            ]
          ],
        ]) {
          test(streamValues.toString(), () async {
            final stream = Stream.fromIterable(streamValues);

            mocktail.when(questionRepositoryMock.watchAll).thenAnswer((_) async => Ok(stream));

            final result = await useCase.execute();

            expect(result.isOk, isTrue);

            final actualStream = result.unwrap();
            unawaited(expectLater(actualStream, emitsInOrder(streamValues)));
          });
        }
      },
    );
  });
}

class _QuestionRepositoryMock extends mocktail.Mock implements QuestionRepository {}
