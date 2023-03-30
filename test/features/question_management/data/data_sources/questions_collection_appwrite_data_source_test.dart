import 'package:appwrite/models.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';

void main() {
  late AppwriteConnector appwriteConnectorMock;
  late QuestionCollectionAppwriteDataSource dataSource;

  final expectedAppwriteErrorMappings = [
    [
      AppwriteConnectorUnexpectedFailure(''),
      QuestionsAppwriteDataSourceUnexpectedFailure(''),
    ],
    [
      AppwriteConnectorUnexpectedFailure(r'$4*'),
      QuestionsAppwriteDataSourceUnexpectedFailure(r'$4*'),
    ],
    [
      AppwriteConnectorAppwriteFailure(const UnknownAppwriteError()),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError().toString(),
      ),
    ],
    [
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
      AppwriteConnectorAppwriteFailure(
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
    appwriteConnectorMock = _AppwriteConnectorMock();
    dataSource = QuestionCollectionAppwriteDataSource(
      config: QuestionsAppwriteDataSourceConfig(
        databaseId: 'G3Q',
        collectionId: 'A9MnFkz',
      ),
      appwriteConnector: appwriteConnectorMock,
    );

    mocktail.registerFallbackValue(_AppwriteDocumentReferenceMock());
  });

  tearDown(mocktail.resetMocktailState);

  group('deleteSingle', () {
    parameterizedTest(
      'should call Appwrite connector correctly',
      ParameterizedSource.values([
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
      ]),
      (values) {
        final config = values[0] as QuestionsAppwriteDataSourceConfig;
        final id = values[1] as String;

        final dataSource = QuestionCollectionAppwriteDataSource(
          config: config,
          appwriteConnector: appwriteConnectorMock,
        );

        mocktail
            .when(() => appwriteConnectorMock.deleteDocument(mocktail.any()))
            .thenAnswer(
              (_) async =>
                  Result.err(AppwriteConnectorUnexpectedFailure('k7^&M')),
            );

        dataSource.deleteSingle(id);

        mocktail.verify(
          () => appwriteConnectorMock.deleteDocument(
            AppwriteDocumentReference(
              databaseId: config.databaseId,
              collectionId: config.collectionId,
              documentId: id,
            ),
          ),
        );
      },
    );

    parameterizedTest(
      'should return expected failure if Appwrite connector fails',
      ParameterizedSource.values(expectedAppwriteErrorMappings),
      (values) async {
        final appwriteConnectorFailure = values[0] as AppwriteConnectorFailure;
        final expectedFailure = values[1] as QuestionsAppwriteDataSourceFailure;

        mocktail
            .when(() => appwriteConnectorMock.deleteDocument(mocktail.any()))
            .thenAnswer((_) async => Result.err(appwriteConnectorFailure));

        final result = await dataSource.deleteSingle('*1Kl!M2q');

        expect(result.isErr, true);
        expect(result.err, expectedFailure);
      },
    );

    test(
      'should return nothing if Appwrite connector returns nothing',
          () async {
        mocktail
            .when(() => appwriteConnectorMock.deleteDocument(mocktail.any()))
            .thenAnswer((_) async => const Result.ok(unit));

        final result = await dataSource.deleteSingle('vJk60VoW');

        expect(result.isOk, true);
        expect(result.ok, unit);
      },
    );
  });

  group('fetchSingle', () {
    parameterizedTest(
      'should call Appwrite connector correctly',
      ParameterizedSource.values([
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
      ]),
      (values) {
        final config = values[0] as QuestionsAppwriteDataSourceConfig;
        final id = values[1] as String;

        final dataSource = QuestionCollectionAppwriteDataSource(
          config: config,
          appwriteConnector: appwriteConnectorMock,
        );

        mocktail
            .when(() => appwriteConnectorMock.getDocument(mocktail.any()))
            .thenAnswer(
              (_) async =>
                  Result.err(AppwriteConnectorUnexpectedFailure('k7^&M')),
            );

        dataSource.fetchSingle(id);

        mocktail.verify(
          () => appwriteConnectorMock.getDocument(
            AppwriteDocumentReference(
              databaseId: config.databaseId,
              collectionId: config.collectionId,
              documentId: id,
            ),
          ),
        );
      },
    );

    parameterizedTest(
      'should return expected failure if Appwrite connector fails',
      ParameterizedSource.values(expectedAppwriteErrorMappings),
      (values) async {
        final appwriteConnectorFailure = values[0] as AppwriteConnectorFailure;
        final expectedFailure = values[1] as QuestionsAppwriteDataSourceFailure;

        mocktail
            .when(() => appwriteConnectorMock.getDocument(mocktail.any()))
            .thenAnswer((_) async => Result.err(appwriteConnectorFailure));

        final result = await dataSource.fetchSingle('9m8v3W');

        expect(result.isErr, true);
        expect(result.err, expectedFailure);
      },
    );

    parameterizedTest(
      'should return expected',
      ParameterizedSource.values([
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
      ]),
      (values) async {
        final appwriteDocument = values[0] as Document;
        final expectedModel = values[1] as AppwriteQuestionModel;

        mocktail
            .when(() => appwriteConnectorMock.getDocument(mocktail.any()))
            .thenAnswer((_) async => Result.ok(appwriteDocument));

        final result = await dataSource.fetchSingle('!K8@');

        expect(result.isOk, true);
        expect(result.ok, expectedModel);
      },
    );
  });
}

class _AppwriteConnectorMock extends mocktail.Mock
    implements AppwriteConnector {}

class _AppwriteDocumentReferenceMock extends mocktail.Mock
    implements AppwriteDocumentReference {}
