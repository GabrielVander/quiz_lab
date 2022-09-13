import 'package:equatable/equatable.dart';

class QuestionListViewModel extends Equatable {
  const QuestionListViewModel({
    required this.questions,
  });

  final List<QuestionOverviewViewModel> questions;

  @override
  String toString() {
    return 'QuestionListViewModel{ '
        'questions: $questions, '
        '}';
  }

  QuestionListViewModel copyWith({
    List<QuestionOverviewViewModel>? questions,
  }) {
    return QuestionListViewModel(
      questions: questions ?? this.questions,
    );
  }

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
  String toString() {
    return 'QuestionOverviewViewModel{ '
        'id: $id, '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'category: $categories, '
        '}';
  }

  QuestionOverviewViewModel copyWith({
    String? id,
    String? shortDescription,
    String? description,
    List<QuestionCategoryViewModel>? categories,
    QuestionDifficultyViewModel? difficulty,
    List<OptionViewModel>? options,
  }) {
    return QuestionOverviewViewModel(
      id: id ?? this.id,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      difficulty: difficulty ?? this.difficulty,
    );
  }

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
  String toString() {
    return 'OptionViewModel{ '
        'description: $description, '
        'isCorrect: $isCorrect, '
        '}';
  }

  OptionViewModel copyWith({
    String? description,
    bool? isCorrect,
  }) {
    return OptionViewModel(
      description: description ?? this.description,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

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
  String toString() {
    return 'ShowShortDescriptionViewModel{ '
        'id: $id, '
        'shortDescription: $shortDescription, '
        '}';
  }

  ShowShortDescriptionViewModel copyWith({
    String? id,
    String? shortDescription,
  }) {
    return ShowShortDescriptionViewModel(
      id: id ?? this.id,
      shortDescription: shortDescription ?? this.shortDescription,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
      ];
}
