import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.fetchAllQuestionsUseCase,
    required this.deleteQuestionUseCase,
  }) : super(QuestionsOverviewInitial());

  final FetchAllQuestionsUseCase fetchAllQuestionsUseCase;
  final DeleteQuestionUseCase deleteQuestionUseCase;

  Stream<List<Question>>? _questions;

  void getQuestions(BuildContext context) {
    emit(QuestionsOverviewLoading());
    _questions = fetchAllQuestionsUseCase.execute();

    _questions?.listen((questions) {
      emit(
        QuestionsOverviewLoaded(
          questions: questions
              .map(
                (question) => QuestionOverviewViewModel(
                  shortDescription: question.shortDescription,
                  categories: question.categories
                      .map(
                        (QuestionCategory c) =>
                            QuestionCategoryViewModel(value: c.value),
                      )
                      .toList(),
                  difficulty: _difficultyToString(context, question.difficulty),
                  description: question.description,
                ),
              )
              .toList(),
        ),
      );
    });
  }

  Future<void> removeQuestion(QuestionOverviewViewModel question) async {
    emit(QuestionsOverviewLoading());

    await deleteQuestionUseCase.execute(question.id!);
  }

  Future<void> createNew(BuildContext context) async {
    GoRouter.of(context).go('/question');
    emit(QuestionsOverviewInitial());
  }

  Future<void> _loadQuestions() async {
    final db = FirebaseFirestore.instance;

    await db.collection('questions').get().then((event) {
      final viewModels = <QuestionOverviewViewModel>[];

      for (final doc in event.docs) {
        final viewModel = QuestionOverviewViewModel(
          id: doc.id,
          shortDescription: doc.get('shortDescription') as String,
          description: doc.get('description') as String,
          categories: (doc.get('categories') as List<dynamic>)
              .map((e) => QuestionCategoryViewModel(value: e as String))
              .toList(),
          difficulty: QuestionDifficultyViewModel(
            value: doc.get('difficulty') as String,
          ),
        );

        viewModels.add(viewModel);
      }

      emit(QuestionsOverviewLoaded(questions: viewModels));
    });
  }

  QuestionDifficultyViewModel _difficultyToString(
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
