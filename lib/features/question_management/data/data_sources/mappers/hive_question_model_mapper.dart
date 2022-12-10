import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';

import '../../../domain/entities/question.dart';
import '../models/hive_question_model.dart';

class HiveQuestionModelMapper {
  Result<HiveQuestionModel, HiveQuestionModelMapperFailure> fromQuestion(
    Question question,
  ) {
    return Result.err(HiveQuestionModelMapperFailure.unimplemented());
  }
}

abstract class HiveQuestionModelMapperFailure extends Equatable {
  const HiveQuestionModelMapperFailure._({required this.message});

  factory HiveQuestionModelMapperFailure.unimplemented() {
    return const _UnimplementedFailure._();
  }

  factory HiveQuestionModelMapperFailure.unableToParseQuestion({
    required Question question,
  }) =>
      _UnableToParseQuestion._(question: question);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class _UnimplementedFailure extends HiveQuestionModelMapperFailure {
  const _UnimplementedFailure._() : super._(message: 'Unimplemented');
}

class _UnableToParseQuestion extends HiveQuestionModelMapperFailure {
  const _UnableToParseQuestion._({required this.question})
      : super._(message: 'Unable to parse question');

  final Question question;

  @override
  List<Object> get props => super.props..addAll([question]);
}
