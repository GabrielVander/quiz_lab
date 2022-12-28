import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:uuid/uuid.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState>
    implements Manager {
  QuestionCreationCubit({
    required UseCaseFactory useCaseFactory,
  })  : _useCaseFactory = useCaseFactory,
        super(QuestionCreationState.initial()) {
    emit(QuestionCreationState.optionsUpdated(_options.toList()));
  }

  final UseCaseFactory _useCaseFactory;
  String _title = '';
  String _description = '';
  String _difficulty = '';
  Iterable<SingleOptionViewModel> _options = List.unmodifiable([
    SingleOptionViewModel(value: '', isCorrect: false),
    SingleOptionViewModel(value: '', isCorrect: false),
  ]);

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

    final areFieldsValid = _validateFields();

    if (!areFieldsValid) {
      return;
    }

    final hasAtLeastOneCorrectOption = _hasAtLeastOneCorrectOption();

    if (!hasAtLeastOneCorrectOption) {
      emit(QuestionCreationState.noCorrectOption());
      return;
    }

    if (areFieldsValid) {
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
    _options = _options
        .map(
          (option) => option.id == id
              ? option.copyWith(isCorrect: !option.isCorrect)
              : option,
        )
        .toList();

    emit(QuestionCreationState.optionsUpdated(_options.toList()));
  }

  void onOptionUpdate(String id, String value) {
    _options = _options
        .map(
          (option) => option.id == id ? option.copyWith(value: value) : option,
        )
        .toList();

    _validateOptions();
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

  bool _validateOptions() {
    final updatedOptions = _options.map(_validateSingleOption);
    _options = updatedOptions;

    emit(QuestionCreationState.optionsUpdated(_options.toList()));

    return updatedOptions.map((e) => e.isEmpty).contains(true);
  }

  SingleOptionViewModel _validateSingleOption(SingleOptionViewModel option) =>
      option.copyWith(isEmpty: option.value.isEmpty);

  bool _validateFields() {
    return [
      _validateTitleFieldValue(),
      _validateDescriptionFieldValue(),
      _validateDifficultyFieldValue(),
      _validateOptions(),
    ].every((isValid) => isValid);
  }

  bool _hasAtLeastOneCorrectOption() =>
      _options.any((option) => option.isCorrect);

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

class SingleOptionViewModel extends Equatable {
  SingleOptionViewModel({
    required this.value,
    required this.isCorrect,
    this.isEmpty = false,
    String? id,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String value;
  final bool isCorrect;
  final bool isEmpty;

  SingleOptionViewModel copyWith({
    String? value,
    bool? isCorrect,
    bool? isEmpty,
  }) {
    return SingleOptionViewModel(
      id: this.id,
      value: value ?? this.value,
      isCorrect: isCorrect ?? this.isCorrect,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  List<Object?> get props => [
        id,
        value,
        isCorrect,
        isEmpty,
      ];
}
