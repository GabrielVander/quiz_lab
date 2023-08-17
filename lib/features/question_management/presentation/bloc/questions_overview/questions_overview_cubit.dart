import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/view_models/questions_overview_view_model.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit({
    required UpdateQuestionUseCase updateQuestionUseCase,
    required DeleteQuestionUseCase deleteQuestionUseCase,
    required WatchAllQuestionsUseCase watchAllQuestionsUseCase,
  })  : _updateQuestionUseCase = updateQuestionUseCase,
        _deleteQuestionUseCase = deleteQuestionUseCase,
        _watchAllQuestionsUseCase = watchAllQuestionsUseCase,
        super(const QuestionsOverviewInitial()) {
    _viewModel = _defaultViewModel;
  }

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<QuestionsOverviewCubit>();

  final UpdateQuestionUseCase _updateQuestionUseCase;
  final DeleteQuestionUseCase _deleteQuestionUseCase;
  final WatchAllQuestionsUseCase _watchAllQuestionsUseCase;

  final QuestionsOverviewViewModel _defaultViewModel =
      const QuestionsOverviewViewModel(
    questions: [],
    isRandomQuestionButtonEnabled: false,
  );

  late QuestionsOverviewViewModel _viewModel;

  final _questionStreamController = StreamController<List<Question>>();

  void updateQuestions() {
    _logger.info('Updating questions...');
    emit(const QuestionsOverviewLoading());

    _watchQuestions();
  }

  Future<void> removeQuestion(QuestionsOverviewItemViewModel question) async {
    emit(const QuestionsOverviewLoading());

    await _deleteQuestion(question);
  }

  Future<void> onQuestionSaved(QuestionsOverviewItemViewModel viewModel) async {
    if (viewModel.shortDescription.isNotEmpty) {
      emit(const QuestionsOverviewLoading());
      final viewModelAsQuestion = viewModel.toQuestion();

      final updateResult =
          await _updateQuestionUseCase.execute(viewModelAsQuestion);

      updateResult.when(
        ok: (_) {},
        err: (failure) => emit(
          QuestionsOverviewErrorOccurred(message: failure.message),
        ),
      );
    }
  }

  void onOpenRandomQuestion() {
    emit(const QuestionsOverviewLoading());
    _logger.info('Opening random question...');

    final ids = _viewModel.questions.map((q) => q.id).toList()..shuffle();
    final randomQuestionId = ids.first;

    _emitOpenQuestion(randomQuestionId);
  }

  void onQuestionClick(QuestionsOverviewItemViewModel viewModel) =>
      _emitOpenQuestion(viewModel.id);

  Future<void> _watchQuestions() async {
    final watchResult = await _watchAllQuestionsUseCase.execute();

    await watchResult.when(
      ok: (questionsStream) async {
        _questionStreamController.stream.listen(_emitNewQuestions);

        await questionsStream.pipe(_questionStreamController);
      },
      err: (failure) {
        emit(
          QuestionsOverviewErrorOccurred(
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

    emit(QuestionsOverviewViewModelUpdated(viewModel: _viewModel));
  }

  void _emitOpenQuestion(String id) {
    _logger.info('Opening question $id...');

    emit(QuestionsOverviewOpenQuestion(questionId: id));
    emit(QuestionsOverviewViewModelUpdated(viewModel: _viewModel));
  }
}
