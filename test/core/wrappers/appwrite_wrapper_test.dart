import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';

void main() {
  late Databases databasesMock;

  late AppwriteWrapper wrapper;

  setUp(() {
    databasesMock = _DatabasesMock();

    wrapper = AppwriteWrapper(
      databases: databasesMock,
    );
  });

  group('createDocument', () {
    group('should call Appwrite databases services correctly', () {
      for (final creationRequest in [
        const _AppwriteDocumentCreationRequest(
          databaseId: '',
          collectionId: '',
          documentId: '',
          data: {},
        ),
        const _AppwriteDocumentCreationRequest(
          databaseId: '5Pko',
          collectionId: 'S^*s',
          documentId: 'ePU3b',
          data: {
            'a': 1,
            'b': 2,
            'c': {
              'd': 3,
              'e': 4,
            },
          },
          permissions: [],
        ),
        const _AppwriteDocumentCreationRequest(
          databaseId: '5Pko',
          collectionId: 'S^*s',
          documentId: 'ePU3b',
          data: {
            'a': 1,
            'b': 2,
            'c': {
              'd': 3,
              'e': 4,
            },
          },
          permissions: [
            'wHCt',
            '8H%J',
            'N56OR6',
          ],
        ),
      ]) {
        test(creationRequest.toString(), () {
          mocktail
              .when(
                () => databasesMock.createDocument(
                  databaseId: creationRequest.databaseId,
                  collectionId: creationRequest.collectionId,
                  documentId: creationRequest.documentId,
                  data: creationRequest.data,
                ),
              )
              .thenAnswer((_) async => _DocumentMock());

          wrapper.createDocument(
            databaseId: creationRequest.databaseId,
            collectionId: creationRequest.collectionId,
            documentId: creationRequest.documentId,
            data: creationRequest.data,
            permissions: creationRequest.permissions,
          );

          mocktail.verify(
            () => databasesMock.createDocument(
              databaseId: creationRequest.databaseId,
              collectionId: creationRequest.collectionId,
              documentId: creationRequest.documentId,
              data: creationRequest.data,
              permissions: creationRequest.permissions,
            ),
          );
        });
      }
    });

    group('failure', () {
      group(
          'should return expected failure when Databases service throws given '
          'exceptions', () {
        for (final values in [
          [
            AppwriteException('', 500, ''),
            AppwriteWrapperServiceFailure(
              const UnknownAppwriteError(
                message: '',
                code: 500,
                type: '',
              ),
            )
          ],
          [
            _AppwriteExceptionMock(),
            AppwriteWrapperServiceFailure(const UnknownAppwriteError())
          ],
          [
            AppwriteException(r'Azz3$P', 32, 'tB*g#'),
            AppwriteWrapperServiceFailure(
              const UnknownAppwriteError(
                message: r'Azz3$P',
                code: 32,
                type: 'tB*g#',
              ),
            )
          ],
          [
            AppwriteException('', 400, 'general_argument_invalid'),
            AppwriteWrapperServiceFailure(
              const GeneralArgumentInvalidAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('#FsFcWB', 400, 'general_argument_invalid'),
            AppwriteWrapperServiceFailure(
              const GeneralArgumentInvalidAppwriteError(message: '#FsFcWB'),
            )
          ],
          [
            AppwriteException('', 404, 'database_not_found'),
            AppwriteWrapperServiceFailure(
              const DatabaseNotFoundAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('9aoF4', 404, 'database_not_found'),
            AppwriteWrapperServiceFailure(
              const DatabaseNotFoundAppwriteError(message: '9aoF4'),
            )
          ],
          [
            AppwriteException('', 404, 'collection_not_found'),
            AppwriteWrapperServiceFailure(
              const CollectionNotFoundAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('&!LBR', 404, 'collection_not_found'),
            AppwriteWrapperServiceFailure(
              const CollectionNotFoundAppwriteError(message: '&!LBR'),
            )
          ],
          [
            AppwriteException('', 404, 'document_not_found'),
            AppwriteWrapperServiceFailure(
              const DocumentNotFoundAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('XG##3R', 404, 'document_not_found'),
            AppwriteWrapperServiceFailure(
              const DocumentNotFoundAppwriteError(message: 'XG##3R'),
            )
          ],
        ]) {
          test(values.toString(), () async {
            final exception = values[0] as AppwriteException;
            final expectedFailure = values[1] as AppwriteWrapperFailure;

            mocktail
                .when(
                  () => databasesMock.createDocument(
                    databaseId: mocktail.any(named: 'databaseId'),
                    collectionId: mocktail.any(named: 'collectionId'),
                    documentId: mocktail.any(named: 'documentId'),
                    data: mocktail.any(named: 'data'),
                  ),
                )
                .thenThrow(exception);

            final result = await wrapper.createDocument(
              databaseId: 'O68JS0u',
              collectionId: 'zVIev',
              documentId: '^Z9@Cm',
              data: {
                '38W1t': 459,
                r'#o#N$Y*J': r'X$qh6xIT',
                'ETc!x#A': {
                  'rkj&pTSv': 3,
                  'BmW7r': 4,
                },
              },
            );

            expect(result.isErr, true);
            expect(result.err, expectedFailure);
          });
        }
      });

      test(
        'should return unexpected failure when an non-Appwrite exception is '
        'thrown',
        () async {
          mocktail
              .when(
                () => databasesMock.createDocument(
                  databaseId: mocktail.any(named: 'databaseId'),
                  collectionId: mocktail.any(named: 'collectionId'),
                  documentId: mocktail.any(named: 'documentId'),
                  data: mocktail.any(named: 'data'),
                ),
              )
              .thenThrow(_ExceptionMock());

          final result = await wrapper.createDocument(
            databaseId: 'O68JS0u',
            collectionId: 'zVIev',
            documentId: '^Z9@Cm',
            data: {
              '38W1t': 459,
              r'#o#N$Y*J': r'X$qh6xIT',
              'ETc!x#A': {
                'rkj&pTSv': 3,
                'BmW7r': 4,
              },
            },
          );

          expect(result.isErr, true);
          expect(
            result.err,
            AppwriteWrapperUnexpectedFailure('_ExceptionMock'),
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
                () => databasesMock.createDocument(
                  databaseId: mocktail.any(named: 'databaseId'),
                  collectionId: mocktail.any(named: 'collectionId'),
                  documentId: mocktail.any(named: 'documentId'),
                  data: mocktail.any(named: 'data'),
                ),
              )
              .thenAnswer((_) async => dummyDocument);

          final result = await wrapper.createDocument(
            databaseId: 'O68JS0u',
            collectionId: 'zVIev',
            documentId: '^Z9@Cm',
            data: {
              '38W1t': 459,
              r'#o#N$Y*J': r'X$qh6xIT',
              'ETc!x#A': {
                'rkj&pTSv': 3,
                'BmW7r': 4,
              },
            },
          );

          expect(result.isOk, true);
          expect(result.ok, dummyDocument);
        },
      );
    });
  });

  group('deleteDocument', () {
    group(
      'should call Databases service correctly',
      () {
        for (final values in [
          ['', '', ''],
          ['2M%', 'ecC', '447Z'],
        ]) {
          test(values.toString(), () async {
            final databaseId = values[0];
            final collectionId = values[1];
            final documentId = values[2];

            mocktail
                .when(
                  () => databasesMock.deleteDocument(
                    databaseId: mocktail.any(named: 'databaseId'),
                    collectionId: mocktail.any(named: 'collectionId'),
                    documentId: mocktail.any(named: 'documentId'),
                  ),
                )
                .thenThrow(_AppwriteExceptionMock());

            await wrapper.deleteDocument(
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
          });
        }
      },
    );

    group(
      'should return expected failure when Databases service throws given '
      'exceptions',
      () {
        for (final values in [
          [
            AppwriteException('', 500, ''),
            AppwriteWrapperServiceFailure(
              const UnknownAppwriteError(
                message: '',
                code: 500,
                type: '',
              ),
            )
          ],
          [
            _AppwriteExceptionMock(),
            AppwriteWrapperServiceFailure(const UnknownAppwriteError())
          ],
          [
            AppwriteException('T0J!phB5', 22, 'y640p89'),
            AppwriteWrapperServiceFailure(
              const UnknownAppwriteError(
                message: 'T0J!phB5',
                code: 22,
                type: 'y640p89',
              ),
            )
          ],
          [
            AppwriteException('', 400, 'general_argument_invalid'),
            AppwriteWrapperServiceFailure(
              const GeneralArgumentInvalidAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException(r'Q$@!yG', 400, 'general_argument_invalid'),
            AppwriteWrapperServiceFailure(
              const GeneralArgumentInvalidAppwriteError(message: r'Q$@!yG'),
            )
          ],
          [
            AppwriteException('', 404, 'database_not_found'),
            AppwriteWrapperServiceFailure(
              const DatabaseNotFoundAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('45S6hm@', 404, 'database_not_found'),
            AppwriteWrapperServiceFailure(
              const DatabaseNotFoundAppwriteError(message: '45S6hm@'),
            )
          ],
          [
            AppwriteException('', 404, 'collection_not_found'),
            AppwriteWrapperServiceFailure(
              const CollectionNotFoundAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('7o2', 404, 'collection_not_found'),
            AppwriteWrapperServiceFailure(
              const CollectionNotFoundAppwriteError(message: '7o2'),
            )
          ],
          [
            AppwriteException('', 404, 'document_not_found'),
            AppwriteWrapperServiceFailure(
              const DocumentNotFoundAppwriteError(message: ''),
            )
          ],
          [
            AppwriteException('#G#5K@', 404, 'document_not_found'),
            AppwriteWrapperServiceFailure(
              const DocumentNotFoundAppwriteError(message: '#G#5K@'),
            )
          ],
        ]) {
          test(values.toString(), () async {
            final exception = values[0] as AppwriteException;
            final expectedFailure = values[1] as AppwriteWrapperFailure;

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

            final result = await wrapper.deleteDocument(
              const AppwriteDocumentReference(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: documentId,
              ),
            );

            expect(result.isErr, true);
            expect(result.err, expectedFailure);
          });
        }
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

        final result = await wrapper.deleteDocument(
          const AppwriteDocumentReference(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: documentId,
          ),
        );

        expect(result.isErr, true);
        expect(
          result.err,
          AppwriteWrapperUnexpectedFailure('_ExceptionMock'),
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

        final result = await wrapper.deleteDocument(
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

  group('getDocument', () {
    group(
      'should call Appwrite databases services correctly',
      () {
        for (final docReference in [
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
        ]) {
          test(docReference.toString(), () {
            mocktail
                .when(
                  () => databasesMock.getDocument(
                    databaseId: docReference.databaseId,
                    collectionId: docReference.collectionId,
                    documentId: docReference.documentId,
                  ),
                )
                .thenAnswer((_) async => _DocumentMock());

            wrapper.getDocument(docReference);

            mocktail.verify(
              () => databasesMock.getDocument(
                databaseId: docReference.databaseId,
                collectionId: docReference.collectionId,
                documentId: docReference.documentId,
              ),
            );
          });
        }
      },
    );

    group('failure', () {
      group(
        'should return expected failure when Databases service throws given '
        'exceptions',
        () {
          for (final values in [
            [
              AppwriteException('', 500, ''),
              AppwriteWrapperServiceFailure(
                const UnknownAppwriteError(
                  message: '',
                  code: 500,
                  type: '',
                ),
              )
            ],
            [
              _AppwriteExceptionMock(),
              AppwriteWrapperServiceFailure(const UnknownAppwriteError())
            ],
            [
              AppwriteException(r'Azz3$P', 32, 'tB*g#'),
              AppwriteWrapperServiceFailure(
                const UnknownAppwriteError(
                  message: r'Azz3$P',
                  code: 32,
                  type: 'tB*g#',
                ),
              )
            ],
            [
              AppwriteException('', 400, 'general_argument_invalid'),
              AppwriteWrapperServiceFailure(
                const GeneralArgumentInvalidAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('#FsFcWB', 400, 'general_argument_invalid'),
              AppwriteWrapperServiceFailure(
                const GeneralArgumentInvalidAppwriteError(message: '#FsFcWB'),
              )
            ],
            [
              AppwriteException('', 404, 'database_not_found'),
              AppwriteWrapperServiceFailure(
                const DatabaseNotFoundAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('9aoF4', 404, 'database_not_found'),
              AppwriteWrapperServiceFailure(
                const DatabaseNotFoundAppwriteError(message: '9aoF4'),
              )
            ],
            [
              AppwriteException('', 404, 'collection_not_found'),
              AppwriteWrapperServiceFailure(
                const CollectionNotFoundAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('&!LBR', 404, 'collection_not_found'),
              AppwriteWrapperServiceFailure(
                const CollectionNotFoundAppwriteError(message: '&!LBR'),
              )
            ],
            [
              AppwriteException('', 404, 'document_not_found'),
              AppwriteWrapperServiceFailure(
                const DocumentNotFoundAppwriteError(message: ''),
              )
            ],
            [
              AppwriteException('XG##3R', 404, 'document_not_found'),
              AppwriteWrapperServiceFailure(
                const DocumentNotFoundAppwriteError(message: 'XG##3R'),
              )
            ],
          ]) {
            test(values.toString(), () async {
              final exception = values[0] as AppwriteException;
              final expectedFailure = values[1] as AppwriteWrapperFailure;

              mocktail
                  .when(
                    () => databasesMock.getDocument(
                      databaseId: mocktail.any(named: 'databaseId'),
                      collectionId: mocktail.any(named: 'collectionId'),
                      documentId: mocktail.any(named: 'documentId'),
                    ),
                  )
                  .thenThrow(exception);

              final result = await wrapper.getDocument(
                const AppwriteDocumentReference(
                  databaseId: 'O68JS0u',
                  collectionId: 'zVIev',
                  documentId: '^Z9@Cm',
                ),
              );

              expect(result.isErr, true);
              expect(result.err, expectedFailure);
            });
          }
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

          final result = await wrapper.getDocument(
            const AppwriteDocumentReference(
              databaseId: 'm%oWh3&',
              collectionId: 'Wpj0tk',
              documentId: r'$j651f',
            ),
          );

          expect(result.isErr, true);
          expect(
            result.err,
            AppwriteWrapperUnexpectedFailure('_ExceptionMock'),
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

          final result = await wrapper.getDocument(
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
  });
}

class _DatabasesMock extends mocktail.Mock implements Databases {}

class _AppwriteExceptionMock extends mocktail.Mock
    implements AppwriteException {}

class _ExceptionMock extends mocktail.Mock implements Exception {}

class _DocumentMock extends mocktail.Mock implements Document {}

class _AppwriteDocumentCreationRequest extends Equatable {
  const _AppwriteDocumentCreationRequest({
    required this.databaseId,
    required this.collectionId,
    required this.documentId,
    required this.data,
    this.permissions,
  });

  final String databaseId;
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;
  final List<String>? permissions;

  @override
  List<Object?> get props => [
        databaseId,
        collectionId,
        documentId,
        data,
        permissions,
      ];
}
