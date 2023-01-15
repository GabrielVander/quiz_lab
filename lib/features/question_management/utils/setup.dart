import 'package:hive/hive.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/factories/repository_factory_impl.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/question_management_cubit_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
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
    ..registerBuilder(
      (di) => WatchAllQuestionsUseCase(
        logger: di.get<QuizLabLogger>(),
        repositoryFactory: di.get<RepositoryFactory>(),
      ),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      (DependencyInjection di) => CreateQuestionUseCase(
        uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
        repositoryFactory: di.get<RepositoryFactory>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      (DependencyInjection di) => UpdateQuestionUseCase(
        repositoryFactory: di.get<RepositoryFactory>(),
      ),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      (DependencyInjection di) => DeleteQuestionUseCase(
        repositoryFactory: di.get<RepositoryFactory>(),
      ),
    )
    ..registerBuilder<GetSingleQuestionUseCase>(
      (DependencyInjection di) => GetSingleQuestionUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UseCaseFactory>(
      (DependencyInjection di) => UseCaseFactory(
        watchAllQuestionsUseCase: di.get<WatchAllQuestionsUseCase>(),
        createQuestionUseCase: di.get<CreateQuestionUseCase>(),
        deleteQuestionUseCase: di.get<DeleteQuestionUseCase>(),
        getSingleQuestionUseCase: di.get<GetSingleQuestionUseCase>(),
        updateQuestionUseCase: di.get<UpdateQuestionUseCase>(),
      ),
    )
    ..registerBuilder<PresentationMapperFactory>(
      (di) => PresentationMapperFactory(),
    )
    ..registerBuilder<AssessmentsOverviewCubit>(
      (DependencyInjection di) => AssessmentsOverviewCubit(),
    )
    ..registerBuilder<QuestionCreationCubit>(
      (DependencyInjection di) => QuestionCreationCubit(
        logger: di.get(),
        useCaseFactory: di.get(),
      ),
    )
    ..registerBuilder<QuestionsOverviewCubit>(
      (DependencyInjection di) => QuestionsOverviewCubit(
        logger: di.get<QuizLabLogger>(),
        useCaseFactory: di.get<UseCaseFactory>(),
        mapperFactory: di.get<PresentationMapperFactory>(),
      ),
    )
    ..registerBuilder<QuestionManagementCubitFactory>(
      (DependencyInjection di) => QuestionManagementCubitFactory(
        questionCreationCubit: di.get<QuestionCreationCubit>(),
        useCaseFactory: di.get<UseCaseFactory>(),
        presentationMapperFactory: di.get<PresentationMapperFactory>(),
        questionsOverviewCubit: di.get(),
      ),
    );
}
