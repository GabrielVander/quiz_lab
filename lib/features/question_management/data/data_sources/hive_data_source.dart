import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/json_parser.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/hive_question_dto.dart';

class HiveDataSource {
  HiveDataSource({
    required Box<String> questionsBox,
    required JsonParser<Map<String, dynamic>> jsonParser,
  })  : _jsonParser = jsonParser,
        _questionsBox = questionsBox;

  final Box<String> _questionsBox;
  final JsonParser<Map<String, dynamic>> _jsonParser;

  final _questionsStreamController = StreamController<List<HiveQuestionDto>>();

  Future<Result<Unit, HiveDataSourceFailure>> saveQuestion(
    HiveQuestionDto question,
  ) async {
    final idValidationResult = _validateId(question);

    if (idValidationResult.isErr) {
      return Err(idValidationResult.unwrapErr());
    }

    try {
      return Ok(await _putQuestionInBox(question));
      // ignore: avoid_catching_errors
    } on HiveError catch (e) {
      return Err(
        HiveDataSourceFailure.hiveError(message: e.message),
      );
    } on _JsonEncodeException catch (e) {
      return Err(
        HiveDataSourceFailure.jsonEncoding(message: e.details),
      );
    }
  }

  Future<Result<Unit, HiveDataSourceFailure>> deleteQuestion(
    HiveQuestionDto question,
  ) async {
    final idValidationResult = _validateId(question);

    if (idValidationResult.isErr) {
      return Err(idValidationResult.unwrapErr());
    }

    try {
      return Ok(await _deleteQuestionFromBox(question));
      // ignore: avoid_catching_errors
    } on HiveError catch (e) {
      return Err(
        HiveDataSourceFailure.hiveError(message: e.message),
      );
    }
  }

  Result<Stream<List<HiveQuestionDto>>, HiveDataSourceFailure> watchAllQuestions() {
    try {
      return Ok(_getAllQuestionsFromBox());
      // ignore: avoid_catching_errors
    } on HiveError catch (e) {
      return Err(
        HiveDataSourceFailure.hiveError(message: e.message),
      );
    } on _JsonDecodeException catch (e) {
      return Err(
        HiveDataSourceFailure.jsonDecoding(message: e.details),
      );
    }
  }

  Result<Unit, HiveDataSourceFailure> _validateId(
    HiveQuestionDto question,
  ) {
    if (question.id == null || question.id == '') {
      return Err(
        HiveDataSourceFailure.emptyId(),
      );
    }

    return const Ok(unit);
  }

  Future<Unit> _putQuestionInBox(
    HiveQuestionDto question,
  ) async {
    final questionAsMap = question.toMap();
    await _questionsBox.put(question.id, _encodeMap(questionAsMap));

    return unit;
  }

  Future<Unit> _deleteQuestionFromBox(HiveQuestionDto question) async {
    await _questionsBox.delete(question.id);

    return unit;
  }

  Stream<List<HiveQuestionDto>> _getAllQuestionsFromBox() {
    _updateQuestionStream();

    _questionsBox.watch().listen((_) => _updateQuestionStream());

    return _questionsStreamController.stream;
  }

  void _updateQuestionStream() {
    final questions = _getCurrentQuestions();

    _questionsStreamController.add(questions);
  }

  List<HiveQuestionDto> _getCurrentQuestions() {
    return _questionsBox.keys
        .map(
          (key) => HiveQuestionDto.fromMap(
            key as String,
            _decodeMapFromString(_questionsBox.get(key)!),
          ),
        )
        .toList();
  }

  String _encodeMap(Map<String, dynamic> questionAsMap) {
    return _jsonParser.encode(questionAsMap).when(
          ok: (s) => s,
          err: (err) => throw _JsonEncodeException(err.message),
        );
  }

  Map<String, dynamic> _decodeMapFromString(String encodedMapString) =>
      _jsonParser.decode(encodedMapString).when(
            ok: (m) => m,
            err: (err) => throw _JsonDecodeException(err.message),
          );
}

class _JsonEncodeException implements Exception {
  const _JsonEncodeException(this.details);

  final String details;
}

class _JsonDecodeException implements Exception {
  const _JsonDecodeException(this.details);

  final String details;
}

@immutable
abstract class HiveDataSourceFailure extends Equatable {
  const HiveDataSourceFailure._({required this.message});

  factory HiveDataSourceFailure.hiveError({
    required String message,
  }) =>
      _HiveLibraryFailure._(message: message);

  factory HiveDataSourceFailure.emptyId() => const _EmptyIdFailure._();

  factory HiveDataSourceFailure.jsonEncoding({required String message}) =>
      _JsonEncodingFailure._(message: message);

  factory HiveDataSourceFailure.jsonDecoding({required String message}) =>
      _JsonDecodingFailure._(message: message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class _HiveLibraryFailure extends HiveDataSourceFailure {
  const _HiveLibraryFailure._({required super.message}) : super._();
}

class _EmptyIdFailure extends HiveDataSourceFailure {
  const _EmptyIdFailure._() : super._(message: 'Empty id is not allowed');
}

class _JsonEncodingFailure extends HiveDataSourceFailure {
  const _JsonEncodingFailure._({required super.message}) : super._();
}

class _JsonDecodingFailure extends HiveDataSourceFailure {
  const _JsonDecodingFailure._({required super.message}) : super._();
}
