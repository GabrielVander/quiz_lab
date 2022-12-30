import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class QuestionCreationViewModel extends Equatable {
  const QuestionCreationViewModel({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
  });

  final QuestionCreationTitleViewModel title;
  final QuestionCreationDescriptionViewModel description;
  final QuestionCreationDifficultyViewModel difficulty;
  final List<OptionFieldViewModel> options;

  @override
  List<Object?> get props => [
        title,
        description,
        difficulty,
        options,
      ];

  QuestionCreationViewModel copyWith({
    QuestionCreationTitleViewModel? title,
    QuestionCreationDescriptionViewModel? description,
    QuestionCreationDifficultyViewModel? difficulty,
    List<OptionFieldViewModel>? options,
  }) {
    return QuestionCreationViewModel(
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      options: options ?? this.options,
    );
  }
}

@immutable
abstract class _QuestionCreationTextFormFieldViewModel {
  const _QuestionCreationTextFormFieldViewModel._({
    required this.value,
    required this.showErrorMessage,
  });

  final String value;
  final bool showErrorMessage;

  bool get isEmpty => value.isEmpty;
}

@immutable
class QuestionCreationTitleViewModel
    extends _QuestionCreationTextFormFieldViewModel {
  const QuestionCreationTitleViewModel({
    required super.value,
    required super.showErrorMessage,
  }) : super._();

  QuestionCreationTitleViewModel copyWith({
    String? value,
    bool? showErrorMessage,
  }) {
    return QuestionCreationTitleViewModel(
      value: value ?? this.value,
      showErrorMessage: showErrorMessage ?? this.showErrorMessage,
    );
  }
}

@immutable
class QuestionCreationDescriptionViewModel
    extends _QuestionCreationTextFormFieldViewModel {
  const QuestionCreationDescriptionViewModel({
    required super.value,
    required super.showErrorMessage,
  }) : super._();

  QuestionCreationDescriptionViewModel copyWith({
    String? value,
    bool? showErrorMessage,
  }) {
    return QuestionCreationDescriptionViewModel(
      value: value ?? this.value,
      showErrorMessage: showErrorMessage ?? this.showErrorMessage,
    );
  }
}

@immutable
class QuestionCreationDifficultyValueViewModel
    extends _QuestionCreationTextFormFieldViewModel {
  const QuestionCreationDifficultyValueViewModel({
    required super.value,
    required super.showErrorMessage,
  }) : super._();

  QuestionCreationDifficultyValueViewModel copyWith({
    String? value,
    bool? showErrorMessage,
  }) {
    return QuestionCreationDifficultyValueViewModel(
      value: value ?? this.value,
      showErrorMessage: showErrorMessage ?? this.showErrorMessage,
    );
  }
}

@immutable
class QuestionCreationDifficultyViewModel {
  const QuestionCreationDifficultyViewModel({
    required this.formField,
    required this.availableValues,
  });

  final QuestionCreationDifficultyValueViewModel formField;
  final List<String> availableValues;

  bool get isEmpty => formField.isEmpty;

  bool get showErrorMessage => formField.showErrorMessage;

  QuestionCreationDifficultyViewModel copyWith({
    QuestionCreationDifficultyValueViewModel? formField,
    List<String>? availableValues,
  }) {
    return QuestionCreationDifficultyViewModel(
      formField: formField ?? this.formField,
      availableValues: availableValues ?? this.availableValues,
    );
  }
}

@immutable
class OptionFieldViewModel {
  const OptionFieldViewModel({
    required this.textField,
    required this.isCorrect,
  });

  final _QuestionCreationTextFormFieldViewModel textField;
  final bool isCorrect;

  bool get isEmpty => textField.isEmpty;

  bool get showErrorMessage => textField.showErrorMessage;
}
