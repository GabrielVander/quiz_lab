import '../../../domain/entities/question.dart';
import '../models/hive_question_model.dart';

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
