import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';

class QuestionCollectionAppwriteDataSource {
  QuestionCollectionAppwriteDataSource({
    required QuestionsAppwriteDataSourceConfig config,
    required AppwriteConnector appwriteConnector,
  })  : _config = config,
        _appwriteConnector = appwriteConnector;

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<QuestionCollectionAppwriteDataSource>();

  QuestionsAppwriteDataSourceConfig _config;
  final AppwriteConnector _appwriteConnector;

  Future<Result<AppwriteQuestionModel, QuestionsAppwriteDataSourceFailure>>
      createSingle(AppwriteQuestionCreationModel creationModel) async {
    _logger.debug('Creating single question on Appwrite...');
    final creationResult = await _performDocumentCreation(creationModel);

    return creationResult.when(
      ok: (doc) {
        _logger.debug('Question created successfully on Appwrite');
        return Result.ok(AppwriteQuestionModel.fromDocument(doc));
      },
      err: (failure) {
        _logger.error('Unable to create question on Appwrite');
        return Result.err(_mapAppwriteConnectorFailure(failure));
      },
    );
  }

  Future<Result<Unit, QuestionsAppwriteDataSourceFailure>> deleteSingle(
    String id,
  ) async {
    _logger.debug('Deleting single question with id: $id from Appwrite...');

    final deletionResult = await _performAppwriteDeletion(id);

    return deletionResult.when(
      ok: (_) {
        _logger.debug('Question deleted successfully from Appwrite');
        return const Result.ok(unit);
      },
      err: (failure) {
        _logger.error('Unable to delete question on Appwrite');
        return Result.err(_mapAppwriteConnectorFailure(failure));
      },
    );
  }

  Future<Result<AppwriteQuestionModel, QuestionsAppwriteDataSourceFailure>>
      fetchSingle(String id) async {
    _logger.debug('Fetching single question from Appwrite...');

    final documentFetchingResult = await _appwriteConnector.getDocument(
      AppwriteDocumentReference(
        databaseId: _config.databaseId,
        collectionId: _config.collectionId,
        documentId: id,
      ),
    );

    return documentFetchingResult.when(
      ok: (document) {
        _logger.debug('Question fetched from Appwrite successfully');

        return Result.ok(AppwriteQuestionModel.fromDocument(document));
      },
      err: (failure) {
        _logger.error('Unable to fetch question from Appwrite');
        return Result.err(_mapAppwriteConnectorFailure(failure));
      },
    );
  }

  // ignore: avoid_setters_without_getters
  set config(QuestionsAppwriteDataSourceConfig config) => _config = config;

  Future<Result<Document, AppwriteConnectorFailure>> _performDocumentCreation(
    AppwriteQuestionCreationModel creationModel,
  ) async =>
      _appwriteConnector.createDocument(
        AppwriteDocumentCreationRequest(
          databaseId: _config.databaseId,
          collectionId: _config.collectionId,
          documentId: creationModel.id,
          data: creationModel.toMap(),
        ),
      );

  Future<Result<Unit, AppwriteConnectorFailure>> _performAppwriteDeletion(
    String id,
  ) async =>
      _appwriteConnector.deleteDocument(
        AppwriteDocumentReference(
          databaseId: _config.databaseId,
          collectionId: _config.collectionId,
          documentId: id,
        ),
      );

  QuestionsAppwriteDataSourceFailure _mapAppwriteConnectorFailure(
    AppwriteConnectorFailure failure,
  ) {
    _logger
        .debug('Mapping Appwrite connector failure to data source failure...');

    return failure is AppwriteConnectorUnexpectedFailure
        ? QuestionsAppwriteDataSourceUnexpectedFailure(failure.message)
        : QuestionsAppwriteDataSourceAppwriteFailure(
            (failure as AppwriteConnectorAppwriteFailure).error.toString(),
          );
  }
}

class QuestionsAppwriteDataSourceConfig {
  QuestionsAppwriteDataSourceConfig({
    required this.databaseId,
    required this.collectionId,
  });

  final String databaseId;
  final String collectionId;
}

abstract class QuestionsAppwriteDataSourceFailure extends Equatable {}

class QuestionsAppwriteDataSourceUnexpectedFailure
    extends QuestionsAppwriteDataSourceFailure {
  QuestionsAppwriteDataSourceUnexpectedFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class QuestionsAppwriteDataSourceAppwriteFailure
    extends QuestionsAppwriteDataSourceFailure {
  QuestionsAppwriteDataSourceAppwriteFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
