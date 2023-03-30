import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

class UseCaseFactory {
  const UseCaseFactory({
    required WatchAllQuestionsUseCase watchAllQuestionsUseCase,
    required CreateQuestionUseCase createQuestionUseCase,
    required UpdateQuestionUseCase updateQuestionUseCase,
    required DeleteQuestionUseCase deleteQuestionUseCase,
  })  : _watchAllQuestionsUseCase = watchAllQuestionsUseCase,
        _createQuestionUseCase = createQuestionUseCase,
        _updateQuestionUseCase = updateQuestionUseCase,
        _deleteQuestionUseCase = deleteQuestionUseCase;

  final WatchAllQuestionsUseCase _watchAllQuestionsUseCase;
  final CreateQuestionUseCase _createQuestionUseCase;
  final UpdateQuestionUseCase _updateQuestionUseCase;
  final DeleteQuestionUseCase _deleteQuestionUseCase;

  WatchAllQuestionsUseCase makeWatchAllQuestionsUseCase() =>
      _watchAllQuestionsUseCase;

  CreateQuestionUseCase makeCreateQuestionUseCase() => _createQuestionUseCase;

  UpdateQuestionUseCase makeUpdateQuestionUseCase() => _updateQuestionUseCase;

  DeleteQuestionUseCase makeDeleteQuestionUseCase() => _deleteQuestionUseCase;
}
