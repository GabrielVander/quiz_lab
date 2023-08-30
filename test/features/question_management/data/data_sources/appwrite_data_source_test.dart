import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_realtime_message_model.dart';

void main() {
  late Realtime appwriteRealtimeServiceMock;

  late AppwriteDataSource dataSource;

  setUp(() {
    appwriteRealtimeServiceMock = _RealtimeMock();

    dataSource = AppwriteDataSource(
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
                  databaseId: '',
                  collectionId: '',
                  createdAt: '',
                  updatedAt: '',
                  profile: '',
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
                  '_profile': '7XRx',
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
                  databaseId: 'Cxc#Y1Cj',
                  collectionId: 'h^NjK84I',
                  createdAt: '516',
                  updatedAt: 'D3y^k#Hw',
                  profile: '7XRx',
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
}

class _RealtimeMock extends mocktail.Mock implements Realtime {}

class _RealtimeSubscriptionMock extends mocktail.Mock implements RealtimeSubscription {}
