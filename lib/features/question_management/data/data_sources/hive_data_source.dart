import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import 'models/question_model.dart';

class HiveDataSource {
  HiveDataSource({required Box<String> questionsBox})
      : _questionsBox = questionsBox;

  final Box<String> _questionsBox;

  Future<Result<Unit, HiveDataSourceFailure>> saveQuestion(
    HiveQuestionModel question,
  ) async {
    final idValidationResult = _validateId(question);

    if (idValidationResult.isErr) {
      return Result.err(idValidationResult.err!);
    }

    try {
      return Result.ok(await _putQuestionInBox(question));
    } on HiveError catch (e) {
      return Result.err(
        HiveDataSourceFailure.libraryFailure(message: e.message),
      );
    }
  }

  Future<Result<Unit, HiveDataSourceFailure>> deleteQuestion(
    HiveQuestionModel question,
  ) async {
    final idValidationResult = _validateId(question);

    if (idValidationResult.isErr) {
      return Result.err(idValidationResult.err!);
    }

    try {
      return Result.ok(await _deleteQuestionFromBox(question));
    } on HiveError catch (e) {
      return Result.err(
        HiveDataSourceFailure.libraryFailure(message: e.message),
      );
    }
  }

  Future<Result<Stream<HiveQuestionModel>, HiveDataSourceFailure>>
      watchAllQuestions() async {
    try {
      return Result.ok(await _getAllQuestionsFromBox());
    } on HiveError catch (e) {
      return Result.err(
        HiveDataSourceFailure.libraryFailure(message: e.message),
      );
    }
  }

  Result<Unit, HiveDataSourceFailure> _validateId(
    HiveQuestionModel question,
  ) {
    if (question.id == null || question.id == '') {
      return Result.err(
        HiveDataSourceFailure.invalidId(message: 'Empty id is not allowed'),
      );
    }

    return const Result.ok(unit);
  }

  Future<Unit> _putQuestionInBox(
    HiveQuestionModel question,
  ) async {
    final questionAsMap = question.toMap();
    await _questionsBox.put(question.id, _encodeMap(questionAsMap));

    return unit;
  }

  Future<Unit> _deleteQuestionFromBox(HiveQuestionModel question) async {
    await _questionsBox.delete(question.id);

    return unit;
  }

  Future<Stream<HiveQuestionModel>> _getAllQuestionsFromBox() async {
    return _questionsBox
        .watch()
        .where((event) => !event.deleted)
        .map(_mapBoxEventToQuestion);
  }

  HiveQuestionModel _mapBoxEventToQuestion(BoxEvent event) {
    final key = event.key as String;
    final encodedMapString = event.value! as String;

    return HiveQuestionModel.fromMap(
      key,
      _decodeMapFromString(encodedMapString),
    );
  }

  String _encodeMap(Map<String, dynamic> questionAsMap) =>
      jsonEncode(questionAsMap);

  Map<String, dynamic> _decodeMapFromString(String encodedMapString) =>
      jsonDecode(encodedMapString) as Map<String, dynamic>;
}

@immutable
abstract class HiveDataSourceFailure {
  const HiveDataSourceFailure._({required this.message});

  factory HiveDataSourceFailure.libraryFailure({
    required String message,
  }) =>
      HiveDataSourceLibraryFailure._(message: message);

  factory HiveDataSourceFailure.invalidId({
    required String message,
  }) =>
      HiveDataSourceInvalidIdFailure._(message: message);

  final String message;
}

class HiveDataSourceLibraryFailure extends HiveDataSourceFailure {
  const HiveDataSourceLibraryFailure._({required super.message}) : super._();
}

class HiveDataSourceInvalidIdFailure extends HiveDataSourceFailure {
  const HiveDataSourceInvalidIdFailure._({required super.message}) : super._();
}
