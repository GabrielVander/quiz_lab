import 'package:quiz_lab/core/data/connectors/appwrite_connector.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_appwrite_data_source.dart';
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
  di..registerBuilder<QuestionsAppwriteDataSource>(
        (DependencyInjection i) =>
        QuestionsAppwriteDataSource(
          config: QuestionsAppwriteDataSourceConfig(
            databaseId: i
                .get<AppwriteReferencesConfig>()
                .databaseId,
            collectionId: i
                .get<AppwriteReferencesConfig>()
                .questionsCollectionId,
          ),
          appwriteConnector: i.get<AppwriteConnector>(),
        ),
  )..registerBuilder<QuestionRepository>(
        (DependencyInjection i) =>
        QuestionRepositoryAppwriteImpl(
          appwriteDataSource: i.get<AppwriteDataSource>(),
          questionsAppwriteDataSource: i.get<QuestionsAppwriteDataSource>(),
        ),
  )..registerBuilder(
        (i) =>
        WatchAllQuestionsUseCase(
          questionRepository: i.get<QuestionRepository>(),
        ),
  )..registerBuilder<CreateQuestionUseCase>(
        (DependencyInjection i) => CreateQuestionUseCase(
        uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
        questionRepository: i.get<QuestionRepository>(),
      ),
  )..registerBuilder<UpdateQuestionUseCase>(
        (DependencyInjection i) =>
        UpdateQuestionUseCase(
          questionRepository: i.get<QuestionRepository>(),
        ),
  )..registerBuilder<DeleteQuestionUseCase>(
        (DependencyInjection i) =>
        DeleteQuestionUseCase(
          questionRepository: i.get<QuestionRepository>(),
        ),
  )..registerBuilder<GetSingleQuestionUseCase>(
        (DependencyInjection i) =>
        GetSingleQuestionUseCase(
          questionRepository: i.get<QuestionRepository>(),
        ),
  )..registerBuilder<UseCaseFactory>(
        (DependencyInjection i) =>
        UseCaseFactory(
          watchAllQuestionsUseCase: i.get<WatchAllQuestionsUseCase>(),
          createQuestionUseCase: i.get<CreateQuestionUseCase>(),
          deleteQuestionUseCase: i.get<DeleteQuestionUseCase>(),
          getSingleQuestionUseCase: i.get<GetSingleQuestionUseCase>(),
          updateQuestionUseCase: i.get<UpdateQuestionUseCase>(),
        ),
  )..registerBuilder<PresentationMapperFactory>(
        (i) => PresentationMapperFactory(),
    )..registerBuilder<AssessmentsOverviewCubit>(
        (DependencyInjection i) => AssessmentsOverviewCubit(),
    )..registerBuilder<QuestionCreationCubit>(
        (DependencyInjection i) =>
        QuestionCreationCubit(
          useCaseFactory: i.get(),
        ),
  )..registerBuilder<QuestionsOverviewCubit>(
        (DependencyInjection i) =>
        QuestionsOverviewCubit(
          useCaseFactory: i.get<UseCaseFactory>(),
          mapperFactory: i.get<PresentationMapperFactory>(),
        ),
  )..registerBuilder<QuestionDisplayCubit>(
      (DependencyInjection i) => QuestionDisplayCubit(
        useCaseFactory: i.get<UseCaseFactory>(),
      ),
    );
}
