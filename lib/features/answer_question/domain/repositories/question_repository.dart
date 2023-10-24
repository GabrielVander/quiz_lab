import 'package:okay/okay.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart';

// ignore: one_member_abstracts
abstract interface class QuestionRepository {
  Future<Result<AnswerableQuestion, String>> fetchQuestionWithId(String id);
}
