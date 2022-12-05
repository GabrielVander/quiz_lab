import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
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
    group('should return success when saving question', () {
      for (final testCase in <List<dynamic>>[
        [
          const QuestionModel(
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
          const QuestionModel(
            id: '@!5qIE',
            shortDescription: 'Sausages combines greatly with quartered eggs?',
            description: 'Stutter calmly like a stormy rum.',
            difficulty: '5a#3*xeB',
            categories: ['homework', 'asleep', 'native'],
          ),
          '{'
              '"shortDescription":"Sausages combines greatly with quartered '
              'eggs?",'
              '"description":"Stutter calmly like a stormy rum.",'
              '"difficulty":"5a#3*xeB",'
              '"categories":["homework","asleep","native"]'
              '}',
        ],
      ]) {
        final question = testCase[0] as QuestionModel;
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

    group('should return HiveDataSourceHiveFailure if HiveError occurs', () {
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
            const QuestionModel(
              id: 'id',
              shortDescription: 'shortDescription',
              description: 'description',
              difficulty: 'difficulty',
              categories: [],
            ),
          );

          expect(result.isErr, isTrue);

          final failure =
              result.expectErr('Expected error') as HiveDataSourceHiveFailure;
          expect(failure.message, equals(expectedFailureMessage));
        });
      }
    });

    group(
        'should return HiveDataSourceInvalidKeyFailure if invalid id is given',
        () {
      for (final testCase in <List<dynamic>>[
        [
          const QuestionModel(
            id: '',
            shortDescription: 'shortDescription',
            description: 'description',
            difficulty: 'difficulty',
            categories: [],
          ),
          'Empty id is not allowed',
        ],
        [
          const QuestionModel(
            id: null,
            shortDescription: '*ryCy#cc',
            description: 'Opt6ghyA',
            difficulty: '!2&P!^',
            categories: ['#NiQ%*', '1@', '2@'],
          ),
          'Empty id is not allowed',
        ],
      ]) {
        final question = testCase[0] as QuestionModel;
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
}

class _HiveBoxMock extends mocktail.Mock implements Box<String> {}
