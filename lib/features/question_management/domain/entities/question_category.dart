import 'package:equatable/equatable.dart';

class QuestionCategory extends Equatable {
  const QuestionCategory({
    required this.value,
  });

  final String value;

  @override
  String toString() {
    return 'QuestionCategory{ '
        'value: $value, '
        '}';
  }

  QuestionCategory copyWith({
    String? value,
  }) {
    return QuestionCategory(value: value ?? this.value);
  }

  @override
  List<Object?> get props => [
        value,
      ];
}
