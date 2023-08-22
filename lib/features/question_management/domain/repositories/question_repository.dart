import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';

abstract interface class QuestionRepository {
  Future<Result<Unit, String>> createSingle(DraftQuestion question);

  Future<Result<Stream<List<Question>>, QuestionRepositoryFailure>> watchAll();

  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  );

  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(QuestionId id);

  Future<Result<Question, QuestionRepositoryFailure>> getSingle(QuestionId id);
}

@immutable
sealed class QuestionRepositoryFailure extends Equatable {
  const QuestionRepositoryFailure._({required this.message});

  factory QuestionRepositoryFailure.unableToParseEntity({
    required String message,
  }) =>
      UnableToParseEntity._(message: message);

  factory QuestionRepositoryFailure.unableToCreate({
    required Question question,
    required String message,
  }) =>
      UnableToCreateQuestion._(question: question, message: message);

  factory QuestionRepositoryFailure.unableToWatchAll({
    required String message,
  }) =>
      UnableToWatchAllQuestions._(message: message);

  factory QuestionRepositoryFailure.unableToUpdate({
    required String id,
    required String details,
  }) =>
      UnableToUpdateQuestion._(id: id, details: details);

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
  const UnableToCreateQuestion._({
    required this.question,
    required super.message,
  }) : super._();

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
  const UnableToUpdateQuestion._({required this.id, required String details})
      : super._(
          message: 'Unable to update question with id $id: $details',
        );

  final String id;

  @override
  List<Object> get props => super.props..addAll([id]);
}

@immutable
class QuestionRepositoryUnexpectedFailure extends QuestionRepositoryFailure {
  const QuestionRepositoryUnexpectedFailure({required super.message}) : super._();
}

@immutable
class QuestionRepositoryExternalServiceErrorFailure extends QuestionRepositoryFailure {
  const QuestionRepositoryExternalServiceErrorFailure({required super.message}) : super._();
}
