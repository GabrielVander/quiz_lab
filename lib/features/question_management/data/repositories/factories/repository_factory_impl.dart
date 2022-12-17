import 'package:hive/hive.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class RepositoryFactoryImpl implements RepositoryFactory {
  @override
  QuestionRepository makeQuestionRepository() {
    return QuestionRepositoryImpl(
      dataSourceFactory: DataSourceFactory(hiveInterface: Hive),
      mapperFactory: MapperFactory(),
    );
  }
}
