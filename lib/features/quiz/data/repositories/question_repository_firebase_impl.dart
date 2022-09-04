import 'package:quiz_lab/features/quiz/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';

class QuestionRepositoryFirebaseImpl implements QuestionRepository {
  const QuestionRepositoryFirebaseImpl({
    required this.dataSource,
  });

  final FirebaseDataSource dataSource;

  @override
  Stream<Question> fetchAll() {
    return dataSource.fetchPublicQuestions().map((model) => model.toEntity());
  }
}
