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
  final List<String> categories;
  final String difficulty;

  QuestionOverviewViewModel copyWith({
    String? id,
    String? shortDescription,
    String? description,
    List<String>? categories,
    String? difficulty,
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
  String toString() {
    return 'QuestionOverviewViewModel{ '
        'id: $id, shortDescription: $shortDescription, '
        'description: $description, '
        'categories: $categories, '
        'difficulty: $difficulty, '
        '}';
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
