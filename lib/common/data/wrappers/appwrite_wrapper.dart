import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:rust_core/result.dart';

class AppwriteWrapper {
  AppwriteWrapper({
    required Databases databases,
  }) : _databases = databases;

  final QuizLabLogger _logger = QuizLabLoggerFactory.createLogger<AppwriteWrapper>();

  final Databases _databases;

  /// Appwrite Doc:
  ///
  /// Create a new Document. Before using this route, you should create a new
  /// collection resource using either a server integration API or directly from
  /// your database console.
  ///
  // Rate Limits
  // This endpoint is limited to 120 requests in every 1 minutes per IP address,
  // method and user account. We use rate limits to avoid service abuse by users
  // and as a security practice. Learn more about rate limiting.
  Future<Result<Document, AppwriteWrapperFailure>> createDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
    required Map<dynamic, dynamic> data,
    List<String>? permissions,
  }) async {
    _logger.debug('Creating Appwrite document...');

    try {
      final createdDocument = await _databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
        permissions: permissions,
      );

      _logger.debug('Appwrite document created successfully');
      return Ok(createdDocument);
    } on AppwriteException catch (e) {
      return Err(_handleAppwriteException(e));
    } catch (e) {
      return Err(_handleUnexpectedException(e));
    }
  }

  /// Appwrite Doc:
  ///
  /// Delete a document by its unique ID.
  ///
  // Rate Limits
  // This endpoint is limited to 60 requests in every 1 minutes per IP address,
  // method and user account. We use rate limits to avoid service abuse by users
  // and as a security practice.
  Future<Result<Unit, AppwriteWrapperFailure>> deleteDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
  }) async {
    _logger.debug('Deleting Appwrite document...');

    try {
      await _databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      _logger.debug('Document deleted successfully');
      return const Ok(unit);
    } on AppwriteException catch (e) {
      return Err(_handleAppwriteException(e));
    } catch (e) {
      return Err(_handleUnexpectedException(e));
    }
  }

  /// Appwrite Doc:
  ///
  /// Get a document by its unique ID. This endpoint response returns a JSON
  /// object with the document data.
  Future<Result<Document, AppwriteWrapperFailure>> getDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
  }) async {
    _logger.debug('Retrieving Appwrite document...');

    try {
      return Ok(
        await _databases.getDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
        ),
      );
    } on AppwriteException catch (e) {
      return Err(_handleAppwriteException(e));
    } catch (e) {
      return Err(_handleUnexpectedException(e));
    }
  }

  AppwriteWrapperFailure _handleAppwriteException(AppwriteException e) {
    _logger.error(e.toString());

    final appwriteError = _mapAppwriteExceptionToAppwriteError(e);

    return AppwriteWrapperServiceFailure(appwriteError);
  }

  AppwriteWrapperUnexpectedFailure _handleUnexpectedException(Object e) {
    _logger.error(e.toString());

    return AppwriteWrapperUnexpectedFailure(e.toString());
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

abstract class AppwriteWrapperFailure extends Equatable {}

class AppwriteWrapperUnexpectedFailure extends AppwriteWrapperFailure {
  AppwriteWrapperUnexpectedFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AppwriteWrapperServiceFailure extends AppwriteWrapperFailure {
  AppwriteWrapperServiceFailure(this.error);

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
