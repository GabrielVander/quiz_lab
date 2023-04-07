import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/questions_overview_view_model.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit({
    required UpdateQuestionUseCase updateQuestionUseCase,
    required DeleteQuestionUseCase deleteQuestionUseCase,
    required WatchAllQuestionsUseCase watchAllQuestionsUseCase,
  })  : _updateQuestionUseCase = updateQuestionUseCase,
        _deleteQuestionUseCase = deleteQuestionUseCase,
        _watchAllQuestionsUseCase = watchAllQuestionsUseCase,
        super(QuestionsOverviewState.initial());

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<QuestionsOverviewCubit>();

  final UpdateQuestionUseCase _updateQuestionUseCase;
  final DeleteQuestionUseCase _deleteQuestionUseCase;
  final WatchAllQuestionsUseCase _watchAllQuestionsUseCase;

  QuestionsOverviewViewModel _viewModel = const QuestionsOverviewViewModel(
    questions: [],
    isRandomQuestionButtonEnabled: false,
  );

  final _questionStreamController = StreamController<List<Question>>();

  void updateQuestions() {
    _logger.info('Updating questions...');
    emit(QuestionsOverviewState.loading());

    _watchQuestions();
  }

  Future<void> removeQuestion(QuestionsOverviewItemViewModel question) async {
    emit(QuestionsOverviewState.loading());

    await _deleteQuestion(question);
  }

  Future<void> onQuestionSaved(QuestionsOverviewItemViewModel viewModel) async {
    if (viewModel.shortDescription.isNotEmpty) {
      emit(QuestionsOverviewState.loading());
      final viewModelAsQuestion = viewModel.toQuestion();

      final updateResult =
          await _updateQuestionUseCase.execute(viewModelAsQuestion);

      updateResult.when(
        ok: (_) {},
        err: (failure) => emit(
          QuestionsOverviewState.errorOccurred(message: failure.message),
        ),
      );
    }
  }

  void onOpenRandomQuestion() {
    emit(QuestionsOverviewState.loading());
    _logger.info('Opening random question...');

    final ids = _viewModel.questions.map((q) => q.id).toList()..shuffle();
    final randomQuestionId = ids.first;

    _logger.info('Opening question $randomQuestionId...');
    emit(QuestionsOverviewState.openQuestion(randomQuestionId));
    emit(QuestionsOverviewState.viewModelUpdated(viewModel: _viewModel));
  }

  void onQuestionClick(QuestionsOverviewItemViewModel viewModel) =>
      emit(QuestionsOverviewState.openQuestion(viewModel.id));

  Future<void> _watchQuestions() async {
    final watchResult = await _watchAllQuestionsUseCase.execute();

    await watchResult.when(
      ok: (questionsStream) async {
        _questionStreamController.stream.listen(_emitNewQuestions);

        await questionsStream.pipe(_questionStreamController);
      },
      err: (failure) {
        emit(
          QuestionsOverviewState.errorOccurred(
            message: failure.message,
          ),
        );

        return;
      },
    );
  }

  Future<void> _deleteQuestion(QuestionsOverviewItemViewModel question) async =>
      _deleteQuestionUseCase.execute(question.id);

  void _emitNewQuestions(List<Question> newQuestions) {
    final viewModels =
        newQuestions.map(QuestionsOverviewItemViewModel.fromQuestion).toList();

    _viewModel = _viewModel.copyWith(
      questions: viewModels,
      isRandomQuestionButtonEnabled: viewModels.isNotEmpty,
    );

    emit(QuestionsOverviewState.viewModelUpdated(viewModel: _viewModel));
  }
}
