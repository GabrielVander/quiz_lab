import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';

import '../entities/question.dart';
import '../repositories/question_repository.dart';

class WatchAllQuestionsUseCase {
  const WatchAllQuestionsUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Future<Result<Stream<Question>, WatchAllQuestionsFailure>> execute() async {
    final streamResult = await _questionRepository.watchAll();

    if (streamResult.isErr) {
      return Result.err(
        WatchAllQuestionsFailure.generic(message: streamResult.err!.message),
      );
    }

    return Result.ok(streamResult.ok!);
  }
}

@immutable
abstract class WatchAllQuestionsFailure extends Equatable {
  const WatchAllQuestionsFailure._({
    required this.message,
  });

  factory WatchAllQuestionsFailure.generic({
    required String message,
  }) {
    return _RepositoryFailure._(message: message);
  }

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}

@immutable
class _RepositoryFailure extends WatchAllQuestionsFailure {
  const _RepositoryFailure._({
    required super.message,
  }) : super._();
}
