import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/question_management/domain/entities/question.dart';
import '../../../../features/question_management/domain/entities/question_category.dart';
import '../../../../features/question_management/domain/entities/question_difficulty.dart';
import '../../../../features/question_management/domain/use_cases/delete_question_use_case.dart';
import '../../../../features/question_management/domain/use_cases/update_question_use_case.dart';
import '../../../../features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import '../../../common/manager.dart';
import '../../view_models/question_overview.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState>
    implements Manager {
  QuestionsOverviewCubit({
    required this.watchAllQuestionsUseCase,
    required this.deleteQuestionUseCase,
    required this.updateQuestionUseCase,
  }) : super(QuestionsOverviewInitial());

  final WatchAllQuestionsUseCase watchAllQuestionsUseCase;
  final DeleteQuestionUseCase deleteQuestionUseCase;
  final UpdateQuestionUseCase updateQuestionUseCase;

  Stream<Question>? _questions;

  Future<void> watchQuestions(BuildContext context) async {
    emit(QuestionsOverviewLoading());

    final questionsResult = await watchAllQuestionsUseCase.execute();
    _questions = questionsResult;

    _questions?.listen((questions) => _onQuestionsUpdate(context, [questions]));
  }

  Future<void> removeQuestion(QuestionOverviewViewModel question) async {
    await deleteQuestionUseCase.execute(question.id);
  }

  Future<void> createNew(BuildContext context) async {
    GoRouter.of(context).go('/question');
  }

  Future<void> updateQuestion(QuestionOverviewViewModel viewModel) async {
    if (viewModel.shortDescription.isNotEmpty) {
      emit(QuestionsOverviewLoading());

      await updateQuestionUseCase.execute(
        _overviewViewModelToEntity(viewModel),
      );
    }
  }

  void _onQuestionsUpdate(BuildContext context, List<Question> questions) {
    emit(
      QuestionsOverviewListUpdated(
        viewModel: QuestionListViewModel(
          questions: _mapQuestionsToViewModels(context, questions),
        ),
      ),
    );
  }

  List<QuestionOverviewViewModel> _mapQuestionsToViewModels(
    BuildContext context,
    List<Question> questions,
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
      categories: _categoriesToStrings(question.categories),
      difficulty: _difficultyToString(context, question.difficulty),
      description: question.description,
    );
  }

  List<String> _categoriesToStrings(
    List<QuestionCategory> categories,
  ) {
    return categories.map(_categoryToString).toList();
  }

  String _categoryToString(QuestionCategory c) => c.value;

  String _difficultyToString(
    BuildContext context,
    QuestionDifficulty difficulty,
  ) {
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

  Question _overviewViewModelToEntity(QuestionOverviewViewModel viewModel) =>
      Question(
        id: viewModel.id,
        shortDescription: viewModel.shortDescription,
        description: viewModel.description,
        answerOptions: const [],
        difficulty: _difficultyStringToEntity(viewModel.difficulty),
        categories: viewModel.categories.map(_categoryToEntity).toList(),
      );

  QuestionDifficulty _difficultyStringToEntity(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return QuestionDifficulty.easy;
      case 'Medium':
        return QuestionDifficulty.medium;
      case 'Hard':
        return QuestionDifficulty.hard;
    }

    return QuestionDifficulty.unknown;
  }

  QuestionCategory _categoryToEntity(String category) =>
      QuestionCategory(value: category);
}
