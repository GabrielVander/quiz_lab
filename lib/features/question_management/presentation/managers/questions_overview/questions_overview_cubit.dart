import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/questions_overview_view_model.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit({
    required QuizLabLogger logger,
    required UseCaseFactory useCaseFactory,
    required PresentationMapperFactory mapperFactory,
  })  : _logger = logger,
        _useCaseFactory = useCaseFactory,
        _mapperFactory = mapperFactory,
        super(QuestionsOverviewState.initial());

  final QuizLabLogger _logger;
  final UseCaseFactory _useCaseFactory;
  final PresentationMapperFactory _mapperFactory;

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

      final questionEntityMapper = _mapperFactory.makeQuestionEntityMapper();

      final asQuestionEntityMappingResult = questionEntityMapper
          .singleFromQuestionOverviewItemViewModel(viewModel);

      if (asQuestionEntityMappingResult.isErr) {
        emit(
          QuestionsOverviewState.errorOccurred(
            message: asQuestionEntityMappingResult.err!.message,
          ),
        );

        return;
      }

      final updateQuestionUseCase = _useCaseFactory.makeUpdateQuestionUseCase();

      final updateResult = await updateQuestionUseCase.execute(
        asQuestionEntityMappingResult.ok!,
      );

      if (updateResult.isErr) {
        emit(
          QuestionsOverviewState.errorOccurred(
            message: updateResult.err!.message,
          ),
        );
      }
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

  Future<void> _deleteQuestion(QuestionsOverviewItemViewModel question) async {
    final deleteQuestionUseCase = _useCaseFactory.makeDeleteQuestionUseCase();

    await deleteQuestionUseCase.execute(question.id);
  }

  void _watchQuestions() {
    final watchAllQuestionsUseCase =
        _useCaseFactory.makeWatchAllQuestionsUseCase();

    final watchResult = watchAllQuestionsUseCase.execute();

    if (watchResult.isErr) {
      emit(
        QuestionsOverviewState.errorOccurred(
          message: watchResult.err!.message,
        ),
      );
      return;
    }

    _questionStreamController.stream.listen(_emitNewQuestions);

    watchResult.ok!.pipe(_questionStreamController);
  }

  void _emitNewQuestions(List<Question> newQuestions) {
    final questionOverviewItemViewModelMapper =
        _mapperFactory.makeQuestionOverviewItemViewModelMapper();

    final itemViewModels = questionOverviewItemViewModelMapper
        .multipleFromQuestionEntity(newQuestions);

    _viewModel = _viewModel.copyWith(
      questions: itemViewModels,
      isRandomQuestionButtonEnabled: itemViewModels.isNotEmpty,
    );

    emit(QuestionsOverviewState.viewModelUpdated(viewModel: _viewModel));
  }
}
