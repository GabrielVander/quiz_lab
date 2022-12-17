import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';

void main() {
  late MapperFactory mapperFactory;

  setUp(() {
    mapperFactory = MapperFactory();
  });

  group('makeQuestionEntityMapper', () {
    test('should return QuestionEntityMapper', () {
      final result = mapperFactory.makeQuestionEntityMapper();

      expect(result, isA<QuestionEntityMapper>());
    });
  });

  group('makeQuestionOverviewItemViewModelMapper', () {
    test('should return HiveQuestionMapper', () {
      final result = mapperFactory.makeQuestionOverviewItemViewModelMapper();

      expect(result, isA<QuestionOverviewItemViewModelMapper>());
    });
  });
}
