import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

class QuestionOverviewItemViewModelMapper {
  QuestionOverviewItemViewModel singleFromQuestionEntity(
    Question question,
  ) {
    return QuestionOverviewItemViewModel(
      id: question.id,
      shortDescription: question.shortDescription,
      description: question.description,
      categories: question.categories.map((c) => c.value).toList(),
      difficulty: question.difficulty.name,
    );
  }

  List<QuestionOverviewItemViewModel> multipleFromQuestionEntity(
    List<Question> questions,
  ) {
    return questions.map(singleFromQuestionEntity).toList();
  }
}
