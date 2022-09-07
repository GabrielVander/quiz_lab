import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/fetch_questions_use_case.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_overview.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit({
    required this.watchAllQuestionsUseCase,
    required this.deleteQuestionUseCase,
  }) : super(QuestionsOverviewInitial());

  final WatchAllQuestionsUseCase watchAllQuestionsUseCase;
  final DeleteQuestionUseCase deleteQuestionUseCase;

  Stream<List<Question>>? _questions;

  void getQuestions(BuildContext context) {
    emit(QuestionsOverviewLoading());

    _questions = watchAllQuestionsUseCase.execute();

    _questions?.listen((questions) => _onQuestionsUpdate(context, questions));
  }

  Future<void> removeQuestion(QuestionOverviewViewModel question) async {
    await deleteQuestionUseCase.execute(question.id);
  }

  Future<void> createNew(BuildContext context) async {
    GoRouter.of(context).go('/question');
  }

  void _onQuestionsUpdate(BuildContext context, List<Question> questions) {
    emit(
      QuestionsOverviewLoaded(
        questions: _mapQuestionsToViewModels(questions, context),
      ),
    );
  }

  List<QuestionOverviewViewModel> _mapQuestionsToViewModels(
    List<Question> questions,
    BuildContext context,
  ) {
    return questions
        .map((question) => _questionToViewModel(context, question))
        .toList();
  }

  QuestionOverviewViewModel _questionToViewModel(
    BuildContext context,
    Question question,
  ) {
    return QuestionOverviewViewModel(
      id: question.id!,
      shortDescription: question.shortDescription,
      categories: _categoriesToViewModels(question.categories),
      difficulty: _difficultyToViewModel(context, question.difficulty),
      description: question.description,
    );
  }

  List<QuestionCategoryViewModel> _categoriesToViewModels(
    List<QuestionCategory> categories,
  ) {
    return categories.map(_categoryToViewModel).toList();
  }

  QuestionCategoryViewModel _categoryToViewModel(QuestionCategory c) =>
      QuestionCategoryViewModel(value: c.value);

  QuestionDifficultyViewModel _difficultyToViewModel(
    BuildContext context,
    QuestionDifficulty difficulty,
  ) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return const QuestionDifficultyViewModel(value: 'Easy');
      case QuestionDifficulty.medium:
        return const QuestionDifficultyViewModel(value: 'Medium');
      case QuestionDifficulty.hard:
        return const QuestionDifficultyViewModel(value: 'Hard');
      case QuestionDifficulty.unknown:
        return const QuestionDifficultyViewModel(value: 'Unknown');
    }
  }
}
