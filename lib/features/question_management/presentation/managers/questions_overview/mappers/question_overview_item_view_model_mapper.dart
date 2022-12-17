import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

class QuestionOverviewItemViewModelMapper {
  QuestionOverviewItemViewModel fromQuestionEntity(
    Question question,
  ) {
    return QuestionOverviewItemViewModel(
      id: question.id,
      shortDescription: question.shortDescription,
      description: question.description,
      categories: question.categories.map((c) => c.value).toList(),
      difficulty: question.difficulty.name,
    );
  }

  List<QuestionOverviewItemViewModel> fromQuestionEntities(
    List<Question> questions,
  ) {
    return questions.map(fromQuestionEntity).toList();
  }
}

abstract class QuestionOverviewItemViewModelMapperFailure extends Equatable {
  const QuestionOverviewItemViewModelMapperFailure._({required this.message});

  factory QuestionOverviewItemViewModelMapperFailure.unexpectedDifficultyValue({
    required String value,
  }) =>
      UnexpectedQuestionDifficultyValue._(value);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class UnexpectedQuestionDifficultyValue
    extends QuestionOverviewItemViewModelMapperFailure {
  const UnexpectedQuestionDifficultyValue._(this.value)
      : super._(message: 'Unable to map $value to a difficulty');

  final String value;

  @override
  List<Object> get props => super.props..addAll([value]);
}
