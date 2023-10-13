import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_error_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_profile_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/profile_collection_appwrite_data_source.dart';

void main() {
  late QuizLabLogger logger;
  late Databases databases;

  late ProfileCollectionAppwriteDataSourceImpl dataSource;

  setUp(() {
    logger = _MockQuizLabLogger();
    databases = _MockDatabases();

    dataSource = ProfileCollectionAppwriteDataSourceImpl(
      logger: logger,
      databases: databases,
      appwriteDatabaseId: '5amP',
      appwriteProfileCollectionId: 'IRgx3zB',
    );
  });

  group('fetchSingle', () {
    for (final id in ['7l0', 'dkg35']) {
      test('should log initial message with $id as given id', () async {
        when(
          () => databases.getDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
          ),
        ).thenThrow(AppwriteException());

        await dataSource.fetchSingle(id);

        verify(() => logger.debug('Fetching single profile with id: $id from Appwrite...')).called(1);
      });
    }

    group('should return expected err when databases throws', () {
      for (final testCases in [
        (
          AppwriteException('', 400, 'general_argument_invalid'),
          const GeneralArgumentInvalidAppwriteErrorDto(message: ''),
          'mWU',
          'CaF',
          'ug21Zz'
        ),
        (
          AppwriteException('7R9n', 9999, '7dA'),
          const UnknownAppwriteErrorDto(type: '7dA', code: 9999, message: '7R9n'),
          'isqT1EO',
          '2XKw41',
          '6ytxheK0'
        ),
      ]) {
        final exception = testCases.$1;
        final expectedError = testCases.$2;
        final databaseId = testCases.$3;
        final collectionId = testCases.$4;
        final documentId = testCases.$5;

        test(
          '$exception as exception, $databaseId as database id, $collectionId as collection id and $documentId as document id should return $expectedError',
          () async {
            when(
              () => databases.getDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: documentId,
              ),
            ).thenThrow(exception);

            dataSource
              ..appwriteDatabaseId = databaseId
              ..appwriteProfileCollectionId = collectionId;
            final result = await dataSource.fetchSingle(documentId);

            verify(() => logger.error(exception.toString())).called(1);
            expect(result, Err<AppwriteProfileDto, AppwriteErrorDto>(expectedError));
          },
        );
      }
    });

    group('should return ok as expected', () {
      for (final testCase in [
        (
          'K3rEE1',
          'u228',
          '8gj3Gm',
          Document(
            $id: 'ljkCh',
            $collectionId: '',
            $permissions: [],
            $databaseId: '',
            $createdAt: '',
            $updatedAt: '',
            data: {'displayName': 'NXEzZH'},
          ),
          const AppwriteProfileDto(id: 'ljkCh', displayName: 'NXEzZH')
        ),
      ]) {
        final databaseId = testCase.$1;
        final collectionId = testCase.$2;
        final documentId = testCase.$3;
        final document = testCase.$4;
        final expected = testCase.$5;

        test(
          '$databaseId as database id, $collectionId as collection id, $documentId as document id and $document as document should return $expected',
          () async {
            when(
              () => databases.getDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: documentId,
              ),
            ).thenAnswer((_) async => document);

            dataSource
              ..appwriteDatabaseId = databaseId
              ..appwriteProfileCollectionId = collectionId;
            final result = await dataSource.fetchSingle(documentId);

            expect(result, Ok<AppwriteProfileDto, AppwriteErrorDto>(expected));
          },
        );
      }
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockDatabases extends Mock implements Databases {}
