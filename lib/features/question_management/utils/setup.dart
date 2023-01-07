import 'package:hive/hive.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/factories/repository_factory_impl.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/question_management_cubit_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:uuid/uuid.dart';

void questionManagementDiSetup(DependencyInjection di) {
  di
    ..registerBuilder<QuestionRepository>(
      (DependencyInjection di) => QuestionRepositoryImpl(
        dataSourceFactory: DataSourceFactory(hiveInterface: Hive),
        mapperFactory: MapperFactory(),
      ),
    )
    ..registerBuilder<RepositoryFactory>(
      (DependencyInjection di) => RepositoryFactoryImpl(),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      (DependencyInjection di) => CreateQuestionUseCase(
        uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
        repositoryFactory: di.get<RepositoryFactory>(),
      ),
    )
    ..registerBuilder<UseCaseFactory>(
      (DependencyInjection di) =>
          UseCaseFactory(repositoryFactory: di.get<RepositoryFactory>()),
    )
    ..registerBuilder<PresentationMapperFactory>(
      (di) => PresentationMapperFactory(),
    )
    ..registerBuilder<AssessmentsOverviewCubit>(
      (DependencyInjection di) => AssessmentsOverviewCubit(),
    )
    ..registerBuilder<QuestionManagementCubitFactory>(
      (DependencyInjection di) => QuestionManagementCubitFactory(
        useCaseFactory: di.get<UseCaseFactory>(),
        presentationMapperFactory: di.get<PresentationMapperFactory>(),
      ),
    );
}
