import 'package:quiz_lab/features/quiz/domain/entities/question.dart';

abstract class QuestionRepository {
  Stream<Question> fetchAll();
}
