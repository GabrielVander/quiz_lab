import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';

class WatchAllQuestionsUseCase {
  const WatchAllQuestionsUseCase({
    required RepositoryFactory repositoryFactory,
  }) : _repositoryFactory = repositoryFactory;

  final RepositoryFactory _repositoryFactory;

  Result<Stream<List<Question>>, WatchAllQuestionsFailure> execute() {
    final questionRepository = _repositoryFactory.makeQuestionRepository();
    final streamResult = questionRepository.watchAll();

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
