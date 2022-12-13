import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class CreateQuestionUseCase {
  const CreateQuestionUseCase({
    required this.questionRepository,
  });

  final QuestionRepository questionRepository;

  Future<Result<Unit, CreateQuestionUseCaseFailure>> execute(
    QuestionCreationInput input,
  ) async {
    final inputParsingResult = _parseInputToEntity(input);

    if (inputParsingResult.isErr) {
      return Result.err(inputParsingResult.err!);
    }

    final creationResult =
        await questionRepository.createSingle(inputParsingResult.ok!);

    return creationResult.mapErr(
      (error) => CreateQuestionUseCaseFailure.unableToCreate(
        receivedInput: input,
        message: error.message,
      ),
    );
  }

  Result<Question, _InputParseFailure> _parseInputToEntity(
    QuestionCreationInput input,
  ) {
    final difficultyParseResult = _difficultyFromInput(input);

    if (difficultyParseResult.isErr) {
      return Result.err(difficultyParseResult.err!);
    }

    return Result.ok(
      Question(
        shortDescription: input.shortDescription,
        description: input.description,
        answerOptions: const [],
        difficulty: difficultyParseResult.ok!,
        categories:
            input.categories.map((e) => QuestionCategory(value: e)).toList(),
      ),
    );
  }

  Result<QuestionDifficulty, _InputParseFailure> _difficultyFromInput(
    QuestionCreationInput input,
  ) {
    final mappings = {
      'easy': QuestionDifficulty.easy,
      'medium': QuestionDifficulty.medium,
      'hard': QuestionDifficulty.hard,
    };

    if (mappings.containsKey(input.difficulty)) {
      return Result.ok(mappings[input.difficulty]!);
    } else {
      return Result.err(
        _InputParseFailure.difficulty(receivedValue: input.difficulty),
      );
    }
  }
}

@immutable
class QuestionCreationInput extends Equatable {
  const QuestionCreationInput({
    required this.shortDescription,
    required this.description,
    required this.difficulty,
    required this.categories,
  });

  final String shortDescription;
  final String description;
  final String difficulty;
  final List<String> categories;

  @override
  List<Object> get props => [
        shortDescription,
        description,
        difficulty,
        categories,
      ];

  @override
  bool get stringify => true;
}

@immutable
abstract class CreateQuestionUseCaseFailure extends Equatable {
  const CreateQuestionUseCaseFailure._({required this.message});

  factory CreateQuestionUseCaseFailure.unableToCreate({
    required QuestionCreationInput receivedInput,
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

  final QuestionCreationInput receivedInput;

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
  const DifficultyParseFailure._({required super.receivedValue})
      : super._(fieldName: 'difficulty');
}
