import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';

// ignore: one_member_abstracts
abstract interface class QuestionRepository {
  Future<Result<Question, String>> fetchQuestionWithId(String id);
}
