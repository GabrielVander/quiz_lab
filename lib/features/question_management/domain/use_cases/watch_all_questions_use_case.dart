import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:rust_core/result.dart';
import 'package:rxdart/rxdart.dart';

class WatchAllQuestionsUseCase {
  WatchAllQuestionsUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuizLabLogger _logger = QuizLabLoggerFactory.createLogger<WatchAllQuestionsUseCase>();

  final QuestionRepository _questionRepository;

  Future<Result<Stream<List<Question>>, WatchAllQuestionsFailure>> execute() async {
    _logger.info('Watching all questions...');

    final streamResult = await _questionRepository.watchAll();

    if (streamResult.isErr()) {
      final failure = WatchAllQuestionsFailure.generic(
        message: streamResult.unwrapErr(),
      );

      _logger.error(failure.message);
      return Err(failure);
    }

    return Ok(
      streamResult.unwrap().doOnData(
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
