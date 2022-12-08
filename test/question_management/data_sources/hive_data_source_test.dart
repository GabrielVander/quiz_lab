import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/question_model.dart';

void main() {
  late Box<String> questionsBox;
  late HiveDataSource dataSource;

  setUp(() {
    questionsBox = _HiveBoxMock();
    dataSource = HiveDataSource(questionsBox: questionsBox);
  });

  tearDown(mocktail.resetMocktailState);

  group('saveQuestion', () {
    group('should return success', () {
      for (final testCase in <List<dynamic>>[
        [
          const HiveQuestionModel(
            id: '#y0C^5W*',
            shortDescription: '',
            description: '',
            difficulty: '',
            categories: [],
          ),
          '{'
              '"shortDescription":"",'
              '"description":"",'
              '"difficulty":"",'
              '"categories":[]'
              '}',
        ],
        [
          const HiveQuestionModel(
            id: '@!5qIE',
            shortDescription: 'ezVdUXg',
            description: '*4h3B6',
            difficulty: '5a#3*xeB',
            categories: ['f09@q', 'f0C*^6', r'^$Wj3he'],
          ),
          '{'
              '"shortDescription":"ezVdUXg",'
              '"description":"*4h3B6",'
              '"difficulty":"5a#3*xeB",'
              r'"categories":["f09@q","f0C*^6","^$Wj3he"]'
              '}',
        ],
      ]) {
        final question = testCase[0] as HiveQuestionModel;
        final expectedJson = testCase[1] as String;

        test(question, () async {
          expect(question.id, isNotNull);

          mocktail
              .when(
                () => questionsBox.put(
                  mocktail.any<String>(),
                  mocktail.any<String>(),
                ),
              )
              .thenAnswer((_) async {});

          final result = await dataSource.saveQuestion(question);

          expect(result.isOk, isTrue);
          mocktail
              .verify(() => questionsBox.put(question.id, expectedJson))
              .called(1);
        });
      }
    });

    group('should return LibraryFailure if HiveError occurs', () {
      for (final testCase in <List<dynamic>>[
        [
          HiveError(''),
          '',
        ],
        [
          HiveError('1b@'),
          '1b@',
        ],
      ]) {
        final hiveError = testCase[0] as HiveError;
        final expectedFailureMessage = testCase[1] as String;

        test(hiveError, () async {
          mocktail
              .when(
                () => questionsBox.put(
                  mocktail.any<String>(),
                  mocktail.any<String>(),
                ),
              )
              .thenThrow(hiveError);

          final result = await dataSource.saveQuestion(
            const HiveQuestionModel(
              id: 'id',
              shortDescription: 'shortDescription',
              description: 'description',
              difficulty: 'difficulty',
              categories: [],
            ),
          );

          expect(result.isErr, isTrue);

          final failure = result.expectErr('Expected error')
              as HiveDataSourceLibraryFailure;
          expect(failure.message, equals(expectedFailureMessage));
        });
      }
    });

    group('should return InvalidKeyFailure if invalid id is given', () {
      for (final testCase in <List<dynamic>>[
        [
          const HiveQuestionModel(
            id: '',
            shortDescription: 'shortDescription',
            description: 'description',
            difficulty: 'difficulty',
            categories: [],
          ),
          'Empty id is not allowed',
        ],
        [
          const HiveQuestionModel(
            id: null,
            shortDescription: '*ryCy#cc',
            description: 'Opt6ghyA',
            difficulty: '!2&P!^',
            categories: ['#NiQ%*', '1@', '2@'],
          ),
          'Empty id is not allowed',
        ],
      ]) {
        final question = testCase[0] as HiveQuestionModel;
        final expectedFailureMessage = testCase[1] as String;

        test(expectedFailureMessage, () async {
          final result = await dataSource.saveQuestion(question);

          expect(result.isErr, isTrue);

          final failure = result.expectErr('Expected error')
              as HiveDataSourceInvalidIdFailure;
          expect(failure.message, equals(expectedFailureMessage));
        });
      }
    });
  });

  group('deleteQuestion', () {
    group('should return InvalidKeyFailure if invalid id is given', () {
      for (final question in <HiveQuestionModel>[
        const HiveQuestionModel(
          id: '',
          shortDescription: 'shortDescription',
          description: 'description',
          difficulty: 'difficulty',
          categories: [],
        ),
        const HiveQuestionModel(
          id: null,
          shortDescription: '*ryCy#cc',
          description: 'Opt6ghyA',
          difficulty: '!2&P!^',
          categories: ['#NiQ%*', '1@', '2@'],
        ),
      ]) {
        const expectedFailureMessage = 'Empty id is not allowed';

        test(expectedFailureMessage, () async {
          final result = await dataSource.deleteQuestion(question);

          expect(result.isErr, isTrue);

          final failure = result.expectErr('Expected error')
              as HiveDataSourceInvalidIdFailure;
          expect(failure.message, equals(expectedFailureMessage));
        });
      }
    });

    group('should return LibraryFailure if HiveError occurs', () {
      for (final testCase in <List<dynamic>>[
        [
          HiveError(''),
          '',
        ],
        [
          HiveError('1b@'),
          '1b@',
        ],
      ]) {
        final hiveError = testCase[0] as HiveError;
        final expectedFailureMessage = testCase[1] as String;

        test(hiveError, () async {
          mocktail
              .when(
                () => questionsBox.delete(
                  mocktail.any<String>(),
                ),
              )
              .thenThrow(hiveError);

          final result = await dataSource.deleteQuestion(
            const HiveQuestionModel(
              id: 'id',
              shortDescription: 'shortDescription',
              description: 'description',
              difficulty: 'difficulty',
              categories: [],
            ),
          );

          expect(result.isErr, isTrue);

          final failure = result.err!;
          expect(failure, isA<HiveDataSourceLibraryFailure>());

          expect(
            (failure as HiveDataSourceLibraryFailure).message,
            equals(expectedFailureMessage),
          );
        });
      }
    });

    group(
      'should return success',
      () {
        for (final expectedId in <String>[
          '#y0C^5W*',
          '@!5qIE',
        ]) {
          test(expectedId, () async {
            expect(expectedId, isNotNull);
            expect(expectedId, isNotEmpty);

            final dummyQuestion = _QuestionModelMock(id: expectedId);

            mocktail
                .when(
                  () => questionsBox.delete(mocktail.any<String>()),
                )
                .thenAnswer((_) async {});

            final result = await dataSource.deleteQuestion(dummyQuestion);

            expect(result.isOk, isTrue);
            mocktail.verify(() => questionsBox.delete(expectedId)).called(1);
          });
        }
      },
    );
  });

  group('getAllQuestions', () {
    group('should return LibraryFailure if HiveError occurs', () {
      for (final testCase in <List<dynamic>>[
        [
          HiveError(''),
          '',
        ],
        [
          HiveError('1b@'),
          '1b@',
        ],
      ]) {
        final hiveError = testCase[0] as HiveError;
        final expectedFailureMessage = testCase[1] as String;

        test(hiveError, () async {
          mocktail
              .when(
                () => questionsBox.watch(),
              )
              .thenThrow(hiveError);

          final result = await dataSource.watchAllQuestions();

          expect(result.isErr, isTrue);

          final failure = result.err!;
          expect(failure, isA<HiveDataSourceLibraryFailure>());

          expect(
            failure.message,
            equals(expectedFailureMessage),
          );
        });
      }
    });

    group(
      'should return expected questions',
      () {
        for (final testCase in <List<dynamic>>[
          [
            <BoxEvent>[],
            <HiveQuestionModel>[],
          ],
          [
            <BoxEvent>[
              BoxEvent('someDeletedKey', null, true),
              BoxEvent('someOtherDeletedKey', null, true),
              BoxEvent('evenAnotherDeletedKey', null, true),
            ],
            <HiveQuestionModel>[],
          ],
          [
            <BoxEvent>[
              BoxEvent(
                'someKey',
                '{'
                    '"shortDescription":"",'
                    '"description":"",'
                    '"difficulty":"",'
                    '"categories":[]'
                    '}',
                false,
              ),
              BoxEvent('someDeletedKey', null, true),
              BoxEvent(
                'anotherKey',
                '{'
                    '"shortDescription":"F40jWP%",'
                    '"description":"#y5shHtX",'
                    '"difficulty":"ry@@E",'
                    '"categories":["%84!#y","uhx%x","15#"]'
                    '}',
                false,
              ),
            ],
            <HiveQuestionModel>[
              const HiveQuestionModel(
                id: 'someKey',
                shortDescription: '',
                description: '',
                difficulty: '',
                categories: [],
              ),
              const HiveQuestionModel(
                id: 'anotherKey',
                shortDescription: 'F40jWP%',
                description: '#y5shHtX',
                difficulty: 'ry@@E',
                categories: ['%84!#y', 'uhx%x', '15#'],
              )
            ],
          ],
        ]) {
          test(testCase, () async {
            final boxEvents = testCase[0] as List<BoxEvent>;
            final expectedQuestions = testCase[1] as List<HiveQuestionModel>;

            mocktail
                .when(
                  () => questionsBox.watch(),
                )
                .thenAnswer((_) => Stream.fromIterable(boxEvents));

            final result = await dataSource.watchAllQuestions();

            expect(result.isOk, isTrue);
            expect(await result.ok!.toList(), equals(expectedQuestions));
          });
        }
      },
    );
  });
}

class _HiveBoxMock extends mocktail.Mock implements Box<String> {}

class _QuestionModelMock extends mocktail.Mock implements HiveQuestionModel {
  _QuestionModelMock({
    required this.id,
  });

  @override
  final String id;

  @override
  final String shortDescription = r'#U$*Z';

  @override
  final String description = '#k0hi';

  @override
  final String difficulty = 'Tbp';

  @override
  final List<String> categories = [
    '1@',
    '2@',
    '3@',
  ];
}
