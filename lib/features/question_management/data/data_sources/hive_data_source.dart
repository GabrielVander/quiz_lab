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
    if (question.id == '') {
      return Result.err(
        HiveDataSourceInvalidKeyFailure(message: 'Empty key is not allowed'),
      );
    }

    try {
      return await _putQuestionInBox(question);
    } on HiveError catch (e) {
      return Result.err(HiveDataSourceHiveFailure(message: e.message));
    }
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

class HiveDataSourceInvalidKeyFailure implements HiveDataSourceFailure {
  HiveDataSourceInvalidKeyFailure({required this.message});

  final String message;
}
