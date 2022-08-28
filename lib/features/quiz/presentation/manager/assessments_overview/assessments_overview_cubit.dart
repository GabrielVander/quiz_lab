import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/assessment_overview.dart';

part 'assessments_overview_state.dart';

class AssessmentsOverviewCubit extends Cubit<AssessmentsOverviewState> {
  AssessmentsOverviewCubit() : super(AssessmentsOverviewInitial());

  final List<AssessmentOverviewViewModel> _dummyAssessments = [
    AssessmentOverviewViewModel.having(
      title: 'Mathematics 1',
      amountOfQuestions: 10,
      answers: AnswersViewModel.having(
        amountOfAnswers: 3,
        answerLimit: 15,
      ),
      dueDate: DueDateViewModel.having(dueDate: '6/23/2022'),
    ),
    AssessmentOverviewViewModel.having(
      title: 'Mathematics 2',
      amountOfQuestions: 10,
      answers: AnswersViewModel.having(
        amountOfAnswers: 6,
        answerLimit: 15,
      ),
      dueDate: DueDateViewModel.having(dueDate: '6/28/2022'),
    ),
    AssessmentOverviewViewModel.having(
      title: 'Matrices',
      amountOfQuestions: 25,
      answers: AnswersViewModel.having(
        amountOfAnswers: 27,
        answerLimit: 27,
      ),
      dueDate: DueDateViewModel.having(dueDate: '6/28/2022'),
    ),
    AssessmentOverviewViewModel.having(
      title: 'Statistics 1',
      amountOfQuestions: 15,
      answers: AnswersViewModel.having(
        amountOfAnswers: 7,
      ),
      dueDate: DueDateViewModel.having(),
    ),
    AssessmentOverviewViewModel.having(
      title: 'Integers Quiz',
      amountOfQuestions: 5,
      answers: AnswersViewModel.having(
        amountOfAnswers: 5,
      ),
      dueDate: DueDateViewModel.having(),
    ),
  ];

  Future<void> getAssessments(BuildContext context) async {
    emit(AssessmentsOverviewLoading());

    Future.delayed(
      const Duration(seconds: 2),
      () {
        emit(AssessmentsOverviewLoaded(assessments: _dummyAssessments));
      },
    );
  }
}
