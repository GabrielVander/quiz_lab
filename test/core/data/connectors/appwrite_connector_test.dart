import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
import 'package:quiz_lab/core/utils/unit.dart';

void main() {
  late Databases databasesMock;

  late AppwriteConnector connector;

  setUp(() {
    databasesMock = _DatabasesMock();

    connector = AppwriteConnector(
      databases: databasesMock,
    );
  });

  group('deleteDocument', () {
    parameterizedTest(
      'should call Databases service conrrectly',
      ParameterizedSource.values([
        ['', '', ''],
        ['2M%', 'ecC', '447Z'],
      ]),
      (values) async {
        final databaseId = values[0] as String;
        final collectionId = values[1] as String;
        final documentId = values[2] as String;

        mocktail
            .when(
              () => databasesMock.deleteDocument(
                databaseId: mocktail.any(named: 'databaseId'),
                collectionId: mocktail.any(named: 'collectionId'),
                documentId: mocktail.any(named: 'documentId'),
              ),
            )
            .thenThrow(_AppwriteExceptionMock());

        await connector.deleteDocument(
          AppwriteDocumentReference(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          ),
        );

        mocktail.verify(
          () => databasesMock.deleteDocument(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          ),
        );
      },
    );

    parameterizedTest(
      'should return expected failure when Databases service throws given '
      'exceptions',
      ParameterizedSource.values([
        [
          AppwriteException('', 500, ''),
          AppwriteConnectorAppwriteFailure(
            const UnknownAppwriteError(
              message: '',
              code: 500,
              type: '',
            ),
          )
        ],
        [
          _AppwriteExceptionMock(),
          AppwriteConnectorAppwriteFailure(const UnknownAppwriteError())
        ],
        [
          AppwriteException('T0J!phB5', 22, 'y640p89'),
          AppwriteConnectorAppwriteFailure(
            const UnknownAppwriteError(
              message: 'T0J!phB5',
              code: 22,
              type: 'y640p89',
            ),
          )
        ],
        [
          AppwriteException('', 400, 'general_argument_invalid'),
          AppwriteConnectorAppwriteFailure(
            const GeneralArgumentInvalidAppwriteError(message: ''),
          )
        ],
        [
          AppwriteException(r'Q$@!yG', 400, 'general_argument_invalid'),
          AppwriteConnectorAppwriteFailure(
            const GeneralArgumentInvalidAppwriteError(message: r'Q$@!yG'),
          )
        ],
        [
          AppwriteException('', 404, 'database_not_found'),
          AppwriteConnectorAppwriteFailure(
            const DatabaseNotFoundAppwriteError(message: ''),
          )
        ],
        [
          AppwriteException('45S6hm@', 404, 'database_not_found'),
          AppwriteConnectorAppwriteFailure(
            const DatabaseNotFoundAppwriteError(message: '45S6hm@'),
          )
        ],
        [
          AppwriteException('', 404, 'collection_not_found'),
          AppwriteConnectorAppwriteFailure(
            const CollectionNotFoundAppwriteError(message: ''),
          )
        ],
        [
          AppwriteException('7o2', 404, 'collection_not_found'),
          AppwriteConnectorAppwriteFailure(
            const CollectionNotFoundAppwriteError(message: '7o2'),
          )
        ],
        [
          AppwriteException('', 404, 'document_not_found'),
          AppwriteConnectorAppwriteFailure(
            const DocumentNotFoundAppwriteError(message: ''),
          )
        ],
        [
          AppwriteException('#G#5K@', 404, 'document_not_found'),
          AppwriteConnectorAppwriteFailure(
            const DocumentNotFoundAppwriteError(message: '#G#5K@'),
          )
        ],
      ]),
      (values) async {
        final exception = values[0] as AppwriteException;
        final expectedFailure = values[1] as AppwriteConnectorFailure;

        const databaseId = '*49';
        const collectionId = 'wgujt0';
        const documentId = 'o&TO@L';

        mocktail
            .when(
              () => databasesMock.deleteDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: documentId,
              ),
            )
            .thenThrow(exception);

        final result = await connector.deleteDocument(
          const AppwriteDocumentReference(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          ),
        );

        expect(result.isErr, true);
        expect(result.err, expectedFailure);
      },
    );

    test(
      'should return unexpected failure when an non-Appwrite exception is '
      'thrown',
      () async {
        const databaseId = '%&j9M^4m';
        const collectionId = 'y8A7';
        const documentId = 'Y%C7';

        mocktail
            .when(
              () => databasesMock.deleteDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: documentId,
              ),
            )
            .thenThrow(_ExceptionMock());

        final result = await connector.deleteDocument(
          const AppwriteDocumentReference(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          ),
        );

        expect(result.isErr, true);
        expect(
          result.err,
          AppwriteConnectorUnexpectedFailure('_ExceptionMock'),
        );
      },
    );

    test(
      "should return Unit if Databases service does't throws",
      () async {
        const databaseId = '045E9ED';
        const collectionId = 'b@u';
        const documentId = 'yMQ';

        mocktail
            .when(
              () => databasesMock.deleteDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: documentId,
              ),
            )
            .thenAnswer((_) async => null);

        final result = await connector.deleteDocument(
          const AppwriteDocumentReference(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          ),
        );

        expect(result.isOk, true);
        expect(result.ok, unit);
      },
    );
  });

  group(
    'getDocument',
    () {
      parameterizedTest(
        'should call Appwrite databases services correctly',
        ParameterizedSource.value([
          const AppwriteDocumentReference(
            databaseId: '',
            collectionId: '',
            documentId: '',
          ),
          const AppwriteDocumentReference(
            databaseId: '5Pko',
            collectionId: 'S^*s',
            documentId: 'ePU3b',
          ),
        ]),
        (values) {
          final documentReference = values[0] as AppwriteDocumentReference;

          mocktail
              .when(
                () => databasesMock.getDocument(
                  databaseId: documentReference.databaseId,
                  collectionId: documentReference.collectionId,
                  documentId: documentReference.documentId,
                ),
              )
              .thenAnswer((_) async => _DocumentMock());

          connector.getDocument(documentReference);

          mocktail.verify(
            () => databasesMock.getDocument(
              databaseId: documentReference.databaseId,
              collectionId: documentReference.collectionId,
              documentId: documentReference.documentId,
            ),
          );
        },
      );

      group('failure', () {
        parameterizedTest(
          'should return expected failure when Databases service throws given '
          'exceptions',
          ParameterizedSource.values([
            [
              AppwriteException('', 500, ''),
              AppwriteConnectorAppwriteFailure(
                const UnknownAppwriteError(
                  message: '',
                  code: 500,
                  type: '',
                ),
              )
            ],
            [
              _AppwriteExceptionMock(),
              AppwriteConnectorAppwriteFailure(const UnknownAppwriteError())
            ],
            [
              AppwriteException(r'Azz3$P', 32, 'tB*g#'),
              AppwriteConnectorAppwriteFailure(
                const UnknownAppwriteError(
                  message: r'Azz3$P',
                  code: 32,
                  type: 'tB*g#',
                ),
              )
            ],
            [
              AppwriteException('', 400, 'general_argument_invalid'),
              AppwriteConnectorAppwriteFailure(
                const GeneralArgumentInvalidAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('#FsFcWB', 400, 'general_argument_invalid'),
              AppwriteConnectorAppwriteFailure(
                const GeneralArgumentInvalidAppwriteError(message: '#FsFcWB'),
              )
            ],
            [
              AppwriteException('', 404, 'database_not_found'),
              AppwriteConnectorAppwriteFailure(
                const DatabaseNotFoundAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('9aoF4', 404, 'database_not_found'),
              AppwriteConnectorAppwriteFailure(
                const DatabaseNotFoundAppwriteError(message: '9aoF4'),
              )
            ],
            [
              AppwriteException('', 404, 'collection_not_found'),
              AppwriteConnectorAppwriteFailure(
                const CollectionNotFoundAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('&!LBR', 404, 'collection_not_found'),
              AppwriteConnectorAppwriteFailure(
                const CollectionNotFoundAppwriteError(message: '&!LBR'),
              )
            ],
            [
              AppwriteException('', 404, 'document_not_found'),
              AppwriteConnectorAppwriteFailure(
                const DocumentNotFoundAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('XG##3R', 404, 'document_not_found'),
              AppwriteConnectorAppwriteFailure(
                const DocumentNotFoundAppwriteError(message: 'XG##3R'),
              )
            ],
          ]),
          (values) async {
            final exception = values[0] as AppwriteException;
            final expectedFailure = values[1] as AppwriteConnectorFailure;

            mocktail
                .when(
                  () => databasesMock.getDocument(
                    databaseId: mocktail.any(named: 'databaseId'),
                    collectionId: mocktail.any(named: 'collectionId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenThrow(exception);

            final result = await connector.getDocument(
              const AppwriteDocumentReference(
                databaseId: 'O68JS0u',
                collectionId: 'zVIev',
                documentId: '^Z9@Cm',
              ),
            );

            expect(result.isErr, true);
            expect(result.err, expectedFailure);
          },
        );

        test(
          'should return unexpected failure when an non-Appwrite exception is '
          'thrown',
          () async {
            mocktail
                .when(
                  () => databasesMock.getDocument(
                    databaseId: mocktail.any(named: 'databaseId'),
                    collectionId: mocktail.any(named: 'collectionId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenThrow(_ExceptionMock());

            final result = await connector.getDocument(
              const AppwriteDocumentReference(
                databaseId: 'm%oWh3&',
                collectionId: 'Wpj0tk',
                documentId: r'$j651f',
              ),
            );

            expect(result.isErr, true);
            expect(
              result.err,
              AppwriteConnectorUnexpectedFailure('_ExceptionMock'),
            );
          },
        );
      });

      group('success', () {
        test(
          'should return expected document',
          () async {
            final dummyDocument = _DocumentMock();

            mocktail
                .when(
                  () => databasesMock.getDocument(
                    databaseId: mocktail.any(named: 'databaseId'),
                    collectionId: mocktail.any(named: 'collectionId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenAnswer((_) async => dummyDocument);

            final result = await connector.getDocument(
              const AppwriteDocumentReference(
                databaseId: 'FMGb&',
                collectionId: '9NXDK',
                documentId: '6ZCK',
              ),
            );

            expect(result.isOk, true);
            expect(result.ok, dummyDocument);
          },
        );
      });
    },
  );
}

class _DatabasesMock extends mocktail.Mock implements Databases {}

class _AppwriteExceptionMock extends mocktail.Mock
    implements AppwriteException {}

class _ExceptionMock extends mocktail.Mock implements Exception {}

class _DocumentMock extends mocktail.Mock implements Document {}
