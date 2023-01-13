import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/questions_overview_view_model.dart';

class QuestionOverviewItemViewModelMapper {
  QuestionsOverviewItemViewModel singleFromQuestionEntity(
    Question question,
  ) {
    return QuestionsOverviewItemViewModel(
      id: question.id,
      shortDescription: question.shortDescription,
      description: question.description,
      categories: question.categories.map((c) => c.value).toList(),
      difficulty: question.difficulty.name,
    );
  }

  List<QuestionsOverviewItemViewModel> multipleFromQuestionEntity(
    List<Question> questions,
  ) {
    return questions.map(singleFromQuestionEntity).toList();
  }
}
