import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation_view_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState> {
  QuestionCreationCubit({
    required UseCaseFactory useCaseFactory,
  })  : _useCaseFactory = useCaseFactory,
        super(QuestionCreationState.initial()) {
    _viewModelSubject.add(_defaultViewModel);

    emit(QuestionCreationState.viewModelSubjectUpdated(_viewModelSubject));
  }

  final UseCaseFactory _useCaseFactory;

  QuestionCreationViewModel get _defaultViewModel => QuestionCreationViewModel(
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

  final BehaviorSubject<QuestionCreationViewModel> _viewModelSubject =
      BehaviorSubject();

  void onTitleChanged(String newValue) {
    final newViewModel = _viewModelSubject.value.copyWith(
      title: _viewModelSubject.value.title.copyWith(
        value: newValue,
        showErrorMessage: true,
      ),
      showMessage: false,
    );

    _viewModelSubject.add(newViewModel);
  }

  void onDescriptionChanged(String newValue) {
    final newViewModel = _viewModelSubject.value.copyWith(
      description: _viewModelSubject.value.description.copyWith(
        value: newValue,
        showErrorMessage: true,
      ),
      showMessage: false,
    );

    _viewModelSubject.add(newViewModel);
  }

  void onDifficultyChanged(String? value) {
    final newViewModel = _viewModelSubject.value.copyWith(
      difficulty: _viewModelSubject.value.difficulty.copyWith(
        formField: _viewModelSubject.value.difficulty.formField.copyWith(
          value: value ?? '',
          showErrorMessage: true,
        ),
      ),
      showMessage: false,
    );

    _viewModelSubject.add(newViewModel);
  }

  void onOptionChanged(String id, String value) {
    final newViewModel = _viewModelSubject.value.copyWith(
      options: _viewModelSubject.value.options.map(
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

    _viewModelSubject.add(newViewModel);
  }

  void toggleOptionIsCorrect(String id) {
    final newViewModel = _viewModelSubject.value.copyWith(
      options: _viewModelSubject.value.options.map(
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

    _viewModelSubject.add(newViewModel);
  }

  void onAddOption() {
    const optionsLimit = 5;

    if (_viewModelSubject.value.options.length >= optionsLimit) {
      return;
    }

    final newViewModel = _viewModelSubject.value.copyWith(
      options: [
        ..._viewModelSubject.value.options,
        QuestionCreationOptionViewModel(
          id: const Uuid().v4(),
          formField: const QuestionCreationOptionValueViewModel(
            value: '',
            showErrorMessage: false,
          ),
          isCorrect: false,
        ),
      ],
      addOptionButtonEnabled:
          _viewModelSubject.value.options.length + 1 < optionsLimit,
      showMessage: false,
    );

    _viewModelSubject.add(newViewModel);
  }

  Future<void> onCreateQuestion() async {
    final isValid = _validateFields();

    if (!isValid) {
      return;
    }

    await _createQuestion();
  }

  Future<void> _createQuestion() async {
    final viewModel = _viewModelSubject.value;
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

      _viewModelSubject.add(newViewModel);

      return;
    }

    final newViewModel = _defaultViewModel.copyWith(
      message: const QuestionCreationMessageViewModel(
        type: QuestionCreationMessageType.questionSavedSuccessfully,
        isFailure: false,
        details: null,
      ),
      showMessage: true,
    );

    _viewModelSubject.add(newViewModel);

    emit(QuestionCreationState.goBack());
  }

  bool _validateFields() {
    final areFieldsValid = _viewModelSubject.value.areFieldsValid;

    if (!areFieldsValid) {
      final newViewModel = _viewModelSubject.value.copyWith(
        title: _viewModelSubject.value.title.copyWith(
          showErrorMessage: true,
        ),
        description: _viewModelSubject.value.description.copyWith(
          showErrorMessage: true,
        ),
        difficulty: _viewModelSubject.value.difficulty.copyWith(
          formField: _viewModelSubject.value.difficulty.formField.copyWith(
            showErrorMessage: true,
          ),
        ),
        options: _viewModelSubject.value.options.map(
          (option) {
            return option.copyWith(
              formField: option.formField.copyWith(
                showErrorMessage: true,
              ),
            );
          },
        ).toList(),
      );

      _viewModelSubject.add(newViewModel);

      return false;
    }

    final hasAtLeastOneCorrectOption =
        _viewModelSubject.value.hasAtLeastOneCorrectOption;

    if (!hasAtLeastOneCorrectOption) {
      final newViewModel = _viewModelSubject.value.copyWith(
        message: const QuestionCreationMessageViewModel(
          type: QuestionCreationMessageType.noCorrectOption,
          isFailure: true,
          details: null,
        ),
        showMessage: true,
      );

      _viewModelSubject.add(newViewModel);

      return false;
    }

    return true;
  }
}
