class QuestionCategory {
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
    return QuestionCategory(
      value: value ?? this.value,
    );
  }
}
