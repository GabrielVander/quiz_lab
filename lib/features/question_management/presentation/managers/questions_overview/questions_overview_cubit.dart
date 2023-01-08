import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState> {
  QuestionsOverviewCubit({
    required UseCaseFactory useCaseFactory,
    required PresentationMapperFactory mapperFactory,
  })  : _useCaseFactory = useCaseFactory,
        _mapperFactory = mapperFactory,
        super(QuestionsOverviewState.initial());

  final UseCaseFactory _useCaseFactory;
  final PresentationMapperFactory _mapperFactory;

  final _questionStreamController = StreamController<List<Question>>();

  void updateQuestions() {
    emit(QuestionsOverviewState.loading());

    _watchQuestions();
  }

  Future<void> removeQuestion(QuestionOverviewItemViewModel question) async {
    emit(QuestionsOverviewState.loading());

    await _deleteQuestion(question);
  }

  Future<void> onQuestionSaved(QuestionOverviewItemViewModel viewModel) async {
    if (viewModel.shortDescription.isNotEmpty) {
      emit(QuestionsOverviewState.loading());

      final questionEntityMapper = _mapperFactory.makeQuestionEntityMapper();

      final asQuestionEntityMappingResult = questionEntityMapper
          .singleFromQuestionOverviewItemViewModel(viewModel);

      if (asQuestionEntityMappingResult.isErr) {
        emit(
          QuestionsOverviewState.error(
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
        emit(QuestionsOverviewState.error(message: updateResult.err!.message));
      }
    }
  }

  Future<void> _deleteQuestion(QuestionOverviewItemViewModel question) async {
    final deleteQuestionUseCase = _useCaseFactory.makeDeleteQuestionUseCase();

    await deleteQuestionUseCase.execute(question.id);
  }

  void _watchQuestions() {
    final watchAllQuestionsUseCase =
        _useCaseFactory.makeWatchAllQuestionsUseCase();

    final watchResult = watchAllQuestionsUseCase.execute();

    if (watchResult.isErr) {
      emit(QuestionsOverviewState.error(message: watchResult.err!.message));
      return;
    }

    _questionStreamController.stream.listen(_emitNewQuestions);

    watchResult.ok!.pipe(_questionStreamController);
  }

  void _emitNewQuestions(List<Question> newQuestions) {
    final questionOverviewItemViewModelMapper =
        _mapperFactory.makeQuestionOverviewItemViewModelMapper();

    final viewModels = questionOverviewItemViewModelMapper
        .multipleFromQuestionEntity(newQuestions);

    emit(
      QuestionsOverviewState.questionListUpdated(questions: viewModels),
    );
  }
}
