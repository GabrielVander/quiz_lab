import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/custom_implementations/rust_result.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/retrieve_question.dart';

part 'question_answering_state.dart';

class QuestionAnsweringCubit extends Cubit<QuestionAnsweringState> {
  QuestionAnsweringCubit({required this.logger, required this.getSingleQuestionUseCase})
      : super(const QuestionAnsweringInitial());

  final QuizLabLogger logger;
  final RetrieveQuestion getSingleQuestionUseCase;

  List<String> _correctAnswers = [];
  QuestionViewModel? _questionViewModel;

  Future<void> loadQuestion(String? questionId) async {
    logger.debug('Loading question...');

    await _emitLoadingState();

    (await (await _retrieveQuestion(questionId))
            .inspect(_saveCorrectAnswers)
            .map(_toViewModel)
            .inspect((value) => _questionViewModel = value)
            .inspectAsync((_) async => _emitQuestionViewModelUpdated()))
        .mapErr((_) => 'Unable to load question')
        .inspectErr(logger.error)
        .inspectErr((error) async => _emitErrorState(error));
  }

  Future<void> _emitLoadingState() => _asyncEmit(const QuestionAnsweringLoading());

  Future<void> _emitErrorState(String error) => _asyncEmit(QuestionAnsweringError(message: error));

  void _saveCorrectAnswers(AnswerableQuestion question) {
    _correctAnswers = question.answers.where((answer) => answer.isCorrect).map((answer) => answer.id).toList();
  }

  QuestionViewModel _toViewModel(AnswerableQuestion question) => QuestionViewModel(
        title: question.title,
        description: question.description,
        difficulty: _mapDifficulty(question.difficulty),
        answers: question.answers
            .map(
              (answer) => AnswerViewModel(
                id: answer.id,
                title: answer.description,
                isSelected: false,
                isCorrect: _correctAnswers.contains(answer.id),
              ),
            )
            .toList(),
        showResult: false,
        isAnswerButtonEnabled: false,
        isAnswerButtonVisible: true,
      );

  Future<void> _emitQuestionViewModelUpdated() async {
    await _asyncEmit(QuestionAnsweringQuestionViewModelUpdated(viewModel: _questionViewModel!));
  }

  Future<void> onOptionSelected(String optionId) async {
    _questionViewModel = _questionViewModel?.copyWith(
      isAnswerButtonEnabled: true,
      answers: _questionViewModel!.answers.map((answer) {
        if (answer.id == optionId) {
          return answer.copyWith(isSelected: true);
        }

        return answer.copyWith(isSelected: false);
      }).toList(),
    );

    await _emitQuestionViewModelUpdated();
  }

  Future<void> onAnswer() async {
    _questionViewModel = _questionViewModel?.copyWith(
      showResult: true,
      isAnswerButtonVisible: false,
    );
    await _emitQuestionViewModelUpdated();
  }

  Future<void> _asyncEmit(QuestionAnsweringState state) async {
    emit(state);
    await Future<void>.delayed(const Duration(milliseconds: 15));
  }

  Future<Result<AnswerableQuestion, Unit>> _retrieveQuestion(String? questionId) async =>
      (await getSingleQuestionUseCase.call(questionId)).inspectErr(logger.error).mapErr((_) => unit);

  String _mapDifficulty(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return 'easy';
      case QuestionDifficulty.medium:
        return 'medium';
      case QuestionDifficulty.hard:
        return 'hard';
      case QuestionDifficulty.unknown:
        return 'unknown';
    }
  }
}

class QuestionViewModel extends Equatable {
  const QuestionViewModel({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.answers,
    required this.showResult,
    required this.isAnswerButtonEnabled,
    required this.isAnswerButtonVisible,
  });

  final String title;
  final String description;
  final String difficulty;
  final List<AnswerViewModel> answers;
  final bool showResult;
  final bool isAnswerButtonVisible;
  final bool isAnswerButtonEnabled;

  @override
  List<Object?> get props => [
        title,
        description,
        difficulty,
        answers,
        showResult,
        isAnswerButtonEnabled,
        isAnswerButtonVisible,
      ];

  QuestionViewModel copyWith({
    String? title,
    String? description,
    String? difficulty,
    List<AnswerViewModel>? answers,
    bool? showResult,
    bool? isAnswerButtonEnabled,
    bool? isAnswerButtonVisible,
  }) =>
      QuestionViewModel(
        title: title ?? this.title,
        description: description ?? this.description,
        difficulty: difficulty ?? this.difficulty,
        answers: answers ?? this.answers,
        showResult: showResult ?? this.showResult,
        isAnswerButtonEnabled: isAnswerButtonEnabled ?? this.isAnswerButtonEnabled,
        isAnswerButtonVisible: isAnswerButtonVisible ?? this.isAnswerButtonVisible,
      );
}

class AnswerViewModel extends Equatable {
  const AnswerViewModel({
    required this.id,
    required this.title,
    required this.isSelected,
    required this.isCorrect,
  });

  final String id;
  final String title;
  final bool isSelected;
  final bool isCorrect;

  @override
  List<Object> get props => [id, title, isSelected, isCorrect];

  AnswerViewModel copyWith({
    String? id,
    String? title,
    bool? isSelected,
    bool? isCorrect,
  }) =>
      AnswerViewModel(
        id: id ?? this.id,
        title: title ?? this.title,
        isSelected: isSelected ?? this.isSelected,
        isCorrect: isCorrect ?? this.isCorrect,
      );
}
