import 'package:equatable/equatable.dart';

class AnswerOption extends Equatable {
  const AnswerOption({
    required this.description,
    required this.isCorrect,
  });

  final String description;
  final bool isCorrect;

  @override
  String toString() {
    return 'AnswerOption{ '
        'description: $description, '
        'isCorrect: $isCorrect, '
        '}';
  }

  AnswerOption copyWith({
    String? description,
    bool? isCorrect,
  }) {
    return AnswerOption(
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
