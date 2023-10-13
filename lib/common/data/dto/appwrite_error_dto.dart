import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';

sealed class AppwriteErrorDto extends Equatable {
  const AppwriteErrorDto({
    this.message,
    this.type,
    this.code,
  });

  factory AppwriteErrorDto.fromAppwriteException(AppwriteException exception) {
    switch (exception.type) {
      case 'general_argument_invalid':
        return GeneralArgumentInvalidAppwriteErrorDto(message: exception.message);
      case 'database_not_found':
        return DatabaseNotFoundAppwriteErrorDto(message: exception.message);
      case 'collection_not_found':
        return CollectionNotFoundAppwriteErrorDto(message: exception.message);
      case 'document_not_found':
        return DocumentNotFoundAppwriteErrorDto(message: exception.message);
      default:
        return UnknownAppwriteErrorDto(
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
    return 'AppwriteErrorDto{message: $message, type: $type, code: $code}';
  }

  @override
  List<Object?> get props => [
        message,
        type,
        code,
      ];
}

class UnknownAppwriteErrorDto extends AppwriteErrorDto {
  const UnknownAppwriteErrorDto({
    super.type,
    super.code,
    super.message,
  });
}

class GeneralArgumentInvalidAppwriteErrorDto extends AppwriteErrorDto {
  const GeneralArgumentInvalidAppwriteErrorDto({
    super.message,
  }) : super(
          type: 'general_argument_invalid',
          code: 400,
        );
}

class DatabaseNotFoundAppwriteErrorDto extends AppwriteErrorDto {
  const DatabaseNotFoundAppwriteErrorDto({
    super.message,
  }) : super(
          type: 'database_not_found',
          code: 404,
        );
}

class CollectionNotFoundAppwriteErrorDto extends AppwriteErrorDto {
  const CollectionNotFoundAppwriteErrorDto({
    super.message,
  }) : super(
          type: 'collection_not_found',
          code: 404,
        );
}

class DocumentNotFoundAppwriteErrorDto extends AppwriteErrorDto {
  const DocumentNotFoundAppwriteErrorDto({
    super.message,
  }) : super(
          type: 'document_not_found',
          code: 404,
        );
}
