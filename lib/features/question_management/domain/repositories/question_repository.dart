import '../entities/question.dart';

abstract class QuestionRepository {
  Stream<List<Question>> watchAll();

  Future<void> deleteSingle(String id);

  Future<void> createSingle(Question question);

  Future<void> updateSingle(Question question);
}
