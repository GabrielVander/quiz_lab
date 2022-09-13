import 'package:equatable/equatable.dart';

class QuestionListViewModel extends Equatable {
  const QuestionListViewModel({
    required this.questions,
  });

  final List<QuestionOverviewViewModel> questions;

  @override
  List<Object?> get props => [
        questions,
      ];
}

class QuestionOverviewViewModel extends Equatable {
  const QuestionOverviewViewModel({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.categories,
    required this.difficulty,
  });

  final String id;
  final String shortDescription;
  final String description;
  final List<QuestionCategoryViewModel> categories;
  final QuestionDifficultyViewModel difficulty;

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        categories,
        difficulty,
      ];
}

class QuestionCategoryViewModel {
  const QuestionCategoryViewModel({required this.value});

  final String value;
}

class QuestionDifficultyViewModel {
  const QuestionDifficultyViewModel({required this.value});

  final String value;
}

class OptionViewModel extends Equatable {
  const OptionViewModel({
    required this.description,
    required this.isCorrect,
  });

  final String description;
  final bool isCorrect;

  @override
  List<Object?> get props => [
        description,
        isCorrect,
      ];
}

class ShowShortDescriptionViewModel extends Equatable {
  const ShowShortDescriptionViewModel({
    required this.id,
    required this.shortDescription,
  });

  final String id;
  final String shortDescription;

  @override
  List<Object?> get props => [
        id,
        shortDescription,
      ];
}
