import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
import 'package:quiz_lab/core/utils/unit.dart';

class QuestionsAppwriteDataSource {
  QuestionsAppwriteDataSource({
    required QuestionsAppwriteDataSourceConfig config,
    required AppwriteConnector appwriteConnector,
  })  : _config = config,
        _appwriteConnector = appwriteConnector;

  final QuestionsAppwriteDataSourceConfig _config;
  final AppwriteConnector _appwriteConnector;

  Future<Result<Unit, QuestionsAppwriteDataSourceFailure>> deleteSingle(
    String id,
  ) async {
    final deletionResult = await _appwriteConnector.deleteDocument(
      AppwriteDocumentReference(
        databaseId: _config.databaseId,
        collectionId: _config.collectionId,
        documentId: id,
      ),
    );

    return deletionResult.when(
      ok: (_) => const Result.ok(unit),
      err: (failure) => Result.err(_mapAppwriteConnectorFailure(failure)),
    );
  }

  QuestionsAppwriteDataSourceFailure _mapAppwriteConnectorFailure(
    AppwriteConnectorFailure failure,
  ) =>
      failure is AppwriteConnectorUnexpectedFailure
          ? QuestionsAppwriteDataSourceUnexpectedFailure(failure.message)
          : QuestionsAppwriteDataSourceAppwriteFailure();
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
  QuestionsAppwriteDataSourceAppwriteFailure();

  @override
  List<Object?> get props => [];
}
