import 'package:flutter/foundation.dart';

@immutable
class QuestionCreationViewModel {
  const QuestionCreationViewModel({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.message,
    required this.showMessage,
    required this.addOptionButtonEnabled,
  });

  final QuestionCreationTitleViewModel title;
  final QuestionCreationDescriptionViewModel description;
  final QuestionCreationDifficultyViewModel difficulty;
  final List<QuestionCreationOptionViewModel> options;
  final QuestionCreationMessageViewModel? message;
  final bool showMessage;
  final bool addOptionButtonEnabled;

  bool get areFieldsValid =>
      !title.isEmpty &&
      !description.isEmpty &&
      !difficulty.isEmpty &&
      options.every((option) => !option.isEmpty);

  bool get hasAtLeastOneCorrectOption =>
      options.any((option) => option.isCorrect);

  QuestionCreationViewModel copyWith({
    QuestionCreationTitleViewModel? title,
    QuestionCreationDescriptionViewModel? description,
    QuestionCreationDifficultyViewModel? difficulty,
    List<QuestionCreationOptionViewModel>? options,
    QuestionCreationMessageViewModel? message,
    bool? showMessage,
    bool? addOptionButtonEnabled,
  }) {
    return QuestionCreationViewModel(
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      options: options ?? this.options,
      message: message ?? this.message,
      showMessage: showMessage ?? this.showMessage,
      addOptionButtonEnabled:
          addOptionButtonEnabled ?? this.addOptionButtonEnabled,
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
class QuestionCreationOptionValueViewModel
    extends _QuestionCreationTextFormFieldViewModel {
  const QuestionCreationOptionValueViewModel({
    required super.value,
    required super.showErrorMessage,
  }) : super._();

  QuestionCreationOptionValueViewModel copyWith({
    String? value,
    bool? showErrorMessage,
  }) {
    return QuestionCreationOptionValueViewModel(
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
class QuestionCreationOptionViewModel {
  const QuestionCreationOptionViewModel({
    required this.id,
    required this.formField,
    required this.isCorrect,
  });

  final String id;
  final QuestionCreationOptionValueViewModel formField;
  final bool isCorrect;

  bool get isEmpty => formField.isEmpty;

  bool get showErrorMessage => formField.showErrorMessage;

  QuestionCreationOptionViewModel copyWith({
    String? id,
    QuestionCreationOptionValueViewModel? formField,
    bool? isCorrect,
  }) {
    return QuestionCreationOptionViewModel(
      id: id ?? this.id,
      formField: formField ?? this.formField,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

@immutable
class QuestionCreationMessageViewModel {
  const QuestionCreationMessageViewModel({
    required this.type,
    required this.isFailure,
    required this.details,
  });

  final QuestionCreationMessageType type;
  final bool isFailure;
  final String? details;
}

enum QuestionCreationMessageType {
  noCorrectOption,
  questionSavedSuccessfully,
  unableToSaveQuestion,
}
