import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class QuestionCreationViewModel extends Equatable {
  const QuestionCreationViewModel({
    required this.shortDescription,
    required this.description,
    required this.options,
  });

  final FieldViewModel shortDescription;
  final FieldViewModel description;
  final OptionsViewModel options;

  @override
  String toString() {
    return 'QuestionCreationViewModel{ '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'options: $options, '
        '}';
  }

  QuestionCreationViewModel copyWith({
    FieldViewModel? shortDescription,
    FieldViewModel? description,
    OptionsViewModel? options,
  }) {
    return QuestionCreationViewModel(
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [
        shortDescription,
        description,
        options,
      ];
}

class OptionsViewModel extends Equatable {
  const OptionsViewModel({
    required this.optionViewModels,
  });

  final List<SingleOptionViewModel> optionViewModels;

  @override
  String toString() {
    return 'OptionsViewModel{ '
        'optionViewModels: $optionViewModels, '
        '}';
  }

  OptionsViewModel copyWith({
    List<SingleOptionViewModel>? optionViewModels,
  }) {
    return OptionsViewModel(
      optionViewModels: optionViewModels ?? this.optionViewModels,
    );
  }

  @override
  List<Object?> get props => [
        optionViewModels,
      ];
}

class SingleOptionViewModel extends Equatable {
  SingleOptionViewModel({
    required this.fieldViewModel,
    required this.isCorrect,
  });

  final UniqueKey id = UniqueKey();
  final FieldViewModel fieldViewModel;
  final bool isCorrect;

  @override
  String toString() {
    return 'SingleOptionViewModel{ '
        'id: $id, '
        'fieldViewModel: $fieldViewModel, '
        'isCorrect: $isCorrect, '
        '}';
  }

  SingleOptionViewModel copyWith({
    FieldViewModel? fieldViewModel,
    bool? isCorrect,
  }) {
    return SingleOptionViewModel(
      fieldViewModel: fieldViewModel ?? this.fieldViewModel,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fieldViewModel,
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
