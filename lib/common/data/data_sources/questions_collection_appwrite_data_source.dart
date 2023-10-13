import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/dto/appwrite_error_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_list_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_realtime_message_dto.dart';
import 'package:quiz_lab/common/data/dto/create_appwrite_question_dto.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/common/data/wrappers/appwrite_wrapper.dart';

abstract interface class QuestionCollectionAppwriteDataSource {
  Future<Result<AppwriteQuestionDto, String>> createSingle(CreateAppwriteQuestionDto dto);

  Future<Result<Unit, QuestionsAppwriteDataSourceFailure>> deleteSingle(String id);

  Future<Result<AppwriteQuestionDto, QuestionsAppwriteDataSourceFailure>> fetchSingle(String id);

  Future<Result<AppwriteQuestionListDto, AppwriteErrorDto>> getAll();

  Future<Result<Stream<AppwriteRealtimeQuestionMessageDto>, AppwriteErrorDto>> watchForUpdate();
}

class QuestionCollectionAppwriteDataSourceImpl implements QuestionCollectionAppwriteDataSource {
  QuestionCollectionAppwriteDataSourceImpl({
    required this.logger,
    required this.appwriteDatabaseId,
    required this.appwriteQuestionCollectionId,
    required this.appwriteWrapper,
    required this.databases,
    required this.realtime,
  });

  final QuizLabLogger logger;
  String appwriteDatabaseId;
  String appwriteQuestionCollectionId;
  final AppwriteWrapper appwriteWrapper;
  final Databases databases;
  final Realtime realtime;

  @override
  Future<Result<AppwriteQuestionDto, String>> createSingle(CreateAppwriteQuestionDto dto) async {
    logger.debug('Creating single question on Appwrite...');

    return (await _performDocumentCreation(dto))
        .inspect((_) => logger.debug('Question created successfully on Appwrite'))
        .map(AppwriteQuestionDto.fromDocument)
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr((_) => 'Unable to create question on Appwrite');
  }

  @override
  Future<Result<Unit, QuestionsAppwriteDataSourceFailure>> deleteSingle(String id) async {
    logger.debug('Deleting single question with id: $id from Appwrite...');

    final deletionResult = await _performAppwriteDeletion(id);

    return deletionResult.when(
      ok: (_) {
        logger.debug('Question deleted successfully from Appwrite');
        return const Ok(unit);
      },
      err: (failure) {
        logger.error('Unable to delete question on Appwrite');
        return Err(_mapAppwriteWrapperFailure(failure));
      },
    );
  }

  @override
  Future<Result<AppwriteQuestionDto, QuestionsAppwriteDataSourceFailure>> fetchSingle(String id) async {
    logger.debug('Fetching single question from Appwrite...');

    final documentFetchingResult = await appwriteWrapper.getDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteQuestionCollectionId,
      documentId: id,
    );

    return documentFetchingResult.when(
      ok: (document) {
        logger.debug('Question fetched from Appwrite successfully');

        return Ok(AppwriteQuestionDto.fromDocument(document));
      },
      err: (failure) {
        logger.error('Unable to fetch question from Appwrite');
        return Err(_mapAppwriteWrapperFailure(failure));
      },
    );
  }

  @override
  Future<Result<AppwriteQuestionListDto, AppwriteErrorDto>> getAll() async {
    logger.debug('Retrieving all questions from Appwrite...');

    return (await _listDocuments())
        .map(AppwriteQuestionListDto.fromAppwriteDocumentList)
        .mapErr(AppwriteErrorDto.fromAppwriteException);
  }

  @override
  Future<Result<Stream<AppwriteRealtimeQuestionMessageDto>, AppwriteErrorDto>> watchForUpdate() async {
    logger.debug('Watching for question collection updates...');

    final s = realtime.subscribe([
      'databases'
          '.$appwriteDatabaseId'
          '.collections'
          '.$appwriteQuestionCollectionId'
          '.documents'
    ]);

    return Ok(s.stream.map(AppwriteRealtimeQuestionMessageDto.fromRealtimeMessage));
  }

  Future<Result<DocumentList, AppwriteException>> _listDocuments() async {
    try {
      return Ok(
        await databases.listDocuments(databaseId: appwriteDatabaseId, collectionId: appwriteQuestionCollectionId),
      );
    } on AppwriteException catch (e) {
      return Err(e);
    }
  }

  Future<Result<Document, Exception>> _performDocumentCreation(CreateAppwriteQuestionDto dto) async {
    try {
      final map = dto.toMap();

      return Ok(
        await databases.createDocument(
          databaseId: appwriteDatabaseId,
          collectionId: appwriteQuestionCollectionId,
          documentId: ID.unique(),
          data: map,
          permissions: dto.permissions?.map((p) => p.toString()).toList(),
        ),
      );
    } on Exception catch (e) {
      return Err(e);
    }
  }

  Future<Result<Unit, AppwriteWrapperFailure>> _performAppwriteDeletion(String id) async =>
      appwriteWrapper.deleteDocument(
        databaseId: appwriteDatabaseId,
        collectionId: appwriteQuestionCollectionId,
        documentId: id,
      );

  QuestionsAppwriteDataSourceFailure _mapAppwriteWrapperFailure(AppwriteWrapperFailure failure) {
    logger.debug('Mapping Appwrite wrapper failure to data source failure...');

    return failure is AppwriteWrapperUnexpectedFailure
        ? QuestionsAppwriteDataSourceUnexpectedFailure(failure.message)
        : QuestionsAppwriteDataSourceAppwriteFailure((failure as AppwriteWrapperServiceFailure).error.toString());
  }
}

abstract class QuestionsAppwriteDataSourceFailure extends Equatable {}

class QuestionsAppwriteDataSourceUnexpectedFailure extends QuestionsAppwriteDataSourceFailure {
  QuestionsAppwriteDataSourceUnexpectedFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class QuestionsAppwriteDataSourceAppwriteFailure extends QuestionsAppwriteDataSourceFailure {
  QuestionsAppwriteDataSourceAppwriteFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
