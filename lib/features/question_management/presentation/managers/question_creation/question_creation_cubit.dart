import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState>
    implements Manager {
  QuestionCreationCubit({
    required UseCaseFactory useCaseFactory,
  })  : _useCaseFactory = useCaseFactory,
        super(QuestionCreationState.initial()) {
    display();
  }

  final UseCaseFactory _useCaseFactory;
  String _title = '';
  String _description = '';
  String _difficulty = '';

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

  void display() {
    emit(QuestionCreationDisplayUpdate(viewModel: _viewModel));
  }

  void onTitleUpdate(String newValue) {
    _title = newValue;
    _validateTitleFieldValue();
  }

  void onDescriptionUpdate(String newValue) {
    _description = newValue;
    _validateDescriptionFieldValue();
  }

  Future<void> createQuestion() async {
    emit(QuestionCreationState.saving());

    if (_validateFields()) {
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

  void onDifficultyUpdate(String? value) {
    _difficulty = value ?? '';

    _validateDifficultyFieldValue();
  }

  bool _validateTitleFieldValue() {
    if (_title == '') {
      emit(QuestionCreationState.titleIsEmpty());

      return false;
    }

    emit(QuestionCreationState.titleIsValid());
    return true;
  }

  bool _validateDescriptionFieldValue() {
    if (_description == '') {
      emit(QuestionCreationState.descriptionIsEmpty());

      return false;
    }

    emit(QuestionCreationState.descriptionIsValid());
    return true;
  }

  bool _validateDifficultyFieldValue() {
    if (_difficulty == '') {
      emit(QuestionCreationState.difficultyIsNotSet());

      return false;
    }

    emit(QuestionCreationState.difficultyIsSet());
    return true;
  }

  bool _validateFields() {
    return [
      _validateTitleFieldValue(),
      _validateDescriptionFieldValue(),
      _validateDifficultyFieldValue(),
    ].every((isValid) => isValid);
  }

  Future<void> _createQuestion() async {
    final createQuestionUseCase = _useCaseFactory.makeCreateQuestionUseCase();

    final creationResult = await createQuestionUseCase.execute(
      QuestionCreationInput(
        shortDescription: _title,
        description: _description,
        difficulty: _difficulty,
        categories: const [],
      ),
    );

    if (creationResult.isErr) {
      emit(QuestionCreationState.failure(details: creationResult.err!.message));
      return;
    }

    emit(QuestionCreationState.success());
  }
}
