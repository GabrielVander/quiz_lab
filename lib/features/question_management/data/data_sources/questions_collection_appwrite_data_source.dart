import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_error_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_realtime_message_model.dart';
import 'package:quiz_lab/features/question_management/wrappers/appwrite_wrapper.dart';

abstract interface class QuestionCollectionAppwriteDataSource {
  Future<Result<AppwriteQuestionModel, String>> createSingle(AppwriteQuestionCreationModel creationModel);

  Future<Result<Unit, QuestionsAppwriteDataSourceFailure>> deleteSingle(String id);

  Future<Result<AppwriteQuestionModel, QuestionsAppwriteDataSourceFailure>> fetchSingle(String id);

  Future<Result<AppwriteQuestionListModel, AppwriteErrorModel>> getAll();

  Future<Result<Stream<AppwriteRealtimeQuestionMessageModel>, AppwriteErrorModel>> watchForUpdate();
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
  Future<Result<AppwriteQuestionModel, String>> createSingle(AppwriteQuestionCreationModel creationModel) async {
    logger.debug('Creating single question on Appwrite...');

    return (await _performDocumentCreation(creationModel))
        .inspect((_) => logger.debug('Question created successfully on Appwrite'))
        .map(AppwriteQuestionModel.fromDocument)
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
  Future<Result<AppwriteQuestionModel, QuestionsAppwriteDataSourceFailure>> fetchSingle(String id) async {
    logger.debug('Fetching single question from Appwrite...');

    final documentFetchingResult = await appwriteWrapper.getDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteQuestionCollectionId,
      documentId: id,
    );

    return documentFetchingResult.when(
      ok: (document) {
        logger.debug('Question fetched from Appwrite successfully');

        return Ok(AppwriteQuestionModel.fromDocument(document));
      },
      err: (failure) {
        logger.error('Unable to fetch question from Appwrite');
        return Err(_mapAppwriteWrapperFailure(failure));
      },
    );
  }

  @override
  Future<Result<AppwriteQuestionListModel, AppwriteErrorModel>> getAll() async {
    logger.debug('Retrieving all questions from Appwrite...');

    return (await _listDocuments())
        .map(AppwriteQuestionListModel.fromAppwriteDocumentList)
        .mapErr(AppwriteErrorModel.fromAppwriteException);
  }

  @override
  Future<Result<Stream<AppwriteRealtimeQuestionMessageModel>, AppwriteErrorModel>> watchForUpdate() async {
    logger.debug('Watching for question collection updates...');

    final s = realtime.subscribe([
      'databases'
          '.$appwriteDatabaseId'
          '.collections'
          '.$appwriteQuestionCollectionId'
          '.documents'
    ]);

    return Ok(s.stream.map(AppwriteRealtimeQuestionMessageModel.fromRealtimeMessage));
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

  Future<Result<Document, Exception>> _performDocumentCreation(AppwriteQuestionCreationModel creationModel) async {
    try {
      final map = creationModel.toMap();

      return Ok(
        await databases.createDocument(
          databaseId: appwriteDatabaseId,
          collectionId: appwriteQuestionCollectionId,
          documentId: ID.unique(),
          data: map,
          permissions: creationModel.permissions?.map((p) => p.toString()).toList(),
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
