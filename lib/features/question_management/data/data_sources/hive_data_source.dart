import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import 'models/question_model.dart';

class HiveDataSource {
  HiveDataSource({required this.questionsBox});

  final Box<String> questionsBox;

  Future<Result<Unit, HiveDataSourceFailure>> saveQuestion(
    QuestionModel question,
  ) async {
    final idValidationResult = _validateId(question);

    if (idValidationResult.isErr) {
      return Result.err(idValidationResult.err!);
    }

    try {
      return Result.ok(await _putQuestionInBox(question));
    } on HiveError catch (e) {
      return Result.err(HiveDataSourceLibraryFailure(message: e.message));
    }
  }

  Future<Result<Unit, HiveDataSourceFailure>> deleteQuestion(
    QuestionModel question,
  ) async {
    final idValidationResult = _validateId(question);

    if (idValidationResult.isErr) {
      return Result.err(idValidationResult.err!);
    }

    try {
      return Result.ok(await _deleteQuestionFromBox(question));
    } on HiveError catch (e) {
      return Result.err(HiveDataSourceLibraryFailure(message: e.message));
    }
  }

  Future<Result<List<QuestionModel>, HiveDataSourceFailure>>
      getAllQuestions() async {
    throw UnimplementedError();
  }

  Result<Unit, HiveDataSourceInvalidIdFailure> _validateId(
    QuestionModel question,
  ) {
    if (question.id == null || question.id == '') {
      return Result.err(
        HiveDataSourceInvalidIdFailure(message: 'Empty id is not allowed'),
      );
    }

    return const Result.ok(unit);
  }

  Future<Unit> _putQuestionInBox(
    QuestionModel question,
  ) async {
    await questionsBox.put(question.id, jsonEncode(question.toMap()));

    return unit;
  }

  Future<Unit> _deleteQuestionFromBox(QuestionModel question) async {
    await questionsBox.delete(question.id);

    return unit;
  }
}

abstract class HiveDataSourceFailure {}

class HiveDataSourceLibraryFailure implements HiveDataSourceFailure {
  HiveDataSourceLibraryFailure({required this.message});

  final String message;
}

class HiveDataSourceInvalidIdFailure implements HiveDataSourceFailure {
  HiveDataSourceInvalidIdFailure({required this.message});

  final String message;
}
