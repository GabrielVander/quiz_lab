import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:rxdart/rxdart.dart';

class WatchAllQuestionsUseCase {
  const WatchAllQuestionsUseCase({
    required QuizLabLogger logger,
    required RepositoryFactory repositoryFactory,
  })  : _logger = logger,
        _repositoryFactory = repositoryFactory;

  final QuizLabLogger _logger;
  final RepositoryFactory _repositoryFactory;

  Result<Stream<List<Question>>, WatchAllQuestionsFailure> execute() {
    _logger.info('Watching all questions...');

    final questionRepository = _repositoryFactory.makeQuestionRepository();
    final streamResult = questionRepository.watchAll();

    if (streamResult.isErr) {
      final failure = WatchAllQuestionsFailure.generic(
        message: streamResult.err!.message,
      );

      _logger.error(failure.message);
      return Result.err(failure);
    }

    return Result.ok(
      streamResult.ok!.doOnData(
            (questions) => _logger.info('Retrieved ${questions.length} questions'),
      ),
    );
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
