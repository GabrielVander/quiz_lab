import 'package:appwrite/appwrite.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/presentation/bloc/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/environment.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:uuid/uuid.dart';

void questionManagementDiSetup(DependencyInjection di) {
  di
    ..registerInstance<AppwriteQuestionCollectionId>(
      (_) => AppwriteQuestionCollectionId(
        value:
            EnvironmentVariable.appwriteQuestionCollectionId.getRequiredValue,
      ),
    )
    ..registerBuilder<QuestionCollectionAppwriteDataSource>(
      (DependencyInjection i) => QuestionCollectionAppwriteDataSourceImpl(
        logger: QuizLabLoggerImpl<QuestionCollectionAppwriteDataSourceImpl>(),
        appwriteDatabaseId: i.get<AppwriteDatabaseId>().value,
        appwriteQuestionCollectionId:
            i.get<AppwriteQuestionCollectionId>().value,
        appwriteWrapper: i.get<AppwriteWrapper>(),
        databases: i.get<Databases>(),
      ),
    )
    ..registerBuilder<QuestionRepository>(
      (DependencyInjection i) => QuestionRepositoryImpl(
        logger: QuizLabLoggerImpl<QuestionRepositoryImpl>(),
        appwriteDataSource: i.get<AppwriteDataSource>(),
        questionsAppwriteDataSource:
            i.get<QuestionCollectionAppwriteDataSource>(),
      ),
    )
    ..registerBuilder(
      (i) => WatchAllQuestionsUseCase(
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      (DependencyInjection i) => CreateQuestionUseCaseImpl(
        logger: QuizLabLoggerImpl<CreateQuestionUseCaseImpl>(),
        uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      (DependencyInjection i) => UpdateQuestionUseCase(
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      (DependencyInjection i) => DeleteQuestionUseCase(
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<GetSingleQuestionUseCase>(
      (DependencyInjection i) => GetSingleQuestionUseCase(
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<AssessmentsOverviewCubit>(
      (DependencyInjection i) => AssessmentsOverviewCubit(),
    )
    ..registerBuilder<QuestionCreationCubit>(
      (DependencyInjection i) => QuestionCreationCubit(
        logger: QuizLabLoggerImpl<QuestionCreationCubit>(),
        createQuestionUseCase: i.get<CreateQuestionUseCase>(),
      ),
    )
    ..registerBuilder<QuestionsOverviewCubit>(
      (DependencyInjection i) => QuestionsOverviewCubit(
        updateQuestionUseCase: i.get<UpdateQuestionUseCase>(),
        deleteQuestionUseCase: i.get<DeleteQuestionUseCase>(),
        watchAllQuestionsUseCase: i.get<WatchAllQuestionsUseCase>(),
      ),
    )
    ..registerBuilder<QuestionDisplayCubit>(
      (DependencyInjection i) => QuestionDisplayCubit(
        getSingleQuestionUseCase: i.get<GetSingleQuestionUseCase>(),
      ),
    );
}

class AppwriteQuestionCollectionId {
  const AppwriteQuestionCollectionId({
    required this.value,
  });

  final String value;
}
