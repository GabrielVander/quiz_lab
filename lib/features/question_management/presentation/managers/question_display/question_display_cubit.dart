import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';

part 'question_display_state.dart';

class QuestionDisplayCubit extends Cubit<QuestionDisplayState> {
  QuestionDisplayCubit({
    required GetSingleQuestionUseCase getSingleQuestionUseCase,
  })  : _getSingleQuestionUseCase = getSingleQuestionUseCase,
        super(QuestionDisplayState.initial());

  final GetSingleQuestionUseCase _getSingleQuestionUseCase;

  final _defaultViewModel = const QuestionDisplayViewModel(
    title: '',
    difficulty: '',
    description: '',
    options: [],
    answerButtonIsEnabled: false,
  );

  QuestionDisplayViewModel _viewModelSubject = const QuestionDisplayViewModel(
    title: '',
    difficulty: '',
    description: '',
    options: [],
    answerButtonIsEnabled: false,
  );

  Future<void> loadQuestion(String? questionId) async {
    final questionResult = await _getQuestionForId(questionId);

    if (questionResult.isErr) {
      emit(QuestionDisplayState.failure());
      return;
    }

    _emitSubjectWithGivenQuestion(questionResult.ok!);
  }

  void onOptionSelected(String option) {
    _viewModelSubject = _viewModelSubject.copyWith(
      options: _viewModelSubject.options.map((e) {
        if (e.title == option) {
          return e.copyWith(isSelected: true);
        }

        return e.copyWith(isSelected: false);
      }).toList(),
      answerButtonIsEnabled: true,
    );

    emit(QuestionDisplayState.viewModelUpdated(_viewModelSubject));
  }

  void onAnswer() {
    final selectedOption = _viewModelSubject.options.firstWhere(
      (element) => element.isSelected,
    );

    if (selectedOption.isCorrect) {
      emit(QuestionDisplayState.questionAnsweredCorrectly());
      return;
    }

    final correctOption = _viewModelSubject.options.firstWhere(
      (element) => element.isCorrect,
    );

    emit(QuestionDisplayState.questionAnsweredIncorrectly(correctOption));
  }

  Future<Result<Question, Unit>> _getQuestionForId(String? questionId) async =>
      _getSingleQuestionUseCase.execute(questionId);

  void _emitSubjectWithGivenQuestion(Question question) {
    final questionViewModel = _mapQuestionToViewModel(question);

    _viewModelSubject = _randomizeOptionsOrder(questionViewModel);

    emit(
      QuestionDisplayState.viewModelUpdated(
        _randomizeOptionsOrder(questionViewModel),
      ),
    );
  }

  QuestionDisplayViewModel _mapQuestionToViewModel(Question question) =>
      _QuestionDisplayViewModelMapper(
        defaultViewModel: _defaultViewModel,
      ).map(question);

  QuestionDisplayViewModel _randomizeOptionsOrder(
    QuestionDisplayViewModel questionViewModel,
  ) =>
      questionViewModel.copyWith(
        options: questionViewModel.options..shuffle(),
      );
}

class _QuestionDisplayViewModelMapper {
  const _QuestionDisplayViewModelMapper({
    required QuestionDisplayViewModel defaultViewModel,
  }) : _defaultViewModel = defaultViewModel;

  final QuestionDisplayViewModel _defaultViewModel;

  QuestionDisplayViewModel map(Question question) {
    return _defaultViewModel.copyWith(
      title: question.shortDescription,
      difficulty: _mapDifficulty(question.difficulty),
      description: question.description,
      options: _mapOptions(question.answerOptions),
    );
  }

  List<QuestionDisplayOptionViewModel> _mapOptions(List<AnswerOption> answers) {
    return answers
        .map(
          (a) => QuestionDisplayOptionViewModel(
            title: a.description,
            isSelected: false,
            isCorrect: a.isCorrect,
          ),
        )
        .toList();
  }

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
