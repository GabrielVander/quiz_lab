import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import '../entities/question.dart';

abstract class QuestionRepository {
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  );

  Future<Result<Stream<Question>, QuestionRepositoryFailure>> watchAll();

  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  );

  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(String id);
}

@immutable
abstract class QuestionRepositoryFailure extends Equatable {
  const QuestionRepositoryFailure._({required this.message});

  factory QuestionRepositoryFailure.unableToParseEntity({
    required String message,
  }) =>
      UnableToParseEntity._(message: message);

  factory QuestionRepositoryFailure.unableToCreate({
    required Question question,
  }) =>
      UnableToCreateQuestion._(question: question);

  factory QuestionRepositoryFailure.unableToWatchAll({
    required String message,
  }) =>
      UnableToWatchAllQuestions._(message: message);

  factory QuestionRepositoryFailure.unableToUpdate({
    required Question question,
  }) =>
      UnableToUpdateQuestion._(question: question);

  factory QuestionRepositoryFailure.unableToDelete({
    required String id,
  }) =>
      UnableToDelete._(id: id);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

@immutable
class UnableToParseEntity extends QuestionRepositoryFailure {
  const UnableToParseEntity._({required super.message}) : super._();
}

@immutable
class UnableToCreateQuestion extends QuestionRepositoryFailure {
  const UnableToCreateQuestion._({required this.question})
      : super._(message: 'Unable to create question');

  final Question question;

  @override
  List<Object> get props => super.props..addAll([question]);
}

@immutable
class UnableToWatchAllQuestions extends QuestionRepositoryFailure {
  const UnableToWatchAllQuestions._({required super.message}) : super._();
}

@immutable
class UnableToUpdateQuestion extends QuestionRepositoryFailure {
  const UnableToUpdateQuestion._({required this.question})
      : super._(message: 'Unable to create question');

  final Question question;

  @override
  List<Object> get props => super.props..addAll([question]);
}

@immutable
class UnableToDelete extends QuestionRepositoryFailure {
  const UnableToDelete._({required this.id})
      : super._(message: 'Unable to delete question with id: $id');

  final String id;

  @override
  List<Object> get props => super.props..addAll([id]);
}
