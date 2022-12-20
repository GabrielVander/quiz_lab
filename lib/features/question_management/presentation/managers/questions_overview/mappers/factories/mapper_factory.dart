import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';

class MapperFactory {
  QuestionEntityMapper makeQuestionEntityMapper() => QuestionEntityMapper();

  QuestionOverviewItemViewModelMapper
      makeQuestionOverviewItemViewModelMapper() =>
          QuestionOverviewItemViewModelMapper();
}
