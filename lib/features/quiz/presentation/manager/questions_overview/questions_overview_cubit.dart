import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_overview.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit() : super(QuestionsOverviewInitial());

  final List<QuestionOverviewViewModel> _dummyQuestions = [
    const QuestionOverviewViewModel(
      shortDescription: '4²',
      description: '4² = ?',
      categories: [
        QuestionCategoryViewModel.math,
        QuestionCategoryViewModel.algebra,
      ],
      difficulty: QuestionDifficultyViewModel.easy,
      options: [
        OptionViewModel(
          description: '8',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '16',
          isCorrect: true,
        ),
        OptionViewModel(
          description: '6',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '1',
          isCorrect: false,
        ),
      ],
    ),
    const QuestionOverviewViewModel(
      shortDescription: 'Value of x',
      description: 'What will be the value of x in this equation:  2x - 4 = 0 ',
      categories: [
        QuestionCategoryViewModel.math,
        QuestionCategoryViewModel.algebra,
      ],
      difficulty: QuestionDifficultyViewModel.easy,
      options: [
        OptionViewModel(
          description: '0',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '-2',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '2',
          isCorrect: true,
        ),
        OptionViewModel(
          description: '1',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '4',
          isCorrect: false,
        ),
      ],
    ),
    const QuestionOverviewViewModel(
      shortDescription: 'Solve 4/2 + 7/2',
      description: 'Solve: 4/2 + 7/2 = ?',
      categories: [
        QuestionCategoryViewModel.math,
        QuestionCategoryViewModel.algebra,
      ],
      difficulty: QuestionDifficultyViewModel.medium,
      options: [
        OptionViewModel(
          description: '5 1/4',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '5 1/2',
          isCorrect: true,
        ),
        OptionViewModel(
          description: '11/4',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '7/4',
          isCorrect: false,
        ),
        OptionViewModel(
          description: '5 2/1',
          isCorrect: false,
        ),
      ],
    ),
  ];

  Future<void> getQuestions(BuildContext context) async {
    emit(QuestionsOverviewLoading());

    Future.delayed(
      const Duration(seconds: 2),
      () {
        emit(QuestionsOverviewLoaded(questions: _dummyQuestions));
      },
    );
  }

  Future<void> removeQuestion(QuestionOverviewViewModel question) async {
    emit(QuestionsOverviewLoading());
    _dummyQuestions.remove(question);
    emit(QuestionsOverviewLoaded(questions: _dummyQuestions));
  }
}
