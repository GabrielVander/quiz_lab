import 'package:quiz_lab/features/question_management/data/repositories/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';

class MapperFactory {
  QuestionEntityMapper makeQuestionEntityMapper() {
    return QuestionEntityMapper();
  }

  HiveQuestionModelMapper makeHiveQuestionModelMapper() {
    return HiveQuestionModelMapper();
  }
}
