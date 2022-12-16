import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/view_models/question_overview_view_model.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState>
    implements Manager {
  QuestionsOverviewCubit({
    required WatchAllQuestionsUseCase watchAllQuestionsUseCase,
    required DeleteQuestionUseCase deleteQuestionUseCase,
    required UpdateQuestionUseCase updateQuestionUseCase,
  })  : _updateQuestionUseCase = updateQuestionUseCase,
        _deleteQuestionUseCase = deleteQuestionUseCase,
        _watchAllQuestionsUseCase = watchAllQuestionsUseCase,
        super(QuestionsOverviewState.initial());

  final WatchAllQuestionsUseCase _watchAllQuestionsUseCase;
  final DeleteQuestionUseCase _deleteQuestionUseCase;
  final UpdateQuestionUseCase _updateQuestionUseCase;

  Future<void> updateQuestions() async {
    emit(QuestionsOverviewState.loading());

    _watchQuestions();
  }

  Future<void> removeQuestion(QuestionOverviewViewModel question) async {
    await _deleteQuestionUseCase.execute(question.id);
  }

  Future<void> onQuestionSaved(QuestionOverviewViewModel viewModel) async {
    if (viewModel.shortDescription.isNotEmpty) {
      emit(QuestionsOverviewState.loading());

      final updateResult = await _updateQuestionUseCase.execute(
        _overviewViewModelToEntity(viewModel),
      );

      if (updateResult.isErr) {
        emit(QuestionsOverviewState.error(message: updateResult.err!.message));
      }
    }
  }

  void _watchQuestions() {
    final watchResult = _watchAllQuestionsUseCase.execute();

    if (watchResult.isErr) {
      emit(QuestionsOverviewState.error(message: watchResult.err!.message));
      return;
    }

    watchResult.ok!.listen(_emitNewQuestions);
  }

  void _emitNewQuestions(List<Question> newQuestions) {
    final questions = newQuestions.map(_questionToViewModel).toList();

    emit(
      QuestionsOverviewState.questionListUpdated(questions: questions),
    );
  }

  QuestionOverviewViewModel _questionToViewModel(Question question) {
    return QuestionOverviewViewModel(
      id: question.id,
      shortDescription: question.shortDescription,
      categories: _categoriesToStrings(question.categories),
      difficulty: _difficultyToString(question.difficulty),
      description: question.description,
    );
  }

  List<String> _categoriesToStrings(
    List<QuestionCategory> categories,
  ) {
    return categories.map(_categoryToString).toList();
  }

  String _categoryToString(QuestionCategory c) => c.value;

  String _difficultyToString(QuestionDifficulty difficulty) {
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
      // TODO: Mappers for the win!
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
      case 'easy':
        return QuestionDifficulty.easy;
      case 'medium':
        return QuestionDifficulty.medium;
      case 'hard':
        return QuestionDifficulty.hard;
    }

    return QuestionDifficulty.unknown;
  }

  QuestionCategory _categoryToEntity(String category) =>
      QuestionCategory(value: category);
}
