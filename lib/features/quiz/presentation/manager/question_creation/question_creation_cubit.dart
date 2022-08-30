import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_creation.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState> {
  QuestionCreationCubit() : super(QuestionCreationInitial());

  String _shortDescription = '';
  String _description = '';

  final QuestionCreationViewModel _viewModel = const QuestionCreationViewModel(
    shortDescription: FieldViewModel(
      value: '',
      isEnabled: true,
      hasError: false,
    ),
    description: FieldViewModel(
      value: '',
      isEnabled: true,
      hasError: false,
    ),
    options: OptionsViewModel(optionViewModels: []),
  );

  Future<void> update() async {
    emit(QuestionCreationDisplayUpdate(viewModel: _viewModel));
  }

  Future<void> onShortDescriptionUpdate(String newValue) async {
    _shortDescription = newValue;
    _emitValidatedFields();
  }

  Future<void> onDescriptionUpdate(String newValue) async {
    _description = newValue;
    _emitValidatedFields();
  }

  Future<void> createQuestion(BuildContext context) async {
    _emitValidatedFields();
  }

  void _emitValidatedFields() {
    final newViewModel = _validateFields(_viewModel);

    emit(QuestionCreationDisplayUpdate(viewModel: newViewModel));
  }

  QuestionCreationViewModel _validateFields(
    QuestionCreationViewModel viewModel,
  ) {
    var copy = viewModel;

    if (_shortDescription == '') {
      copy = copy.copyWith(
        shortDescription: copy.shortDescription.copyWith(
          hasError: true,
          errorMessage: 'Must Be Set',
        ),
      );
    } else {
      copy = copy.copyWith(
        shortDescription: copy.shortDescription.copyWith(
          hasError: false,
        ),
      );
    }

    if (_description == '') {
      copy = copy.copyWith(
        description: copy.description.copyWith(
          hasError: true,
          errorMessage: 'Must Be Set',
        ),
      );
    } else {
      copy = copy.copyWith(
        description: copy.description.copyWith(
          hasError: false,
        ),
      );
    }

    return copy;
  }
}
