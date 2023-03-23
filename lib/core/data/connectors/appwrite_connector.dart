import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';

class AppwriteConnector {
  AppwriteConnector({
    required Databases databases,
  }) : _databases = databases;

  final Databases _databases;

  Future<Result<Unit, AppwriteConnectorFailure>> deleteDocument(
    AppwriteDocumentReference reference,
  ) async {
    try {
      return await _performDocumentDeletion(reference);
    } on AppwriteException catch (e) {
      final appwriteError = _mapAppwriteExceptionToAppwriteError(e);

      return Result.err(AppwriteConnectorAppwriteFailure(appwriteError));
    } on Exception catch (e) {
      return Result.err(AppwriteConnectorUnexpectedFailure(e.toString()));
    }
  }

  Future<Result<Unit, AppwriteConnectorFailure>> _performDocumentDeletion(
    AppwriteDocumentReference reference,
  ) async {
    await _databases.deleteDocument(
      databaseId: reference.databaseId,
      collectionId: reference.collectionId,
      documentId: reference.documentId,
    );

    return const Result.ok(unit);
  }

  AppwriteError _mapAppwriteExceptionToAppwriteError(AppwriteException e) {
    switch (e.type) {
      case 'general_argument_invalid':
        return GeneralArgumentInvalidAppwriteError(message: e.message);
      case 'database_not_found':
        return DatabaseNotFoundAppwriteError(message: e.message);
      case 'collection_not_found':
        return CollectionNotFoundAppwriteError(message: e.message);
      case 'document_not_found':
        return DocumentNotFoundAppwriteError(message: e.message);
      default:
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
