import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_can_create_public_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/view_models/question_creation_view_model.dart';
import 'package:uuid/uuid.dart';

part 'question_creation_state.dart';

class QuestionCreationCubit extends Cubit<QuestionCreationState> {
  QuestionCreationCubit({
    required this.logger,
    required this.createQuestionUseCase,
    required this.checkIfUserCanCreatePublicQuestionsUseCase,
  }) : super(const QuestionCreationInitial());

  final QuizLabLogger logger;
  final CreateQuestionUseCase createQuestionUseCase;
  final CheckIfUserCanCreatePublicQuestionsUseCase checkIfUserCanCreatePublicQuestionsUseCase;

  final QuestionCreationViewModel defaultViewModel = QuestionCreationViewModel(
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
  late QuestionCreationViewModel _viewModel = defaultViewModel;
  _QuestionFormState _questionFormState = const _QuestionFormState();

  Future<void> load() async {
    emit(const QuestionCreationLoading());
    await _maybeEnableIsPublicToggle();
    _updateViewModel(defaultViewModel);
  }

  void onTitleChanged(String newValue) {
    logger.debug('Title changed');

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
    logger.debug('Description changed');

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
    logger.debug('Difficulty changed: $value');

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
    logger.debug('Option changed');

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
    logger.debug('Option toggled');

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
    logger.debug('Adding option...');

    const optionsLimit = 5;

    if (_viewModel.options.length >= optionsLimit) {
      logger.debug('Options limit reached');
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
    logger.info('Creating question...');

    final isValid = _validateFields();

    if (!isValid) {
      logger.warn('Invalid fields');
      return;
    }

    emit(const QuestionCreationLoading());
    await _createQuestion();
  }

  void toggleIsQuestionPublic() {
    logger.debug('Toggling public status...');

    _questionFormState = _questionFormState.copyWith(
      isPublic: _questionFormState.isPublic == null || !_questionFormState.isPublic!,
    );

    emit(
      QuestionCreationPublicStatusUpdated(
        isPublic: _questionFormState.isPublic!,
      ),
    );
  }

  void _updateViewModel(QuestionCreationViewModel newViewModel) {
    logger.debug('Updating view model...');

    _viewModel = newViewModel;
    emit(QuestionCreationViewModelUpdated(viewModel: _viewModel));
  }

  Future<void> _createQuestion() async {
    final draftQuestion = DraftQuestion(
      title: _viewModel.title.value,
      description: _viewModel.description.value,
      difficulty: _parseDifficulty(_viewModel.difficulty.formField.value),
      options: _viewModel.options
          .map(
            (e) => AnswerOption(
              description: e.formField.value,
              isCorrect: e.isCorrect,
            ),
          )
          .toList(),
      isPublic: _questionFormState.isPublic ?? false,
      categories: const [],
    );

    (await createQuestionUseCase(draftQuestion))
        .inspectErr(logger.error)
        .map(
          (_) => _viewModel.copyWith(
            message: const QuestionCreationMessageViewModel(
              type: QuestionCreationMessageType.questionSavedSuccessfully,
              isFailure: false,
              details: null,
            ),
            showMessage: true,
          ),
        )
        .mapErr(
          (error) => _viewModel.copyWith(
            message: QuestionCreationMessageViewModel(
              type: QuestionCreationMessageType.unableToSaveQuestion,
              isFailure: true,
              details: error,
            ),
            showMessage: true,
          ),
        )
        .inspect(_updateViewModel)
        .inspectErr(_updateViewModel)
        .inspect((_) => emit(const QuestionCreationGoBack()));
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

  Future<void> _maybeEnableIsPublicToggle() async {
    logger.info('Checking if user can create public questions...');

    (await checkIfUserCanCreatePublicQuestionsUseCase())
        .inspect(
          (shouldDisplay) => shouldDisplay
              ? emit(const QuestionCreationShowPublicToggle())
              : emit(const QuestionCreationHidePublicToggle()),
        )
        .inspectErr(logger.error)
        .inspectErr((_) => emit(const QuestionCreationHidePublicToggle()));
  }

  QuestionDifficulty _parseDifficulty(String rawValue) {
    final mappings = {
      'easy': QuestionDifficulty.easy,
      'medium': QuestionDifficulty.medium,
      'hard': QuestionDifficulty.hard,
    };

    return (mappings.containsKey(rawValue)) ? mappings[rawValue]! : QuestionDifficulty.unknown;
  }
}

final class _QuestionFormState extends Equatable {
  const _QuestionFormState({
    this.isPublic,
  });

  final bool? isPublic;

  _QuestionFormState copyWith({
    bool? isPublic,
  }) =>
      _QuestionFormState(
        isPublic: isPublic ?? this.isPublic,
      );

  @override
  List<Object> get props => [
        isPublic ?? 'isPublic -> null',
      ];
}
