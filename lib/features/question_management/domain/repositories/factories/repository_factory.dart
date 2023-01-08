import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

// ignore: one_member_abstracts
abstract class RepositoryFactory {
  QuestionRepository makeQuestionRepository();
}
