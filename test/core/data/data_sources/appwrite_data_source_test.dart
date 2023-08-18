import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_realtime_message_model.dart';

void main() {
  late Databases appwriteDatabasesServiceMock;
  late Realtime appwriteRealtimeServiceMock;

  late AppwriteDataSource dataSource;

  setUp(() {
    appwriteDatabasesServiceMock = _DatabasesMock();
    appwriteRealtimeServiceMock = _RealtimeMock();

    dataSource = AppwriteDataSource(
      appwriteDatabasesService: appwriteDatabasesServiceMock,
      appwriteRealtimeService: appwriteRealtimeServiceMock,
      configuration: const AppwriteReferencesConfig(
        databaseId: 'F4G9rL^G',
        questionsCollectionId: '8bD3Xy',
      ),
    );
  });

  group('watchForQuestionCollectionUpdate()', () {
    group('err', () {});

    group('ok', () {
      group(
        'should subscribe to realtime service correctly',
        () {
          for (final refConfig in [
            const AppwriteReferencesConfig(
              databaseId: '',
              questionsCollectionId: '',
            ),
            const AppwriteReferencesConfig(
              databaseId: 'JeGDX7',
              questionsCollectionId: 'fm6!',
            ),
          ]) {
            test(refConfig.toString(), () async {
              final realtimeSubscriptionMock = _RealtimeSubscriptionMock();

              final dummyAppwriteDataSource = AppwriteDataSource(
                appwriteDatabasesService: appwriteDatabasesServiceMock,
                configuration: refConfig,
                appwriteRealtimeService: appwriteRealtimeServiceMock,
              );

              mocktail.when(() => realtimeSubscriptionMock.stream).thenAnswer((_) => const Stream.empty());

              mocktail
                  .when(
                    () => appwriteRealtimeServiceMock.subscribe(mocktail.any()),
                  )
                  .thenReturn(realtimeSubscriptionMock);

              dummyAppwriteDataSource.watchForQuestionCollectionUpdate();

              mocktail.verify(
                () => appwriteRealtimeServiceMock.subscribe([
                  'databases'
                      '.${refConfig.databaseId}'
                      '.collections'
                      // ignore: lines_longer_than_80_chars
                      '.${refConfig.questionsCollectionId}'
                      '.documents'
                ]),
              );
            });
          }
        },
      );

      group(
        '',
        () {
          for (final values in [
            [
              RealtimeMessage(
                events: [],
                payload: {
                  r'$id': '',
                  'title': '',
                  'options': jsonEncode([]),
                  'difficulty': '',
                  'description': '',
                  'categories': <dynamic>[],
                  r'$permissions': <dynamic>[],
                  r'$databaseId': '',
                  r'$collectionId': '',
                  r'$createdAt': '',
                  r'$updatedAt': '',
                },
                channels: [],
                timestamp: '',
              ),
              const AppwriteRealtimeQuestionMessageModel(
                events: [],
                channels: [],
                timestamp: '',
                payload: AppwriteQuestionModel(
                  id: '',
                  title: '',
                  options: [],
                  difficulty: '',
                  description: '',
                  categories: [],
                  permissions: [],
                  databaseId: '',
                  collectionId: '',
                  createdAt: '',
                  updatedAt: '',
                ),
              ),
            ],
            [
              RealtimeMessage(
                events: ['&Bp54', r'C*F$!Ah', '*8pg^4'],
                payload: {
                  r'$id': 'k2Kao43',
                  'title': 'v5l!@',
                  'options': jsonEncode([
                    {
                      'description': '7T5Tm0p',
                      'isCorrect': false,
                    },
                    {
                      'description': '!D@g3',
                      'isCorrect': true,
                    },
                    {
                      'description': 'V%#BGZ',
                      'isCorrect': false,
                    },
                  ]),
                  'difficulty': 'Tw&N9dD',
                  'description': 'JLzh',
                  'categories': ['p4lM', r'#2$vxpA', 'cWnH2io'],
                  r'$permissions': ['sqG', r'Ft3a7I$v', 'KCfj'],
                  r'$databaseId': 'Cxc#Y1Cj',
                  r'$collectionId': 'h^NjK84I',
                  r'$createdAt': '516',
                  r'$updatedAt': 'D3y^k#Hw',
                },
                channels: ['NR1', '^o58IQ5', 'No854Z0N'],
                timestamp: '29O%1',
              ),
              const AppwriteRealtimeQuestionMessageModel(
                events: ['&Bp54', r'C*F$!Ah', '*8pg^4'],
                channels: ['NR1', '^o58IQ5', 'No854Z0N'],
                timestamp: '29O%1',
                payload: AppwriteQuestionModel(
                  id: 'k2Kao43',
                  title: 'v5l!@',
                  options: [
                    AppwriteQuestionOptionModel(
                      description: '7T5Tm0p',
                      isCorrect: false,
                    ),
                    AppwriteQuestionOptionModel(
                      description: '!D@g3',
                      isCorrect: true,
                    ),
                    AppwriteQuestionOptionModel(
                      description: 'V%#BGZ',
                      isCorrect: false,
                    ),
                  ],
                  difficulty: 'Tw&N9dD',
                  description: 'JLzh',
                  categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
                  permissions: ['sqG', r'Ft3a7I$v', 'KCfj'],
                  databaseId: 'Cxc#Y1Cj',
                  collectionId: 'h^NjK84I',
                  createdAt: '516',
                  updatedAt: 'D3y^k#Hw',
                ),
              ),
            ],
          ]) {
            test(values.toString(), () {
              final dummyRealtimeMessage = values[0] as RealtimeMessage;
              final expectedAppwriteRealtimeQuestionMessageModel = values[1] as AppwriteRealtimeQuestionMessageModel;

              final realtimeSubscriptionMock = _RealtimeSubscriptionMock();

              mocktail
                  .when(() => realtimeSubscriptionMock.stream)
                  .thenAnswer((_) => Stream.value(dummyRealtimeMessage));

              mocktail
                  .when(
                    () => appwriteRealtimeServiceMock.subscribe(mocktail.any()),
                  )
                  .thenReturn(realtimeSubscriptionMock);

              final result = dataSource.watchForQuestionCollectionUpdate();

              expect(
                result,
                emits(expectedAppwriteRealtimeQuestionMessageModel),
              );
            });
          }
        },
      );
    });
  });

  group('getAllQuestions()', () {
    group('ok', () {
      group(
        'should call databases service correctly',
        () {
          for (final refConfig in [
            const AppwriteReferencesConfig(
              databaseId: '',
              questionsCollectionId: '',
            ),
            const AppwriteReferencesConfig(
              databaseId: 'wQD67',
              questionsCollectionId: r'$aDf',
            ),
          ]) {
            test(refConfig.toString(), () async {
              final documentListMock = _DocumentListMock();

              mocktail.when(() => documentListMock.total).thenReturn(0);
              mocktail.when(() => documentListMock.documents).thenReturn([]);

              mocktail
                  .when(
                    () => appwriteDatabasesServiceMock.listDocuments(
                      databaseId: mocktail.any(named: 'databaseId'),
                      collectionId: mocktail.any(named: 'collectionId'),
                    ),
                  )
                  .thenAnswer((_) async => documentListMock);

              await AppwriteDataSource(
                appwriteDatabasesService: appwriteDatabasesServiceMock,
                configuration: refConfig,
                appwriteRealtimeService: appwriteRealtimeServiceMock,
              ).getAllQuestions();

              mocktail.verify(
                () => appwriteDatabasesServiceMock.listDocuments(
                  databaseId: refConfig.databaseId,
                  collectionId: refConfig.questionsCollectionId,
                ),
              );
            });
          }
        },
      );

      group(
        'should return expected',
        () {
          for (final values in [
            [
              DocumentList(
                total: 0,
                documents: [],
              ),
              const AppwriteQuestionListModel(
                total: 0,
                questions: <AppwriteQuestionModel>[],
              ),
            ],
            [
              DocumentList(
                total: 1,
                documents: [
                  Document(
                    $id: 'k2Kao43',
                    $collectionId: 'h^NjK84I',
                    $databaseId: 'Cxc#Y1Cj',
                    $createdAt: '516',
                    $updatedAt: 'D3y^k#Hw',
                    $permissions: ['sqG', r'Ft3a7I$v', 'KCfj'],
                    data: {
                      'title': 'v5l!@',
                      'options': '['
                          '{"description":"7T5Tm0p","isCorrect":false},'
                          '{"description":"!D@g3","isCorrect":true},'
                          '{"description":"V%#BGZ","isCorrect":false}'
                          ']',
                      'difficulty': 'Tw&N9dD',
                      'description': 'JLzh',
                      'categories': ['p4lM', r'#2$vxpA', 'cWnH2io'],
                    },
                  ),
                ],
              ),
              const AppwriteQuestionListModel(
                total: 1,
                questions: [
                  AppwriteQuestionModel(
                    id: 'k2Kao43',
                    title: 'v5l!@',
                    options: [
                      AppwriteQuestionOptionModel(
                        description: '7T5Tm0p',
                        isCorrect: false,
                      ),
                      AppwriteQuestionOptionModel(
                        description: '!D@g3',
                        isCorrect: true,
                      ),
                      AppwriteQuestionOptionModel(
                        description: 'V%#BGZ',
                        isCorrect: false,
                      ),
                    ],
                    difficulty: 'Tw&N9dD',
                    description: 'JLzh',
                    categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
                    permissions: ['sqG', r'Ft3a7I$v', 'KCfj'],
                    databaseId: 'Cxc#Y1Cj',
                    collectionId: 'h^NjK84I',
                    createdAt: '516',
                    updatedAt: 'D3y^k#Hw',
                  ),
                ],
              ),
            ],
          ]) {
            test(values.toString(), () async {
              final dummyDocumentList = values[0] as DocumentList;
              final expectedAppwriteQuestionListModel = values[1] as AppwriteQuestionListModel;

              mocktail
                  .when(
                    () => appwriteDatabasesServiceMock.listDocuments(
                      databaseId: mocktail.any(named: 'databaseId'),
                      collectionId: mocktail.any(named: 'collectionId'),
                    ),
                  )
                  .thenAnswer((_) async => dummyDocumentList);

              final result = await dataSource.getAllQuestions();

              expect(result, expectedAppwriteQuestionListModel);
            });
          }
        },
      );
    });
  });
}

class _DatabasesMock extends mocktail.Mock implements Databases {}

class _RealtimeMock extends mocktail.Mock implements Realtime {}

class _RealtimeSubscriptionMock extends mocktail.Mock implements RealtimeSubscription {}

class _DocumentListMock extends mocktail.Mock implements DocumentList {}
