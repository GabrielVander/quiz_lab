import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import '../entities/question.dart';

abstract class QuestionRepository {
  Future<Result<Stream<Question>, QuestionRepositoryFailure>> watchAll();

  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(String id);

  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  );

  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  );
}

@immutable
abstract class QuestionRepositoryFailure {}

@immutable
class QuestionRepositoryLibraryFailure implements QuestionRepositoryFailure {
  const QuestionRepositoryLibraryFailure({
    required this.message,
  });

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionRepositoryLibraryFailure &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

@immutable
class QuestionRepositoryInvalidQuestionFailure
    implements QuestionRepositoryFailure {
  const QuestionRepositoryInvalidQuestionFailure({
    required this.message,
  });

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionRepositoryInvalidQuestionFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
