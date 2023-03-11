import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_appwrite_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:uuid/uuid.dart';

void questionManagementDiSetup(DependencyInjection di) {
  di
    ..registerBuilder<QuestionRepository>(
      (DependencyInjection di) => QuestionRepositoryAppwriteImpl(
        appwriteDataSource: di.get<AppwriteDataSource>(),
      ),
    )
    ..registerBuilder(
      (di) => WatchAllQuestionsUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      (DependencyInjection di) => CreateQuestionUseCase(
        uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      (DependencyInjection di) => UpdateQuestionUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      (DependencyInjection di) => DeleteQuestionUseCase(
        questionRepository: di.get<QuestionRepository>(),
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
        useCaseFactory: di.get(),
      ),
    )
    ..registerBuilder<QuestionsOverviewCubit>(
      (DependencyInjection di) => QuestionsOverviewCubit(
        useCaseFactory: di.get<UseCaseFactory>(),
        mapperFactory: di.get<PresentationMapperFactory>(),
      ),
    )
    ..registerBuilder<QuestionDisplayCubit>(
      (DependencyInjection di) => QuestionDisplayCubit(
        useCaseFactory: di.get<UseCaseFactory>(),
      ),
    );
}
