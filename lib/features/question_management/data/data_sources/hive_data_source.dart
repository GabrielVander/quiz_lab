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
      return Result.err(idValidationResult.expectErr('Invalid question id'));
    }

    try {
      return await _putQuestionInBox(question);
    } on HiveError catch (e) {
      return Result.err(HiveDataSourceHiveFailure(message: e.message));
    }
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

  Future<Result<void, HiveDataSourceFailure>> deleteQuestion(
    QuestionModel question,
  ) async {
    throw UnimplementedError();
  }

  Future<Result<List<QuestionModel>, HiveDataSourceFailure>>
      getAllQuestions() async {
    throw UnimplementedError();
  }

  Future<Result<Unit, HiveDataSourceFailure>> _putQuestionInBox(
    QuestionModel question,
  ) async {
    await questionsBox.put(question.id, jsonEncode(question.toMap()));

    return const Result.ok(unit);
  }
}

abstract class HiveDataSourceFailure {}

class HiveDataSourceHiveFailure implements HiveDataSourceFailure {
  HiveDataSourceHiveFailure({required this.message});

  final String message;
}

class HiveDataSourceInvalidIdFailure implements HiveDataSourceFailure {
  HiveDataSourceInvalidIdFailure({required this.message});

  final String message;
}
