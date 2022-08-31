import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_overview.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit() : super(QuestionsOverviewInitial());

  Future<void> getQuestions(BuildContext context) async {
    emit(QuestionsOverviewLoading());

    await _loadQuestions();
  }

  Future<void> removeQuestion(QuestionOverviewViewModel question) async {
    emit(QuestionsOverviewLoading());

    final db = FirebaseFirestore.instance;

    await db.collection('questions').doc(question.id).delete().then((_) async {
      await _loadQuestions();
    });
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
}
