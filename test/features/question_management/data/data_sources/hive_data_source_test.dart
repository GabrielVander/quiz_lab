import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/json_parser.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';

void main() {
  late Box<String> mockQuestionsBox;
  late JsonParser<Map<String, dynamic>> mockJsonParser;
  late HiveDataSource dataSource;

  setUp(() {
    mockQuestionsBox = _MockHiveBox();
    mockJsonParser = _MockJsonParser();
    dataSource = HiveDataSource(
      questionsBox: mockQuestionsBox,
      jsonParser: mockJsonParser,
    );
  });

  tearDown(resetMocktailState);

  group('saveQuestion', () {
    group(
      'err flow',
      () {
        group(
          'should return failure when json encoding fails',
          () {
            for (final values in [
              [
                EncodeFailure.exception(message: ''),
                HiveDataSourceFailure.jsonEncoding(
                  message: 'Unable to encode: ',
                ),
              ],
              [
                EncodeFailure.exception(message: 'Hu%C%!8'),
                HiveDataSourceFailure.jsonEncoding(
                  message: 'Unable to encode: Hu%C%!8',
                ),
              ],
            ]) {
              test(values.toString(), () async {
                final parserFailure = values[0] as EncodeFailure;
                final expectedFailure = values[1] as HiveDataSourceFailure;

                when(() => mockJsonParser.encode(any())).thenReturn(Err(parserFailure));

                final result = await dataSource.saveQuestion(_FakeHiveQuestionModel());

                expect(result.isErr, isTrue);
                expect(result.unwrapErr(), expectedFailure);
              });
            }
          },
        );

        group(
          'should return failure if invalid id is given',
          () {
            for (final values in [
              [
                const HiveQuestionModel(
                  id: '',
                  shortDescription: null,
                  description: null,
                  difficulty: null,
                  options: null,
                  categories: null,
                ),
                HiveDataSourceFailure.emptyId(),
              ],
              [
                const HiveQuestionModel(
                  id: null,
                  shortDescription: null,
                  description: null,
                  difficulty: null,
                  options: null,
                  categories: null,
                ),
                HiveDataSourceFailure.emptyId(),
              ],
            ]) {
              test(values.toString(), () async {
                final question = values[0] as HiveQuestionModel;
                final expectedFailure = values[1] as HiveDataSourceFailure;

                final result = await dataSource.saveQuestion(question);

                expect(result.isErr, isTrue);

                expect(result.unwrapErr(), expectedFailure);
              });
            }
          },
        );

        group(
          'should return expected failure if HiveError occurs',
          () {
            for (final values in [
              [
                HiveError(''),
                HiveDataSourceFailure.hiveError(message: ''),
              ],
              [
                HiveError('1b@'),
                HiveDataSourceFailure.hiveError(message: '1b@'),
              ],
            ]) {
              test(values.toString(), () async {
                final hiveError = values[0] as HiveError;
                final expectedFailure = values[1] as HiveDataSourceFailure;

                const dummyEncodedJsonString = 'X1Tt';
                final fakeModel = _FakeHiveQuestionModel();

                when(() => mockJsonParser.encode(any())).thenReturn(const Ok(dummyEncodedJsonString));

                when(
                  () => mockQuestionsBox.put(
                    fakeModel.id,
                    dummyEncodedJsonString,
                  ),
                ).thenThrow(hiveError);

                final result = await dataSource.saveQuestion(fakeModel);

                expect(result.isErr, isTrue);
                expect(result.unwrapErr(), expectedFailure);
              });
            }
          },
        );
      },
    );

    group(
      'ok flow',
      () {
        group(
          'should return success',
          () {
            for (final model in [
              const HiveQuestionModel(
                id: '#y0C^5W*',
                shortDescription: '',
                description: '',
                difficulty: '',
                categories: [],
                options: [],
              ),
              const HiveQuestionModel(
                id: '@!5qIE',
                shortDescription: 'ezVdUXg',
                description: '*4h3B6',
                difficulty: '5a#3*xeB',
                categories: ['f09@q', 'f0C*^6', r'^$Wj3he'],
                options: [
                  {'description': 'Px#5Mh', 'isCorrect': false},
                  {'description': 'x#5Mh', 'isCorrect': true},
                ],
              ),
            ]) {
              test(model.toString(), () async {
                const dummyJsonEncodedString = 'Qld';

                expect(model.id, isNotNull);
                expect(model.id, isNotEmpty);

                when(() => mockJsonParser.encode(model.toMap())).thenReturn(const Ok(dummyJsonEncodedString));

                when(
                  () => mockQuestionsBox.put(model.id, dummyJsonEncodedString),
                ).thenAnswer((_) async {});

                final result = await dataSource.saveQuestion(model);

                expect(result.isOk, isTrue);
                verify(
                  () => mockQuestionsBox.put(model.id, dummyJsonEncodedString),
                ).called(1);
              });
            }
          },
        );
      },
    );
  });

  group('deleteQuestion', () {
    group('err flow', () {
      group(
        'should return failure if empty id is given',
        () {
          for (final model in [
            const HiveQuestionModel(
              id: '',
              shortDescription: null,
              description: null,
              difficulty: null,
              categories: null,
              options: null,
            ),
            const HiveQuestionModel(
              id: null,
              shortDescription: null,
              description: null,
              difficulty: null,
              categories: null,
              options: null,
            ),
          ]) {
            test(model.toString(), () async {
              when(() => mockQuestionsBox.delete(model.id)).thenAnswer((_) async {});

              final result = await dataSource.deleteQuestion(model);

              expect(result.isErr, isTrue);
              expect(result.unwrapErr(), HiveDataSourceFailure.emptyId());
            });
          }
        },
      );

      group(
        'should return failure if HiveError occurs',
        () {
          for (final values in [
            [
              HiveError(''),
              HiveDataSourceFailure.hiveError(message: ''),
            ],
            [
              HiveError('@bD8KAz'),
              HiveDataSourceFailure.hiveError(message: '@bD8KAz'),
            ],
          ]) {
            test(values.toString(), () async {
              final hiveError = values[0] as HiveError;
              final expectedFailure = values[1] as HiveDataSourceFailure;

              final fakeModel = _FakeHiveQuestionModel();

              when(() => mockQuestionsBox.delete(fakeModel.id)).thenThrow(hiveError);

              final result = await dataSource.deleteQuestion(fakeModel);

              expect(result.isErr, isTrue);
              expect(result.unwrapErr(), expectedFailure);
            });
          }
        },
      );
    });

    group('ok flow', () {
      group(
        'should return success',
        () {
          for (final id in [
            '#y0C^5W*',
            '@!5qIE',
          ]) {
            test(id, () async {
              expect(id, isNotEmpty);

              final dummyModel = HiveQuestionModel(
                id: id,
                shortDescription: null,
                description: null,
                difficulty: null,
                categories: null,
                options: null,
              );

              when(() => mockQuestionsBox.delete(id)).thenAnswer((_) async {});

              final result = await dataSource.deleteQuestion(dummyModel);

              expect(result.isOk, isTrue);
              verify(() => mockQuestionsBox.delete(id)).called(1);
            });
          }
        },
      );
    });
  });

  group(
    'getAllQuestions',
    () {
      group('err flow', () {
        group('first load failure', () {
          group(
            'should return failure if HiveError occurs when fetching keys on '
            'first load',
            () {
              for (final values in [
                [
                  HiveError(''),
                  HiveDataSourceFailure.hiveError(message: ''),
                ],
                [
                  HiveError('AesqhAfa'),
                  HiveDataSourceFailure.hiveError(message: 'AesqhAfa'),
                ],
              ]) {
                test(values.toString(), () {
                  final hiveError = values[0] as HiveError;
                  final expectedFailure = values[1] as HiveDataSourceFailure;

                  when(() => mockQuestionsBox.keys).thenThrow(hiveError);

                  final result = dataSource.watchAllQuestions();

                  expect(result.isErr, isTrue);
                  expect(result.unwrapErr(), expectedFailure);
                });
              }
            },
          );

          group(
            'should return failure if HiveError occurs when fetching value on '
            'first load',
            () {
              for (final values in [
                [
                  HiveError(''),
                  HiveDataSourceFailure.hiveError(message: ''),
                ],
                [
                  HiveError('1b@'),
                  HiveDataSourceFailure.hiveError(message: '1b@'),
                ],
              ]) {
                test(values.toString(), () {
                  final hiveError = values[0] as HiveError;
                  final expectedFailure = values[1] as HiveDataSourceFailure;

                  const dummySingleKey = 'mNzd5ew';

                  when(() => mockQuestionsBox.keys).thenReturn([dummySingleKey]);
                  when(() => mockQuestionsBox.get(dummySingleKey)).thenThrow(hiveError);

                  final result = dataSource.watchAllQuestions();

                  expect(result.isErr, isTrue);
                  expect(result.unwrapErr(), expectedFailure);
                });
              }
            },
          );

          group(
            'should return failure if json parsing fails during first load',
            () {
              for (final values in [
                [
                  DecodeFailure.exception(message: ''),
                  HiveDataSourceFailure.jsonDecoding(
                    message: 'Unable to decode: ',
                  ),
                ],
                [
                  DecodeFailure.exception(message: 'kcdd*k6%'),
                  HiveDataSourceFailure.jsonDecoding(
                    message: 'Unable to decode: kcdd*k6%',
                  ),
                ],
              ]) {
                test(values.toString(), () {
                  final decodeFailure = values[0] as DecodeFailure;
                  final expectedFailure = values[1] as HiveDataSourceFailure;

                  const dummySingleKey = 'mNzd5ew';
                  const dummyJsonEncodedString = 'Aq1oZ';

                  when(() => mockQuestionsBox.keys).thenReturn([dummySingleKey]);

                  when(() => mockQuestionsBox.get(dummySingleKey)).thenReturn(dummyJsonEncodedString);

                  when(() => mockJsonParser.decode(dummyJsonEncodedString)).thenReturn(Err(decodeFailure));

                  final result = dataSource.watchAllQuestions();

                  expect(result.isErr, isTrue);
                  expect(result.unwrapErr(), expectedFailure);
                });
              }
            },
          );

          group(
            'should return failure if HiveError occurs when watching box',
            () {
              for (final values in [
                [
                  HiveError(''),
                  HiveDataSourceFailure.hiveError(message: ''),
                ],
                [
                  HiveError('1b@'),
                  HiveDataSourceFailure.hiveError(message: '1b@'),
                ],
              ]) {
                test(values.toString(), () {
                  final hiveError = values[0] as HiveError;
                  final expectedFailure = values[1] as HiveDataSourceFailure;

                  const dummySingleKey = 'mNzd5ew';
                  const dummyJsonEncodedString = 'Aq1oZ';
                  const dummyJsonDecodedMap = <String, dynamic>{};

                  when(() => mockQuestionsBox.keys).thenReturn([dummySingleKey]);

                  when(() => mockJsonParser.decode(dummyJsonEncodedString)).thenReturn(const Ok(dummyJsonDecodedMap));

                  when(() => mockQuestionsBox.get(dummySingleKey)).thenReturn(dummyJsonEncodedString);

                  when(() => mockQuestionsBox.watch()).thenThrow(hiveError);

                  final result = dataSource.watchAllQuestions();

                  expect(result.isErr, isTrue);
                  expect(result.unwrapErr(), expectedFailure);
                });
              }
            },
          );
        });

        group('watch failure', () {
          group(
            'should return failure if HiveError occurs on watch',
            () {
              for (final values in [
                [
                  HiveError(''),
                  HiveDataSourceFailure.hiveError(message: ''),
                ],
                [
                  HiveError('N&mu^s6'),
                  HiveDataSourceFailure.hiveError(message: 'N&mu^s6'),
                ],
              ]) {
                test(values.toString(), () {
                  final hiveError = values[0] as HiveError;
                  final expectedFailure = values[1] as HiveDataSourceFailure;

                  const dummyJsonEncodedString = 'Vhf5PGK';
                  const dummyJsonDecodedMap = <String, dynamic>{};
                  const dummySingleKey = '8TO#8C';

                  when(() => mockQuestionsBox.keys).thenReturn([dummySingleKey]);
                  when(() => mockQuestionsBox.get(dummySingleKey)).thenReturn(dummyJsonEncodedString);
                  when(() => mockJsonParser.decode(dummyJsonEncodedString)).thenReturn(const Ok(dummyJsonDecodedMap));
                  when(() => mockQuestionsBox.watch()).thenThrow(hiveError);

                  final result = dataSource.watchAllQuestions();

                  expect(result.isErr, isTrue);
                  expect(result.unwrapErr(), expectedFailure);
                });
              }
            },
          );
        });
      });

      group('ok flow', () {
        group(
          'should return expected questions',
          () {
            for (final values in [
              [
                <BoxEvent>[
                  BoxEvent('someDeletedKey', null, true),
                  BoxEvent('someOtherDeletedKey', null, true),
                  BoxEvent('evenAnotherDeletedKey', null, true),
                ],
                <List<String>>[[], [], [], []],
                <List<HiveQuestionModel>>[[], [], [], []],
              ],
              [
                <BoxEvent>[
                  BoxEvent('someKey', '59VkA', false),
                  BoxEvent('someDeletedKey', null, true),
                  BoxEvent('anotherKey', '7*oj', false),
                ],
                <List<String>>[
                  [],
                  ['someKey'],
                  ['someKey'],
                  ['someKey', 'anotherKey'],
                ],
                <List<HiveQuestionModel>>[
                  [],
                  [
                    const HiveQuestionModel(
                      id: 'someKey',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                  [
                    const HiveQuestionModel(
                      id: 'someKey',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                  [
                    const HiveQuestionModel(
                      id: 'someKey',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                    const HiveQuestionModel(
                      id: 'anotherKey',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                ],
              ],
              [
                <BoxEvent>[
                  BoxEvent('Rqh9r', 'z0uB', false),
                  BoxEvent(r'$9xvH', null, true),
                  BoxEvent('0Mth40', '7*oj', false),
                ],
                <List<String>>[
                  ['lke46'],
                  ['lke46', 'Rqh9r'],
                  ['lke46', 'Rqh9r'],
                  ['lke46', 'Rqh9r', '0Mth40'],
                ],
                <List<HiveQuestionModel>>[
                  [
                    const HiveQuestionModel(
                      id: 'lke46',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                  [
                    const HiveQuestionModel(
                      id: 'lke46',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                    const HiveQuestionModel(
                      id: 'Rqh9r',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                  [
                    const HiveQuestionModel(
                      id: 'lke46',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                    const HiveQuestionModel(
                      id: 'Rqh9r',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                  [
                    const HiveQuestionModel(
                      id: 'lke46',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                    const HiveQuestionModel(
                      id: 'Rqh9r',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                    const HiveQuestionModel(
                      id: '0Mth40',
                      shortDescription: '',
                      description: '',
                      difficulty: '',
                      categories: [],
                      options: [],
                    ),
                  ],
                ],
              ],
            ]) {
              test(values.toString(), () async {
                final boxEvents = values[0] as List<BoxEvent>;
                final keysToEmit = values[1] as List<List<String>>;
                final expectedEmissions = values[2] as List<List<HiveQuestionModel>>;

                when(() => mockQuestionsBox.keys).thenAnswer((_) {
                  final keys = keysToEmit.removeAt(0);

                  for (final k in keys) {
                    final matchingBoxEvent = boxEvents.firstWhere(
                      (e) => e.key == k,
                      orElse: _FakeBoxEvent.new,
                    );

                    final jsonEncodedString = matchingBoxEvent.value;

                    when(() => mockQuestionsBox.get(k)).thenReturn(jsonEncodedString as String);

                    when(() => mockJsonParser.decode(jsonEncodedString)).thenReturn(const Ok({}));
                  }

                  return keys;
                });

                when(() => mockQuestionsBox.watch()).thenAnswer((_) => Stream.fromIterable(boxEvents));

                final result = dataSource.watchAllQuestions();

                expect(result.isOk, isTrue);

                await expectLater(
                  result.unwrap(),
                  emitsInAnyOrder(expectedEmissions),
                );
              });
            }
          },
        );
      });
    },
  );
}

class _FakeHiveQuestionModel extends Fake implements HiveQuestionModel {
  @override
  final String id = 'oBO5v';

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'shortDescription': 'shortDescription',
        'description': 'description',
        'difficulty': 'difficulty',
        'categories': ['category1', 'category2'],
      };
}

@immutable
class _FakeBoxEvent extends Fake implements BoxEvent {
  @override
  final String value = 'p8Wv';

  @override
  // ignore: hash_and_equals
  bool operator ==(dynamic other) => true;
}

class _MockHiveBox extends Mock implements Box<String> {}

class _MockJsonParser extends Mock implements JsonParser<Map<String, dynamic>> {}
