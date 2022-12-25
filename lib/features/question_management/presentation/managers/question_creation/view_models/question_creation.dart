import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class QuestionCreationViewModel extends Equatable {
  const QuestionCreationViewModel({
    required this.shortDescription,
    required this.description,
  });

  final FieldViewModel shortDescription;
  final FieldViewModel description;

  QuestionCreationViewModel copyWith({
    FieldViewModel? shortDescription,
    FieldViewModel? description,
  }) {
    return QuestionCreationViewModel(
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        shortDescription,
        description,
      ];
}

class SingleOptionViewModel extends Equatable {
  SingleOptionViewModel({
    required this.value,
    required this.isCorrect,
    this.errorMessage,
  });

  final String id = const Uuid().v4();
  final String value;
  final bool isCorrect;
  final String? errorMessage;

  SingleOptionViewModel copyWith({
    String? value,
    bool? isCorrect,
    String? errorMessage,
  }) {
    return SingleOptionViewModel(
      value: value ?? this.value,
      isCorrect: isCorrect ?? this.isCorrect,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        value,
        isCorrect,
      ];
}

class FieldViewModel extends Equatable {
  const FieldViewModel({
    required this.value,
    required this.isEnabled,
    required this.hasError,
    this.errorMessage,
  });

  final String value;
  final bool isEnabled;
  final bool hasError;
  final String? errorMessage;

  @override
  String toString() {
    return 'FieldViewModel{ '
        'value: $value, '
        'isEnabled: $isEnabled, '
        'hasError: $hasError, '
        'errorMessage: $errorMessage, '
        '}';
  }

  FieldViewModel copyWith({
    String? value,
    bool? isEnabled,
    bool? hasError,
    String? errorMessage,
  }) {
    return FieldViewModel(
      value: value ?? this.value,
      isEnabled: isEnabled ?? this.isEnabled,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        value,
        isEnabled,
        hasError,
        errorMessage,
      ];
}
