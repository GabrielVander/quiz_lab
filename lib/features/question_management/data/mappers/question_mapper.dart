import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';

import '../../domain/entities/question.dart';
import '../data_sources/models/hive_question_model.dart';

class QuestionMapper {
  Result<HiveQuestionModel, QuestionMapperFailure> mapEntityToHiveModel(
    Question question,
  ) {
    return Result.err(QuestionMapperFailure.unimplemented());
  }

  Result<Question, QuestionMapperFailure> mapHiveModelToEntity(
    HiveQuestionModel hiveModel,
  ) {
    return Result.err(QuestionMapperFailure.unimplemented());
  }
}

abstract class QuestionMapperFailure extends Equatable {
  const QuestionMapperFailure._({required this.message});

  factory QuestionMapperFailure.unimplemented() {
    return const _UnimplementedFailure._();
  }

  factory QuestionMapperFailure.unableToMapToHiveModel({
    required String message,
  }) =>
      UnableToMapToHiveModel._(message: message);

  factory QuestionMapperFailure.unableToMapHiveModelToEntity({
    required HiveQuestionModel model,
  }) =>
      UnableToMapHiveModelToEntity._(model: model);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class UnableToMapToHiveModel extends QuestionMapperFailure {
  const UnableToMapToHiveModel._({required super.message}) : super._();
}

class UnableToMapHiveModelToEntity extends QuestionMapperFailure {
  const UnableToMapHiveModelToEntity._({required this.model})
      : super._(message: 'Unable to map hive model to entity');

  final HiveQuestionModel model;

  @override
  List<Object> get props => super.props..addAll([model]);
}

class _UnimplementedFailure extends QuestionMapperFailure {
  const _UnimplementedFailure._() : super._(message: 'Unimplemented');
}
