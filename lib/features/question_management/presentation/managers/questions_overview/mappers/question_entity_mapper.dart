import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/questions_overview_view_model.dart';

class QuestionEntityMapper {
  final _difficulties = {
    'easy': QuestionDifficulty.easy,
    'medium': QuestionDifficulty.medium,
    'hard': QuestionDifficulty.hard,
    'unknown': QuestionDifficulty.unknown,
  };

  Result<Question, QuestionEntityMapperFailure>
      singleFromQuestionOverviewItemViewModel(
    QuestionsOverviewItemViewModel viewModel,
  ) {
    if (!_validateDifficulty(viewModel.difficulty)) {
      return Result.err(
        QuestionEntityMapperFailure.unexpectedDifficultyValue(
          value: viewModel.difficulty,
        ),
      );
    }

    return Result.ok(
      Question(
        id: QuestionId(viewModel.id),
        shortDescription: viewModel.shortDescription,
        description: viewModel.description,
        categories: viewModel.categories
            .map((c) => QuestionCategory(value: c))
            .toList(),
        difficulty: _difficulties[viewModel.difficulty]!,
        answerOptions: const [],
      ),
    );
  }

  bool _validateDifficulty(String difficulty) {
    return _difficulties.containsKey(difficulty);
  }
}

abstract class QuestionEntityMapperFailure extends Equatable {
  const QuestionEntityMapperFailure._({required this.message});

  factory QuestionEntityMapperFailure.unexpectedDifficultyValue({
    required String value,
  }) =>
      UnexpectedQuestionDifficultyValue._(value);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class UnexpectedQuestionDifficultyValue extends QuestionEntityMapperFailure {
  const UnexpectedQuestionDifficultyValue._(this.value)
      : super._(message: 'Unable to map $value to a difficulty');

  final String value;

  @override
  List<Object> get props => super.props..addAll([value]);
}
