import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';

class AppwriteConnector {
  AppwriteConnector({
    required Databases databases,
  }) : _databases = databases;

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<AppwriteConnector>();
  final Databases _databases;

  Future<Result<Unit, AppwriteConnectorFailure>> deleteDocument(
    AppwriteDocumentReference reference,
  ) async {
    _logger.debug('Deleting document...');

    try {
      return await _performDocumentDeletion(reference);
    } on AppwriteException catch (e) {
      _logger.error('Unable to delete due to Appwrite failure: $e');

      final appwriteError = _mapAppwriteExceptionToAppwriteError(e);

      return Result.err(AppwriteConnectorAppwriteFailure(appwriteError));
    } on Exception catch (e) {
      _logger.error('Unable to delete due to an unexpcted failure: $e');

      return Result.err(AppwriteConnectorUnexpectedFailure(e.toString()));
    }
  }

  Future<Result<Document, AppwriteConnectorFailure>> getDocument(
    AppwriteDocumentReference reference,
  ) =>
      throw UnimplementedError();

  Future<Result<Unit, AppwriteConnectorFailure>> _performDocumentDeletion(
    AppwriteDocumentReference reference,
  ) async {
    await _databases.deleteDocument(
      databaseId: reference.databaseId,
      collectionId: reference.collectionId,
      documentId: reference.documentId,
    );

    _logger.debug('Document deleted successfully');

    return const Result.ok(unit);
  }

  AppwriteError _mapAppwriteExceptionToAppwriteError(AppwriteException e) {
    _logger.debug('Mapping Appwrite exception to Appwrite error...');

    switch (e.type) {
      case 'general_argument_invalid':
        _logger.debug('Mapping to GeneralArgumentInvalidAppwriteError');
        return GeneralArgumentInvalidAppwriteError(message: e.message);
      case 'database_not_found':
        _logger.debug('Mapping to DatabaseNotFoundAppwriteError');
        return DatabaseNotFoundAppwriteError(message: e.message);
      case 'collection_not_found':
        _logger.debug('Mapping to CollectionNotFoundAppwriteError');
        return CollectionNotFoundAppwriteError(message: e.message);
      case 'document_not_found':
        _logger.debug('Mapping to DocumentNotFoundAppwriteError');
        return DocumentNotFoundAppwriteError(message: e.message);
      default:
        _logger.debug('Mapping to UnknownAppwriteError');
        return UnknownAppwriteError(
          type: e.type,
          code: e.code,
          message: e.message,
        );
    }
  }
}

class AppwriteDocumentReference extends Equatable {
  const AppwriteDocumentReference({
    required this.databaseId,
    required this.collectionId,
    required this.documentId,
  });

  final String databaseId;
  final String collectionId;
  final String documentId;

  @override
  List<Object?> get props => [
        databaseId,
        collectionId,
        documentId,
      ];
}

abstract class AppwriteConnectorFailure extends Equatable {}

class AppwriteConnectorUnexpectedFailure extends AppwriteConnectorFailure {
  AppwriteConnectorUnexpectedFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AppwriteConnectorAppwriteFailure extends AppwriteConnectorFailure {
  AppwriteConnectorAppwriteFailure(this.error);

  final AppwriteError error;

  @override
  List<Object?> get props => [error];
}

abstract class AppwriteError extends Equatable {
  const AppwriteError({
    this.message,
    this.type,
    this.code,
  });

  final String? message;
  final String? type;
  final int? code;

  @override
  String toString() {
    return 'AppwriteError{message: $message, type: $type, code: $code}';
  }

  @override
  List<Object?> get props => [
        message,
        type,
        code,
      ];
}

class UnknownAppwriteError extends AppwriteError {
  const UnknownAppwriteError({
    super.type,
    super.code,
    super.message,
  });
}

class GeneralArgumentInvalidAppwriteError extends AppwriteError {
  const GeneralArgumentInvalidAppwriteError({
    super.message,
  }) : super(
          type: 'general_argument_invalid',
          code: 400,
        );
}

class DatabaseNotFoundAppwriteError extends AppwriteError {
  const DatabaseNotFoundAppwriteError({
    super.message,
  }) : super(
          type: 'database_not_found',
          code: 404,
        );
}

class CollectionNotFoundAppwriteError extends AppwriteError {
  const CollectionNotFoundAppwriteError({
    super.message,
  }) : super(
          type: 'collection_not_found',
          code: 404,
        );
}

class DocumentNotFoundAppwriteError extends AppwriteError {
  const DocumentNotFoundAppwriteError({
    super.message,
  }) : super(
          type: 'document_not_found',
          code: 404,
        );
}
