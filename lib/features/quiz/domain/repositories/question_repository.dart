import 'package:quiz_lab/features/quiz/domain/entities/question.dart';

abstract class QuestionRepository {
  Stream<List<Question>> watchAll();

  Future<void> deleteSingle(String id);

  Future<void> createSingle(Question question);
}
