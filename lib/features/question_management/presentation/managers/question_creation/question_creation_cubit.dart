import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation.dart';
import 'package:quiz_lab/generated/l10n.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState>
    implements Manager {
  QuestionCreationCubit({
    required this.createQuestionUseCase,
  }) : super(QuestionCreationInitial());

  final CreateQuestionUseCase createQuestionUseCase;

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

  Future<void> onShortDescriptionUpdate(
    BuildContext context,
    String newValue,
  ) async {
    _viewModel = _viewModel.copyWith(
      shortDescription: _viewModel.shortDescription.copyWith(value: newValue),
    );
    _viewModel = _validateShortDescription(context, _viewModel);

    emit(
      QuestionCreationDisplayUpdate(
        viewModel: _viewModel,
      ),
    );
  }

  Future<void> onDescriptionUpdate(
    BuildContext context,
    String newValue,
  ) async {
    _viewModel = _viewModel.copyWith(
      description: _viewModel.description.copyWith(
        value: newValue,
      ),
    );
    _viewModel = _validateDescription(context, _viewModel);

    emit(
      QuestionCreationDisplayUpdate(
        viewModel: _viewModel,
      ),
    );
  }

  Future<void> createQuestion(BuildContext context) async {
    emit(QuestionCreationState.loading());
    _emitValidatedFields(context);

    if (_isValid) {
      await _createQuestion();
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

  void _emitValidatedFields(BuildContext context) {
    final newViewModel = _validateFields(context, _viewModel);

    emit(QuestionCreationDisplayUpdate(viewModel: newViewModel));
  }

  QuestionCreationViewModel _validateFields(
    BuildContext context,
    QuestionCreationViewModel viewModel,
  ) {
    var copy = viewModel;

    copy = _validateShortDescription(context, copy);
    copy = _validateDescription(context, copy);

    _isValid = copy == viewModel;

    return copy;
  }

  QuestionCreationViewModel _validateDescription(
    BuildContext context,
    QuestionCreationViewModel viewModel,
  ) {
    if (_viewModel.description.value == '') {
      return viewModel.copyWith(
        description: viewModel.description.copyWith(
          hasError: true,
          errorMessage: S.of(context).mustBeSetMessage,
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
    BuildContext context,
    QuestionCreationViewModel viewModel,
  ) {
    if (viewModel.shortDescription.value == '') {
      return viewModel.copyWith(
        shortDescription: viewModel.shortDescription.copyWith(
          hasError: true,
          errorMessage: S.of(context).mustBeSetMessage,
        ),
      );
    }

    return viewModel.copyWith(
      shortDescription: viewModel.shortDescription.copyWith(
        hasError: false,
      ),
    );
  }

  Future<void> _createQuestion() async {
    final difficulties = [
      'easy',
      'medium',
      'hard',
    ]..shuffle();
    final randomDifficulty = difficulties.first;

    final creationResult = await createQuestionUseCase.execute(
      QuestionCreationInput(
        shortDescription: _viewModel.shortDescription.value,
        description: _viewModel.description.value,
        difficulty: randomDifficulty,
        categories: const ['Math', 'Algebra'],
      ),
    );

    if (creationResult.isErr) {
      emit(QuestionCreationState.failure(message: creationResult.err!.message));
      return;
    }

    emit(QuestionCreationState.success());
  }
}
