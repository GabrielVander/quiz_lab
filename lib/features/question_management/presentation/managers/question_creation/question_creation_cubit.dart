import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation_view_model.dart';
import 'package:uuid/uuid.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState> {
  QuestionCreationCubit({
    required QuizLabLogger logger,
    required UseCaseFactory useCaseFactory,
  })  : _logger = logger,
        _useCaseFactory = useCaseFactory,
        super(QuestionCreationState.initial());

  final QuizLabLogger _logger;
  final UseCaseFactory _useCaseFactory;
  late QuestionCreationViewModel _viewModel = _defaultViewModel;

  final QuestionCreationViewModel _defaultViewModel = QuestionCreationViewModel(
    title: const QuestionCreationTitleViewModel(
      value: '',
      showErrorMessage: false,
    ),
    description: const QuestionCreationDescriptionViewModel(
      value: '',
      showErrorMessage: false,
    ),
    difficulty: const QuestionCreationDifficultyViewModel(
      formField: QuestionCreationDifficultyValueViewModel(
        value: '',
        showErrorMessage: false,
      ),
      availableValues: [
        'easy',
        'medium',
        'hard',
      ],
    ),
    options: [
      QuestionCreationOptionViewModel(
        id: const Uuid().v4(),
        formField: const QuestionCreationOptionValueViewModel(
          value: '',
          showErrorMessage: false,
        ),
        isCorrect: false,
      ),
      QuestionCreationOptionViewModel(
        id: const Uuid().v4(),
        formField: const QuestionCreationOptionValueViewModel(
          value: '',
          showErrorMessage: false,
        ),
        isCorrect: false,
      ),
    ],
    addOptionButtonEnabled: true,
    message: null,
    showMessage: false,
  );

  void load() {
    _updateViewModel(_defaultViewModel);
  }

  void onTitleChanged(String newValue) {
    _logger.logInfo('Title changed');

    final newViewModel = _viewModel.copyWith(
      title: _viewModel.title.copyWith(
        value: newValue,
        showErrorMessage: true,
      ),
      showMessage: false,
    );

    _updateViewModel(newViewModel);
  }

  void onDescriptionChanged(String newValue) {
    _logger.logInfo('Description changed');

    final newViewModel = _viewModel.copyWith(
      description: _viewModel.description.copyWith(
        value: newValue,
        showErrorMessage: true,
      ),
      showMessage: false,
    );

    _updateViewModel(newViewModel);
  }

  void onDifficultyChanged(String? value) {
    _logger.logInfo('Difficulty changed');

    final newViewModel = _viewModel.copyWith(
      difficulty: _viewModel.difficulty.copyWith(
        formField: _viewModel.difficulty.formField.copyWith(
          value: value ?? '',
          showErrorMessage: true,
        ),
      ),
      showMessage: false,
    );

    _updateViewModel(newViewModel);
  }

  void onOptionChanged(String id, String value) {
    _logger.logInfo('Option changed');

    final newViewModel = _viewModel.copyWith(
      options: _viewModel.options.map(
        (option) {
          if (option.id == id) {
            return option.copyWith(
              formField: option.formField.copyWith(
                value: value,
                showErrorMessage: true,
              ),
            );
          }

          return option;
        },
      ).toList(),
      showMessage: false,
    );

    _updateViewModel(newViewModel);
  }

  void toggleOptionIsCorrect(String id) {
    _logger.logInfo('Option toggled');

    final newViewModel = _viewModel.copyWith(
      options: _viewModel.options.map(
        (option) {
          if (option.id == id) {
            return option.copyWith(
              isCorrect: !option.isCorrect,
            );
          }

          return option;
        },
      ).toList(),
      showMessage: false,
    );

    _updateViewModel(newViewModel);
  }

  void onAddOption() {
    _logger.logInfo('Adding option...');

    const optionsLimit = 5;

    if (_viewModel.options.length >= optionsLimit) {
      _logger.logInfo('Options limit reached');
      return;
    }

    final newViewModel = _viewModel.copyWith(
      options: [
        ..._viewModel.options,
        QuestionCreationOptionViewModel(
          id: const Uuid().v4(),
          formField: const QuestionCreationOptionValueViewModel(
            value: '',
            showErrorMessage: false,
          ),
          isCorrect: false,
        ),
      ],
      addOptionButtonEnabled: _viewModel.options.length + 1 < optionsLimit,
      showMessage: false,
    );

    _updateViewModel(newViewModel);
  }

  Future<void> onCreateQuestion() async {
    _logger.logInfo('Creating question...');

    final isValid = _validateFields();

    if (!isValid) {
      _logger.logWarning('Invalid fields');
      return;
    }

    await _createQuestion();
  }

  void _updateViewModel(QuestionCreationViewModel newViewModel) {
    _logger.logInfo('Updating view model...');

    _viewModel = newViewModel;
    emit(QuestionCreationState.viewModelUpdated(_viewModel));
  }

  Future<void> _createQuestion() async {
    final viewModel = _defaultViewModel;
    final createQuestionUseCase = _useCaseFactory.makeCreateQuestionUseCase();

    final creationResult = await createQuestionUseCase.execute(
      QuestionCreationInput(
        shortDescription: viewModel.title.value,
        description: viewModel.description.value,
        difficulty: viewModel.difficulty.formField.value,
        options: viewModel.options
            .map(
              (e) => QuestionCreationOptionInput(
                description: e.formField.value,
                isCorrect: e.isCorrect,
              ),
            )
            .toList(),
        categories: const [],
      ),
    );

    if (creationResult.isErr) {
      final newViewModel = viewModel.copyWith(
        message: QuestionCreationMessageViewModel(
          type: QuestionCreationMessageType.unableToSaveQuestion,
          isFailure: true,
          details: creationResult.err!.message,
        ),
        showMessage: true,
      );

      _updateViewModel(newViewModel);

      return;
    }

    final newViewModel = _viewModel.copyWith(
      message: const QuestionCreationMessageViewModel(
        type: QuestionCreationMessageType.questionSavedSuccessfully,
        isFailure: false,
        details: null,
      ),
      showMessage: true,
    );

    _updateViewModel(newViewModel);

    emit(QuestionCreationState.goBack());
  }

  bool _validateFields() {
    final areFieldsValid = _viewModel.areFieldsValid;

    if (!areFieldsValid) {
      final newViewModel = _viewModel.copyWith(
        title: _viewModel.title.copyWith(
          showErrorMessage: true,
        ),
        description: _viewModel.description.copyWith(
          showErrorMessage: true,
        ),
        difficulty: _viewModel.difficulty.copyWith(
          formField: _viewModel.difficulty.formField.copyWith(
            showErrorMessage: true,
          ),
        ),
        options: _viewModel.options.map(
          (option) {
            return option.copyWith(
              formField: option.formField.copyWith(
                showErrorMessage: true,
              ),
            );
          },
        ).toList(),
      );

      _updateViewModel(newViewModel);

      return false;
    }

    final hasAtLeastOneCorrectOption = _viewModel.hasAtLeastOneCorrectOption;

    if (!hasAtLeastOneCorrectOption) {
      final newViewModel = _viewModel.copyWith(
        message: const QuestionCreationMessageViewModel(
          type: QuestionCreationMessageType.noCorrectOption,
          isFailure: true,
          details: null,
        ),
        showMessage: true,
      );

      _updateViewModel(newViewModel);

      return false;
    }

    return true;
  }
}
