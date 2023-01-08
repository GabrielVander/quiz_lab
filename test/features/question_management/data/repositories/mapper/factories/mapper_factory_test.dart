import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';

void main() {
  late MapperFactory mapperFactory;

  setUp(() {
    mapperFactory = MapperFactory();
  });

  group('makeQuestionEntityMapper', () {
    test('should return QuestionMapper', () {
      final result = mapperFactory.makeQuestionEntityMapper();

      expect(result, isA<QuestionEntityMapper>());
    });
  });

  group('makeHiveQuestionModelMapper', () {
    test('should return HiveQuestionMapper', () {
      final result = mapperFactory.makeHiveQuestionModelMapper();

      expect(result, isA<HiveQuestionModelMapper>());
    });
  });
}
