import 'package:quiz_lab/features/quiz/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/models/question_model.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';

class QuestionRepositoryFirebaseImpl implements QuestionRepository {
  const QuestionRepositoryFirebaseImpl({
    required this.dataSource,
  });

  final FirebaseDataSource dataSource;

  @override
  Stream<List<Question>> watchAll() {
    return dataSource
        .watchPublicQuestions()
        .map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Future<void> deleteSingle(String id) async {
    await dataSource.deletePublicQuestionById(id);
  }

  @override
  Future<void> createSingle(Question question) async {
    await dataSource.createPublicQuestion(QuestionModel.fromEntity(question));
  }

  @override
  Future<void> updateSingle(Question question) async {
    await dataSource.updateQuestion(QuestionModel.fromEntity(question));
  }
}
