import 'package:equatable/equatable.dart';

class QuestionOverviewItemViewModel extends Equatable {
  const QuestionOverviewItemViewModel({
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

  QuestionOverviewItemViewModel copyWith({
    String? id,
    String? shortDescription,
    String? description,
    List<String>? categories,
    String? difficulty,
  }) {
    return QuestionOverviewItemViewModel(
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

  @override
  bool get stringify => true;
}
