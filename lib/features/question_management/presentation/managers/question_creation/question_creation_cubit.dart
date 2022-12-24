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
    _validateNewQuestionTitle();
  }

  void onDescriptionUpdate(String newValue) {
    _description = newValue;
    _validateNewQuestionDescription();
  }

  Future<void> createQuestion() async {
    emit(QuestionCreationState.loading());

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

  bool _validateFields() {
    return [
      _validateNewQuestionTitle(),
      _validateNewQuestionDescription(),
    ].every((isValid) => isValid);
  }

  bool _validateNewQuestionTitle() {
    if (_title == '') {
      emit(QuestionCreationState.titleIsEmpty());

      return false;
    }

    emit(QuestionCreationState.titleIsValid());
    return true;
  }

  bool _validateNewQuestionDescription() {
    if (_description == '') {
      emit(QuestionCreationState.descriptionIsEmpty());

      return false;
    }

    emit(QuestionCreationState.descriptionIsValid());
    return true;
  }

  Future<void> _createQuestion() async {
    final difficulties = [
      'easy',
      'medium',
      'hard',
    ]..shuffle();
    final createQuestionUseCase = _useCaseFactory.makeCreateQuestionUseCase();
    final randomDifficulty = difficulties.first;

    final creationResult = await createQuestionUseCase.execute(
      QuestionCreationInput(
        shortDescription: _title,
        description: _description,
        difficulty: randomDifficulty,
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
