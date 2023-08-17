import 'package:equatable/equatable.dart';

class QuestionCategory extends Equatable {
  const QuestionCategory({
    required this.value,
  });

  final String value;

  QuestionCategory copyWith({
    String? value,
  }) =>
      QuestionCategory(value: value ?? this.value);

  @override
  String toString() {
    return 'QuestionCategory{ '
        'value: $value, '
        '}';
  }

  @override
  List<Object?> get props => [value];
}
