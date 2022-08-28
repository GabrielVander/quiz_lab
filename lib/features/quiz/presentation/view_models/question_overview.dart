import 'package:equatable/equatable.dart';

class QuestionOverviewViewModel extends Equatable {
  const QuestionOverviewViewModel({
    required this.shortDescription,
    required this.description,
    required this.categories,
    required this.difficulty,
    required this.options,
  });

  final String shortDescription;
  final String description;
  final List<QuestionCategoryViewModel> categories;
  final QuestionDifficultyViewModel difficulty;
  final List<OptionViewModel> options;

  @override
  String toString() {
    return 'QuestionOverviewViewModel{ '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'category: $categories, '
        'options: $options, '
        '}';
  }

  QuestionOverviewViewModel copyWith({
    String? shortDescription,
    String? description,
    List<QuestionCategoryViewModel>? categories,
    QuestionDifficultyViewModel? difficulty,
    List<OptionViewModel>? options,
  }) {
    return QuestionOverviewViewModel(
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      difficulty: difficulty ?? this.difficulty,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [
        shortDescription,
        description,
        categories,
        difficulty,
        options,
      ];
}

enum QuestionCategoryViewModel {
  math(value: 'Math'),
  algebra(value: 'Algebra');

  const QuestionCategoryViewModel({required this.value});

  final String value;
}

enum QuestionDifficultyViewModel {
  easy(value: 'Easy'),
  medium(value: 'Medium'),
  hard(value: 'Hard');

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
