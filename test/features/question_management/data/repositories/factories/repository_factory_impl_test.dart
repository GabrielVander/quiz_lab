import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/repositories/factories/repository_factory_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

void main() {
  late RepositoryFactoryImpl repositoryFactoryImpl;

  setUp(() {
    repositoryFactoryImpl = RepositoryFactoryImpl();
  });

  group('makeQuestionRepository', () {
    test('should return QuestionRepository', () {
      final result = repositoryFactoryImpl.makeQuestionRepository();

      expect(result, isA<QuestionRepository>());
    });
  });
}
