import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';

void main() {
  late AppwriteWrapper appwriteWrapperMock;
  late QuestionCollectionAppwriteDataSource dataSource;

  final expectedAppwriteErrorMappings = [
    [
      AppwriteWrapperUnexpectedFailure(''),
      QuestionsAppwriteDataSourceUnexpectedFailure(''),
    ],
    [
      AppwriteWrapperUnexpectedFailure(r'$4*'),
      QuestionsAppwriteDataSourceUnexpectedFailure(r'$4*'),
    ],
    [
      AppwriteWrapperServiceFailure(const UnknownAppwriteError()),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError().toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const UnknownAppwriteError(
          type: '',
          message: '',
          code: 0,
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError(
          type: '',
          message: '',
          code: 0,
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const UnknownAppwriteError(
          type: 'FOq',
          message: 'EYzmU%^',
          code: 372,
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError(
          type: 'FOq',
          message: 'EYzmU%^',
          code: 372,
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: '',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: 'L7B%927',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: 'L7B%927',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const DatabaseNotFoundAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DatabaseNotFoundAppwriteError(
          message: '',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const DatabaseNotFoundAppwriteError(
          message: 'm#6',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DatabaseNotFoundAppwriteError(
          message: 'm#6',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const CollectionNotFoundAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const CollectionNotFoundAppwriteError(
          message: '',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const CollectionNotFoundAppwriteError(
          message: r'$A77j0*',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const CollectionNotFoundAppwriteError(
          message: r'$A77j0*',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const DocumentNotFoundAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DocumentNotFoundAppwriteError(
          message: '',
        ).toString(),
      ),
    ],
    [
      AppwriteWrapperServiceFailure(
        const DocumentNotFoundAppwriteError(
          message: 'mMke',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DocumentNotFoundAppwriteError(
          message: 'mMke',
        ).toString(),
      ),
    ],
  ];

  setUp(() {
    appwriteWrapperMock = _AppwriteWrapperMock();
    dataSource = QuestionCollectionAppwriteDataSource(
      config: QuestionsAppwriteDataSourceConfig(
        databaseId: 'G3Q',
        collectionId: 'A9MnFkz',
      ),
      appwriteWrapper: appwriteWrapperMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('createSingle', () {
    group(
      'should call Appwrite wrapper correctly',
      () {
        for (final values in [
          [
            QuestionsAppwriteDataSourceConfig(databaseId: '', collectionId: ''),
            const AppwriteQuestionCreationModel(
              id: '',
              title: '',
              description: '',
              difficulty: '',
              options: [],
              categories: [],
            )
          ],
          [
            QuestionsAppwriteDataSourceConfig(
              databaseId: 'Q!3CTr',
              collectionId: r'^NW8$',
            ),
            const AppwriteQuestionCreationModel(
              id: 'HH%',
              title: '#7d76V',
              description: r'$7zCt%Z@',
              difficulty: 'k4Y0r9p',
              options: [
                AppwriteQuestionOptionModel(
                  description: 'c1jh',
                  isCorrect: true,
                ),
                AppwriteQuestionOptionModel(
                  description: r'Q5&&n9$',
                  isCorrect: false,
                ),
              ],
              categories: [
                't0&',
                'kzBmu',
                'GRNY3!J9',
              ],
            )
          ],
        ]) {
          test(values.toString(), () {
            final config = values[0] as QuestionsAppwriteDataSourceConfig;
            final creationModel = values[1] as AppwriteQuestionCreationModel;

            dataSource.config = config;

            mocktail
                .when(
                  () => appwriteWrapperMock.createDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                    data: mocktail.any(named: 'data'),
                  ),
                )
                .thenAnswer(
                  (_) async =>
                      Result.err(AppwriteWrapperUnexpectedFailure('7S8W')),
                );

            dataSource.createSingle(creationModel);

            mocktail.verify(
              () => appwriteWrapperMock.createDocument(
                databaseId: config.databaseId,
                collectionId: config.collectionId,
                documentId: creationModel.id,
                data: creationModel.toMap(),
              ),
            );
          });
        }
      },
    );

    group(
      'should return expected failure if Appwrite wrapper fails',
      () {
        for (final values in expectedAppwriteErrorMappings) {
          test(values.toString(), () async {
            final wrapperFailure = values[0] as AppwriteWrapperFailure;
            final expectedFailure =
                values[1] as QuestionsAppwriteDataSourceFailure;

            final appwriteQuestionCreationModelMock =
                _AppwriteQuestionCreationModelMock();

            mocktail
                .when(appwriteQuestionCreationModelMock.toMap)
                .thenReturn({});

            mocktail
                .when(() => appwriteQuestionCreationModelMock.id)
                .thenReturn('yNg#');

            mocktail
                .when(
                  () => appwriteWrapperMock.createDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                    data: mocktail.any(named: 'data'),
                  ),
                )
                .thenAnswer((_) async => Result.err(wrapperFailure));

            final result = await dataSource
                .createSingle(appwriteQuestionCreationModelMock);

            expect(result.isErr, true);
            expect(result.err, expectedFailure);
          });
        }
      },
    );

    group(
      'should return expected',
      () {
        for (final values in [
          [
            Document(
              $id: '',
              $collectionId: '',
              $databaseId: '',
              $createdAt: '',
              $updatedAt: '',
              $permissions: [],
              data: {
                'title': '',
                'options': '[]',
                'difficulty': '',
                'description': '',
                'categories': <String>[],
              },
            ),
            const AppwriteQuestionModel(
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
            )
          ],
          [
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
            const AppwriteQuestionModel(
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
            )
          ],
        ]) {
          test(values.toString(), () async {
            final appwriteDocument = values[0] as Document;
            final expectedModel = values[1] as AppwriteQuestionModel;

            final creationModelMock = _AppwriteQuestionCreationModelMock();

            mocktail.when(creationModelMock.toMap).thenReturn({});

            mocktail.when(() => creationModelMock.id).thenReturn('&cY');

            mocktail
                .when(
                  () => appwriteWrapperMock.createDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                    data: mocktail.any(named: 'data'),
                  ),
                )
                .thenAnswer((_) async => Result.ok(appwriteDocument));

            final result = await dataSource.createSingle(creationModelMock);

            expect(result.isOk, true);
            expect(result.ok, expectedModel);
          });
        }
      },
    );
  });

  group('deleteSingle', () {
    group(
      'should call Appwrite wrapper correctly',
      () {
        for (final values in [
          [
            QuestionsAppwriteDataSourceConfig(databaseId: '', collectionId: ''),
            ''
          ],
          [
            QuestionsAppwriteDataSourceConfig(
              databaseId: 'G3Q',
              collectionId: 'A9MnFkz',
            ),
            'dN*p'
          ],
        ]) {
          test(values.toString(), () {
            final config = values[0] as QuestionsAppwriteDataSourceConfig;
            final id = values[1] as String;

            final dataSource = QuestionCollectionAppwriteDataSource(
              config: config,
              appwriteWrapper: appwriteWrapperMock,
            );

            mocktail
                .when(
                  () => appwriteWrapperMock.deleteDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenAnswer(
                  (_) async =>
                      Result.err(AppwriteWrapperUnexpectedFailure('k7^&M')),
                );

            dataSource.deleteSingle(id);

            mocktail.verify(
              () => appwriteWrapperMock.deleteDocument(
                databaseId: config.databaseId,
                collectionId: config.collectionId,
                documentId: id,
              ),
            );
          });
        }
      },
    );

    group(
      'should return expected failure if Appwrite wrapper fails',
      () {
        for (final values in expectedAppwriteErrorMappings) {
          test(values.toString(), () async {
            final wrapperFailure = values[0] as AppwriteWrapperFailure;
            final expectedFailure =
                values[1] as QuestionsAppwriteDataSourceFailure;

            mocktail
                .when(
                  () => appwriteWrapperMock.deleteDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenAnswer((_) async => Result.err(wrapperFailure));

            final result = await dataSource.deleteSingle('*1Kl!M2q');

            expect(result.isErr, true);
            expect(result.err, expectedFailure);
          });
        }
      },
    );

    test(
      'should return nothing if Appwrite wrapper returns nothing',
      () async {
        mocktail
            .when(
              () => appwriteWrapperMock.deleteDocument(
                collectionId: mocktail.any(named: 'collectionId'),
                databaseId: mocktail.any(named: 'databaseId'),
                documentId: mocktail.any(named: 'documentId'),
              ),
            )
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await dataSource.deleteSingle('vJk60VoW');

        expect(result.isOk, true);
        expect(result.ok, unit);
      },
    );
  });

  group('fetchSingle', () {
    group(
      'should call Appwrite wrapper correctly',
      () {
        for (final values in [
          [
            QuestionsAppwriteDataSourceConfig(databaseId: '', collectionId: ''),
            ''
          ],
          [
            QuestionsAppwriteDataSourceConfig(
              databaseId: r'35&Y3$8',
              collectionId: '4F28AYf#',
            ),
            'vX19'
          ],
        ]) {
          test(values.toString(), () {
            final config = values[0] as QuestionsAppwriteDataSourceConfig;
            final id = values[1] as String;

            final dataSource = QuestionCollectionAppwriteDataSource(
              config: config,
              appwriteWrapper: appwriteWrapperMock,
            );

            mocktail
                .when(
                  () => appwriteWrapperMock.getDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenAnswer(
                  (_) async =>
                      Result.err(AppwriteWrapperUnexpectedFailure('k7^&M')),
                );

            dataSource.fetchSingle(id);

            mocktail.verify(
              () => appwriteWrapperMock.getDocument(
                databaseId: config.databaseId,
                collectionId: config.collectionId,
                documentId: id,
              ),
            );
          });
        }
      },
    );

    group(
      'should return expected failure if Appwrite wrapper fails',
      () {
        for (final values in expectedAppwriteErrorMappings) {
          test(values.toString(), () async {
            final wrapperFailure = values[0] as AppwriteWrapperFailure;
            final expectedFailure =
                values[1] as QuestionsAppwriteDataSourceFailure;

            mocktail
                .when(
                  () => appwriteWrapperMock.getDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenAnswer((_) async => Result.err(wrapperFailure));

            final result = await dataSource.fetchSingle('9m8v3W');

            expect(result.isErr, true);
            expect(result.err, expectedFailure);
          });
        }
      },
    );

    group(
      'should return expected',
      () {
        for (final values in [
          [
            Document(
              $id: '',
              $collectionId: '',
              $databaseId: '',
              $createdAt: '',
              $updatedAt: '',
              $permissions: [],
              data: {
                'title': '',
                'options': '[]',
                'difficulty': '',
                'description': '',
                'categories': <String>[],
              },
            ),
            const AppwriteQuestionModel(
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
            )
          ],
          [
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
            const AppwriteQuestionModel(
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
            )
          ],
        ]) {
          test(values.toString(), () async {
            final appwriteDocument = values[0] as Document;
            final expectedModel = values[1] as AppwriteQuestionModel;

            mocktail
                .when(
                  () => appwriteWrapperMock.getDocument(
                    collectionId: mocktail.any(named: 'collectionId'),
                    databaseId: mocktail.any(named: 'databaseId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenAnswer((_) async => Result.ok(appwriteDocument));

            final result = await dataSource.fetchSingle('!K8@');

            expect(result.isOk, true);
            expect(result.ok, expectedModel);
          });
        }
      },
    );
  });
}

class _AppwriteWrapperMock extends mocktail.Mock implements AppwriteWrapper {}

class _AppwriteQuestionCreationModelMock extends mocktail.Mock
    implements AppwriteQuestionCreationModel {}
