import 'package:equatable/equatable.dart';

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
