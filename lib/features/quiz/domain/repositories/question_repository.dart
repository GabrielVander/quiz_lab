import 'package:quiz_lab/features/quiz/domain/entities/question.dart';

abstract class QuestionRepository {
  Future<Stream<Question>> fetchAll();
}
