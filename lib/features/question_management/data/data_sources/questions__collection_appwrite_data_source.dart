import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
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

  final QuestionsAppwriteDataSourceConfig _config;
  final AppwriteConnector _appwriteConnector;

  Future<Result<Unit, QuestionsAppwriteDataSourceFailure>> deleteSingle(
    String id,
  ) async {
    _logger.debug('Deleting single question with id: $id from Appwrite...');

    final deletionResult = await _performAppwriteDeletion(id);

    return deletionResult.when(
      ok: (_) {
        _logger
            .debug('Question with id: $id deleted successfully from Appwrite');
        return const Result.ok(unit);
      },
      err: (failure) {
        final connectorFailure = _mapAppwriteConnectorFailure(failure);

        _logger.error(
          'Unable to delete question with id: $id on Appwrite due to failure: '
          '$connectorFailure',
        );
        return Result.err(connectorFailure);
      },
    );
  }

  Future<Result<AppwriteQuestionModel, QuestionsAppwriteDataSourceFailure>>
      getSingle(String id) => throw UnimplementedError();

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
  List<Object?> get props => [];
}
