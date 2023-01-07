import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';
import 'package:rxdart/rxdart.dart';

part 'question_display_state.dart';

class QuestionDisplayCubit extends Cubit<QuestionDisplayState> {
  QuestionDisplayCubit({required UseCaseFactory useCaseFactory})
      : _useCaseFactory = useCaseFactory,
        super(QuestionDisplayState.initial());

  final UseCaseFactory _useCaseFactory;

  final _defaultViewModel = const QuestionDisplayViewModel(
    title: '',
    difficulty: '',
    description: '',
    options: [],
    answerButtonIsEnabled: false,
  );

  final BehaviorSubject<QuestionDisplayViewModel> _viewModelSubject =
      BehaviorSubject<QuestionDisplayViewModel>();

  Future<void> loadQuestion(String? questionId) async {
    final questionResult = await _getQuestionForId(questionId);

    if (questionResult.isErr) {
      emit(QuestionDisplayState.failure());
      return;
    }

    _emitSubjectWithGivenQuestion(questionResult.ok!);
  }

  void onOptionSelected(QuestionDisplayOptionViewModel option) {
    _viewModelSubject.add(
      _viewModelSubject.value.copyWith(
        options: _viewModelSubject.value.options.map((e) {
          if (e.title == option.title) {
            return e.copyWith(isSelected: true);
          }

          return e.copyWith(isSelected: false);
        }).toList(),
        answerButtonIsEnabled: true,
      ),
    );
  }

  void onAnswer() {
    final selectedOption = _viewModelSubject.value.options.firstWhere(
      (element) => element.isSelected,
    );

    if (selectedOption.isCorrect) {
      emit(QuestionDisplayState.questionAnsweredCorrectly());
      return;
    }

    final correctOption = _viewModelSubject.value.options.firstWhere(
      (element) => element.isCorrect,
    );

    emit(QuestionDisplayState.questionAnsweredIncorrectly(correctOption));
  }

  Future<Result<Question, String>> _getQuestionForId(String? questionId) async {
    final getSingleQuestionUseCase =
        _useCaseFactory.makeGetSingleQuestionUseCase();

    return getSingleQuestionUseCase.execute(questionId);
  }

  void _emitSubjectWithGivenQuestion(Question question) {
    final questionViewModel = _mapQuestionToViewModel(question);

    _viewModelSubject.add(questionViewModel);

    emit(QuestionDisplayState.subjectUpdated(_viewModelSubject));
  }

  QuestionDisplayViewModel _mapQuestionToViewModel(Question question) =>
      _QuestionDisplayViewModelMapper(
        defaultViewModel: _defaultViewModel,
      ).map(question);
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
