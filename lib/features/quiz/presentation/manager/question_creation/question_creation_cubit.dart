import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_creation.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState> {
  QuestionCreationCubit() : super(QuestionCreationInitial());

  bool _isValid = false;

  QuestionCreationViewModel _viewModel = const QuestionCreationViewModel(
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
    _viewModel = const QuestionCreationViewModel(
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
    emit(QuestionCreationDisplayUpdate(viewModel: _viewModel));
  }

  Future<void> onShortDescriptionUpdate(String newValue) async {
    _viewModel = _viewModel.copyWith(
      shortDescription: _viewModel.shortDescription.copyWith(value: newValue),
    );
    _viewModel = _validateShortDescription(_viewModel);

    emit(
      QuestionCreationDisplayUpdate(
        viewModel: _viewModel,
      ),
    );
  }

  Future<void> onDescriptionUpdate(String newValue) async {
    _viewModel = _viewModel.copyWith(
      description: _viewModel.description.copyWith(
        value: newValue,
      ),
    );
    _viewModel = _validateDescription(_viewModel);

    emit(
      QuestionCreationDisplayUpdate(
        viewModel: _viewModel,
      ),
    );
  }

  Future<void> createQuestion(BuildContext context) async {
    _emitValidatedFields();

    if (_isValid) {
      final db = FirebaseFirestore.instance;
      final difficulties = ['Hard', 'Medium', 'Easy']..shuffle();

      await db.collection('questions').add({
        'shortDescription': _viewModel.shortDescription.value,
        'description': _viewModel.description.value,
        'categories': ['Math', 'Algebra'],
        'difficulty': difficulties.first,
      }).then((_) => emit(QuestionCreationInitial()));
    }
  }

  void addOption() {
    _viewModel = _viewModel.copyWith(
      options: _viewModel.options.copyWith(
        optionViewModels: [
          ..._viewModel.options.optionViewModels,
          SingleOptionViewModel(
            fieldViewModel: const FieldViewModel(
              value: '',
              isEnabled: true,
              hasError: false,
            ),
            isCorrect: false,
          )
        ],
      ),
    );

    emit(QuestionCreationDisplayUpdate(viewModel: _viewModel));
  }

  void optionIsCorrect(SingleOptionViewModel viewModel) {
    _viewModel = _viewModel.copyWith(
      options: _viewModel.options.copyWith(
        optionViewModels: _viewModel.options.optionViewModels.map((element) {
          if (element.id == viewModel.id) {
            return element.copyWith(isCorrect: !element.isCorrect);
          }
          return element;
        }).toList(),
      ),
    );

    emit(QuestionCreationDisplayUpdate(viewModel: _viewModel));
  }

  void _emitValidatedFields() {
    final newViewModel = _validateFields(_viewModel);

    emit(QuestionCreationDisplayUpdate(viewModel: newViewModel));
  }

  QuestionCreationViewModel _validateFields(
    QuestionCreationViewModel viewModel,
  ) {
    var copy = viewModel;

    copy = _validateShortDescription(copy);
    copy = _validateDescription(copy);

    _isValid = copy == viewModel;

    return copy;
  }

  QuestionCreationViewModel _validateDescription(
    QuestionCreationViewModel viewModel,
  ) {
    if (_viewModel.description.value == '') {
      return viewModel.copyWith(
        description: viewModel.description.copyWith(
          hasError: true,
          errorMessage: 'Must Be Set',
        ),
      );
    }

    return viewModel.copyWith(
      description: viewModel.description.copyWith(
        hasError: false,
      ),
    );
  }

  QuestionCreationViewModel _validateShortDescription(
    QuestionCreationViewModel viewModel,
  ) {
    if (viewModel.shortDescription.value == '') {
      return viewModel.copyWith(
        shortDescription: viewModel.shortDescription.copyWith(
          hasError: true,
          errorMessage: 'Must Be Set',
        ),
      );
    }

    return viewModel.copyWith(
      shortDescription: viewModel.shortDescription.copyWith(
        hasError: false,
      ),
    );
  }
}
