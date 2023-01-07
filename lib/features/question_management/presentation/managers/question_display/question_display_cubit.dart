import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';
import 'package:rxdart/rxdart.dart';

part 'question_display_state.dart';

class QuestionDisplayCubit extends Cubit<QuestionDisplayState> {
  QuestionDisplayCubit() : super(QuestionDisplayState.initial()) {
    final options = defaultViewModel.options.map((e) => e).toList()..shuffle();

    _viewModelSubject = BehaviorSubject<QuestionDisplayViewModel>.seeded(
      defaultViewModel.copyWith(
        options: options,
      ),
    );
  }

  final defaultViewModel = const QuestionDisplayViewModel(
    title: 'Equivalent',
    difficulty: 'easy',
    description: 'Which number is equivalent to 3^(4)÷3^(2)?',
    options: [
      QuestionDisplayOptionViewModel(
        title: '3',
        isSelected: false,
        isCorrect: false,
      ),
      QuestionDisplayOptionViewModel(
        title: '9',
        isSelected: false,
        isCorrect: true,
      ),
      QuestionDisplayOptionViewModel(
        title: '27',
        isSelected: false,
        isCorrect: false,
      ),
      QuestionDisplayOptionViewModel(
        title: '81',
        isSelected: false,
        isCorrect: false,
      ),
    ],
    answerButtonIsEnabled: false,
  );

  late BehaviorSubject<QuestionDisplayViewModel> _viewModelSubject;

  void loadQuestion(String? questionId) {
    emit(QuestionDisplayState.subjectUpdated(_viewModelSubject));
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
}
