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

  final TextFieldViewModel title;
  final TextFieldViewModel description;
  final String difficulty;
  final List<OptionFieldViewModel> options;

  @override
  List<Object?> get props => [
        title,
        description,
        difficulty,
        options,
      ];

  QuestionCreationViewModel copyWith({
    TextFieldViewModel? title,
    TextFieldViewModel? description,
    String? difficulty,
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
class TextFieldViewModel {
  const TextFieldViewModel({
    required this.value,
    required this.showErrorMessage,
  });

  final String value;
  final bool showErrorMessage;

  bool get isEmpty => value.isEmpty;

  TextFieldViewModel copyWith({
    String? value,
    bool? showErrorMessage,
  }) {
    return TextFieldViewModel(
      value: value ?? this.value,
      showErrorMessage: showErrorMessage ?? this.showErrorMessage,
    );
  }
}

@immutable
class OptionFieldViewModel {
  const OptionFieldViewModel({
    required this.textField,
    required this.isCorrect,
    required this.showErrorMessage,
  });

  final TextFieldViewModel textField;
  final bool isCorrect;
  final bool showErrorMessage;

  bool get isEmpty => textField.isEmpty;
}
