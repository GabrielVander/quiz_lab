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
        super(QuestionCreationState.initial());

  final UseCaseFactory _useCaseFactory;
  String _title = '';
  String _description = '';
  String _difficulty = '';
  Iterable<SingleOptionViewModel> _options = List.unmodifiable([]);

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

  void onDifficultyUpdate(String? value) {
    _difficulty = value ?? '';

    _validateDifficultyFieldValue();
  }

  void addOption() {
    const optionsLimit = 5;

    _options = List<SingleOptionViewModel>.unmodifiable(
      _options.toList()
        ..add(SingleOptionViewModel(value: '', isCorrect: false)),
    );

    emit(QuestionCreationState.optionsUpdated(_options.toList()));

    if (_options.length == optionsLimit) {
      emit(QuestionCreationState.optionLimitReached());
    }
  }

  void toggleOptionAsCorrect(String id) {
    _options = _options.map((option) {
      if (option.id == id) {
        return option.copyWith(isCorrect: true);
      } else {
        return option;
      }
    }).toList();

    emit(QuestionCreationState.optionsUpdated(_options.map((e) => e).toList()));
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
