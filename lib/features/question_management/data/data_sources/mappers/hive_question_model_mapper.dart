import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';

class HiveQuestionModelMapper {
  HiveQuestionModel fromQuestion(
    Question question,
  ) =>
      HiveQuestionModel(
        id: _parseIdFromQuestion(question),
        shortDescription: _parseShortDescriptionFromQuestion(question),
        description: _parseDescriptionFromQuestion(question),
        difficulty: _parseDifficultyFromQuestion(question),
        categories: _parseCategoriesFromQuestion(question),
      );

  String? _parseIdFromQuestion(Question question) => question.id;

  String _parseDescriptionFromQuestion(Question question) =>
      question.description;

  String _parseShortDescriptionFromQuestion(Question question) =>
      question.shortDescription;

  String _parseDifficultyFromQuestion(Question question) =>
      question.difficulty.name;

  List<String> _parseCategoriesFromQuestion(Question question) =>
      question.categories.map((e) => e.value).toList();
}
