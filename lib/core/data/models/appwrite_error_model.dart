import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';

sealed class AppwriteErrorModel extends Equatable {
  const AppwriteErrorModel({
    this.message,
    this.type,
    this.code,
  });

  factory AppwriteErrorModel.fromAppwriteException(AppwriteException exception) {
    switch (exception.type) {
      case 'general_argument_invalid':
        return GeneralArgumentInvalidAppwriteErrorModel(message: exception.message);
      case 'database_not_found':
        return DatabaseNotFoundAppwriteErrorModel(message: exception.message);
      case 'collection_not_found':
        return CollectionNotFoundAppwriteErrorModel(message: exception.message);
      case 'document_not_found':
        return DocumentNotFoundAppwriteErrorModel(message: exception.message);
      default:
        return UnknownAppwriteErrorModel(
          type: exception.type,
          code: exception.code,
          message: exception.message,
        );
    }
  }

  final String? message;
  final String? type;
  final int? code;

  @override
  String toString() {
    return 'AppwriteErrorModel{message: $message, type: $type, code: $code}';
  }

  @override
  List<Object?> get props => [
        message,
        type,
        code,
      ];
}

class UnknownAppwriteErrorModel extends AppwriteErrorModel {
  const UnknownAppwriteErrorModel({
    super.type,
    super.code,
    super.message,
  });
}

class GeneralArgumentInvalidAppwriteErrorModel extends AppwriteErrorModel {
  const GeneralArgumentInvalidAppwriteErrorModel({
    super.message,
  }) : super(
          type: 'general_argument_invalid',
          code: 400,
        );
}

class DatabaseNotFoundAppwriteErrorModel extends AppwriteErrorModel {
  const DatabaseNotFoundAppwriteErrorModel({
    super.message,
  }) : super(
          type: 'database_not_found',
          code: 404,
        );
}

class CollectionNotFoundAppwriteErrorModel extends AppwriteErrorModel {
  const CollectionNotFoundAppwriteErrorModel({
    super.message,
  }) : super(
          type: 'collection_not_found',
          code: 404,
        );
}

class DocumentNotFoundAppwriteErrorModel extends AppwriteErrorModel {
  const DocumentNotFoundAppwriteErrorModel({
    super.message,
  }) : super(
          type: 'document_not_found',
          code: 404,
        );
}
