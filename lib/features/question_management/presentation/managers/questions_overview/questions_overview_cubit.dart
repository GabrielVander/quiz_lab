import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

part 'questions_overview_state.dart';

class QuestionsOverviewCubit extends Cubit<QuestionsOverviewState>
    implements Manager {
  QuestionsOverviewCubit({
    required WatchAllQuestionsUseCase watchAllQuestionsUseCase,
    required DeleteQuestionUseCase deleteQuestionUseCase,
    required UpdateQuestionUseCase updateQuestionUseCase,
    required QuestionEntityMapper questionEntityMapper,
    required QuestionOverviewItemViewModelMapper
        questionOverviewItemViewModelMapper,
  })  : _updateQuestionUseCase = updateQuestionUseCase,
        _deleteQuestionUseCase = deleteQuestionUseCase,
        _watchAllQuestionsUseCase = watchAllQuestionsUseCase,
        _questionEntityMapper = questionEntityMapper,
        _questionOverviewItemViewModelMapper =
            questionOverviewItemViewModelMapper,
        super(QuestionsOverviewState.initial());

  final WatchAllQuestionsUseCase _watchAllQuestionsUseCase;
  final DeleteQuestionUseCase _deleteQuestionUseCase;
  final UpdateQuestionUseCase _updateQuestionUseCase;
  final QuestionEntityMapper _questionEntityMapper;
  final QuestionOverviewItemViewModelMapper
      _questionOverviewItemViewModelMapper;

  Future<void> updateQuestions() async {
    emit(QuestionsOverviewState.loading());

    _watchQuestions();
  }

  Future<void> removeQuestion(QuestionOverviewItemViewModel question) async {
    await _deleteQuestionUseCase.execute(question.id);
  }

  Future<void> onQuestionSaved(QuestionOverviewItemViewModel viewModel) async {
    if (viewModel.shortDescription.isNotEmpty) {
      emit(QuestionsOverviewState.loading());

      final asQuestionEntityMappingResult = _questionEntityMapper
          .singleFromQuestionOverviewItemViewModel(viewModel);

      if (asQuestionEntityMappingResult.isErr) {
        emit(
          QuestionsOverviewState.error(
            message: asQuestionEntityMappingResult.err!.message,
          ),
        );
      }

      final updateResult = await _updateQuestionUseCase.execute(
        asQuestionEntityMappingResult.ok!,
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
    final viewModels = _questionOverviewItemViewModelMapper
        .multipleFromQuestionEntity(newQuestions);

    emit(
      QuestionsOverviewState.questionListUpdated(questions: viewModels),
    );
  }
}
