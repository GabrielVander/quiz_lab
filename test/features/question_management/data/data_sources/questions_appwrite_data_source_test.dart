import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_appwrite_data_source.dart';

void main() {
  late AppwriteConnector appwriteConnectorMock;
  late QuestionsAppwriteDataSource dataSource;

  setUp(() {
    appwriteConnectorMock = _AppwriteConnectorMock();
    dataSource = QuestionsAppwriteDataSource(
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

        final dataSource = QuestionsAppwriteDataSource(
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
      ParameterizedSource.values([
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
      ]),
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
}

class _AppwriteConnectorMock extends mocktail.Mock
    implements AppwriteConnector {}

class _AppwriteDocumentReferenceMock extends mocktail.Mock
    implements AppwriteDocumentReference {}
