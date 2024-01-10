import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class CreateQuestionUseCase {
  Future<Result<Unit, String>> call(DraftQuestion draft);
}

class CreateQuestionUseCaseImpl implements CreateQuestionUseCase {
  const CreateQuestionUseCaseImpl({
    required this.logger,
    required this.questionRepository,
  });

  final QuizLabLogger logger;
  final QuestionRepository questionRepository;

  @override
  Future<Result<Unit, String>> call(DraftQuestion draft) async {
    logger.info('Executing...');

    return (await _createQuestion(draft)).inspect((_) => logger.info('Question created successfully'));
  }

  Future<Result<Unit, String>> _createQuestion(DraftQuestion draft) async =>
      (await questionRepository.createSingle(draft))
          .inspectErr(logger.error)
          .mapErr((_) => 'Unable to create question')
          .map((_) => unit);
}

@immutable
abstract class CreateQuestionUseCaseFailure extends Equatable {
  const CreateQuestionUseCaseFailure._({required this.message});

  factory CreateQuestionUseCaseFailure.unableToCreate({
    required DraftQuestion receivedInput,
    required String message,
  }) =>
      UnableToCreateQuestion._(receivedInput: receivedInput, message: message);

  factory CreateQuestionUseCaseFailure.unableToParseDifficulty({
    required String value,
  }) =>
      _InputParseFailure.difficulty(receivedValue: value);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

@immutable
class UnableToCreateQuestion extends CreateQuestionUseCaseFailure {
  const UnableToCreateQuestion._({
    required this.receivedInput,
    required super.message,
  }) : super._();

  final DraftQuestion receivedInput;

  @override
  List<Object> get props => super.props..addAll([receivedInput]);
}

@immutable
abstract class _InputParseFailure extends CreateQuestionUseCaseFailure {
  const _InputParseFailure._({
    required this.fieldName,
    required this.receivedValue,
  }) : super._(message: 'Unable to parse $fieldName from $receivedValue');

  factory _InputParseFailure.difficulty({
    required String receivedValue,
  }) =>
      DifficultyParseFailure._(receivedValue: receivedValue);

  final String fieldName;
  final String receivedValue;

  @override
  List<Object> get props => super.props..addAll([fieldName, receivedValue]);
}

@immutable
class DifficultyParseFailure extends _InputParseFailure {
  const DifficultyParseFailure._({required super.receivedValue}) : super._(fieldName: 'difficulty');
}
