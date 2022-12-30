import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation_view_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState>
    implements Manager {
  QuestionCreationCubit({
    required UseCaseFactory useCaseFactory,
  })  : _useCaseFactory = useCaseFactory,
        super(QuestionCreationState.initial()) {
    emit(QuestionCreationState.viewModelSubjectUpdated(_viewModelSubject));
  }

  final UseCaseFactory _useCaseFactory;

  final BehaviorSubject<QuestionCreationViewModel> _viewModelSubject =
      BehaviorSubject.seeded(
    QuestionCreationViewModel(
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
    ),
  );

  void onTitleUpdate(String newValue) {
    final newViewModel = _viewModelSubject.value.copyWith(
      title: _viewModelSubject.value.title.copyWith(
        value: newValue,
        showErrorMessage: true,
      ),
    );

    _viewModelSubject.add(newViewModel);
  }

  void onDescriptionUpdate(String newValue) {
    final newViewModel = _viewModelSubject.value.copyWith(
      description: _viewModelSubject.value.description.copyWith(
        value: newValue,
        showErrorMessage: true,
      ),
    );

    _viewModelSubject.add(newViewModel);
  }

  void onDifficultyUpdate(String? value) {
    final newViewModel = _viewModelSubject.value.copyWith(
      difficulty: _viewModelSubject.value.difficulty.copyWith(
        formField: _viewModelSubject.value.difficulty.formField.copyWith(
          value: value ?? '',
          showErrorMessage: true,
        ),
      ),
    );

    _viewModelSubject.add(newViewModel);
  }

  void onOptionUpdate(String id, String value) {
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
    );

    _viewModelSubject.add(newViewModel);
  }

  void toggleOptionAsCorrect(String id) {
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
    );

    _viewModelSubject.add(newViewModel);
  }

  void addOption() {
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
    );

    _viewModelSubject.add(newViewModel);
  }

  Future<void> createQuestion() async {
    emit(QuestionCreationState.saving());

    // final areFieldsValid = _validateFields();
    //
    // if (!areFieldsValid) {
    //   return;
    // }
    //
    // final hasAtLeastOneCorrectOption = _hasAtLeastOneCorrectOption();
    //
    // if (!hasAtLeastOneCorrectOption) {
    //   emit(QuestionCreationState.noCorrectOption());
    //   return;
    // }
    //
    // if (areFieldsValid) {
    //   await _createQuestion();
    // }
  }

  Future<void> _createQuestion() async {
    final createQuestionUseCase = _useCaseFactory.makeCreateQuestionUseCase();

    // final creationResult = await createQuestionUseCase.execute(
    //   QuestionCreationInput(
    //     shortDescription: _title,
    //     description: _description,
    //     difficulty: _difficulty,
    //     categories: const [],
    //   ),
    // );
    //
    // if (creationResult.isErr) {
    //   emit(QuestionCreationState.failure(details: creationResult.err!.message));
    //   return;
    // }
    //
    // emit(QuestionCreationState.success());
  }
}
