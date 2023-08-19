import 'package:appwrite/appwrite.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/domain/repository/auth_repository.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/presentation/bloc/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_can_create_public_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:uuid/uuid.dart';

void questionManagementDiSetup(DependencyInjection di) {
  _registerDataSources(di);
  _registerRepositories(di);
  _registerUseCases(di);
  _registerCubits(di);
}

void _registerDataSources(DependencyInjection di) {
  di.registerBuilder<QuestionCollectionAppwriteDataSource>(
    (i) => QuestionCollectionAppwriteDataSourceImpl(
      logger: QuizLabLoggerImpl<QuestionCollectionAppwriteDataSourceImpl>(),
      appwriteDatabaseId: i.get<AppwriteDatabaseId>().value,
      appwriteQuestionCollectionId: i.get<AppwriteQuestionCollectionId>().value,
      appwriteWrapper: i.get<AppwriteWrapper>(),
      databases: i.get<Databases>(),
    ),
  );
}

void _registerRepositories(DependencyInjection di) {
  di.registerBuilder<QuestionRepository>(
    (i) => QuestionRepositoryImpl(
      logger: QuizLabLoggerImpl<QuestionRepositoryImpl>(),
      appwriteDataSource: i.get<AppwriteDataSource>(),
      questionsAppwriteDataSource: i.get<QuestionCollectionAppwriteDataSource>(),
    ),
  );
}

void _registerUseCases(DependencyInjection di) {
  di
    ..registerBuilder<WatchAllQuestionsUseCase>(
      (i) => WatchAllQuestionsUseCase(questionRepository: i.get<QuestionRepository>()),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      (i) => CreateQuestionUseCaseImpl(
        logger: QuizLabLoggerImpl<CreateQuestionUseCaseImpl>(),
        uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      (i) => UpdateQuestionUseCase(questionRepository: i.get<QuestionRepository>()),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      (i) => DeleteQuestionUseCase(questionRepository: i.get<QuestionRepository>()),
    )
    ..registerBuilder<GetSingleQuestionUseCase>(
      (i) => GetSingleQuestionUseCase(questionRepository: i.get<QuestionRepository>()),
    )
    ..registerBuilder<CheckIfUserCanCreatePublicQuestionsUseCase>(
      (i) => CheckIfUserCanCreatePublicQuestionsUseCaseImpl(
        logger: QuizLabLoggerImpl<CheckIfUserCanCreatePublicQuestionsUseCaseImpl>(),
        authRepository: i.get<AuthRepository>(),
      ),
    )
    ..registerBuilder<LoginWithCredentialsUseCase>(
      (di) => LoginWithCredentialsUseCaseImpl(authRepository: di.get<AuthRepository>()),
    )
    ..registerBuilder<LoginAnonymouslyUseCase>(
      (di) => LoginAnonymouslyUseCaseImpl(
        logger: QuizLabLoggerImpl<LoginAnonymouslyUseCaseImpl>(),
        authRepository: di.get<AuthRepository>(),
      ),
    )
    ..registerBuilder<CheckIfUserIsLoggedInUseCase>(
      (di) => CheckIfUserIsLoggedInUseCaseImpl(
        logger: QuizLabLoggerImpl<CheckIfUserIsLoggedInUseCaseImpl>(),
        authRepository: di.get<AuthRepository>(),
      ),
    );
}

void _registerCubits(DependencyInjection di) {
  di
    ..registerBuilder<LoginPageCubit>(
      (di) => LoginPageCubit(
        logger: QuizLabLoggerImpl<LoginPageCubit>(),
        loginWithCredentionsUseCase: di.get<LoginWithCredentialsUseCase>(),
        loginAnonymouslyUseCase: di.get<LoginAnonymouslyUseCase>(),
        fetchApplicationVersionUseCase: di.get<FetchApplicationVersionUseCase>(),
      ),
    )
    ..registerBuilder<AssessmentsOverviewCubit>((i) => AssessmentsOverviewCubit())
    ..registerBuilder<QuestionCreationCubit>(
      (i) => QuestionCreationCubit(
        logger: QuizLabLoggerImpl<QuestionCreationCubit>(),
        createQuestionUseCase: i.get<CreateQuestionUseCase>(),
        checkIfUserCanCreatePublicQuestionsUseCase: i.get<CheckIfUserCanCreatePublicQuestionsUseCase>(),
      ),
    )
    ..registerBuilder<QuestionsOverviewCubit>(
      (i) => QuestionsOverviewCubit(
        updateQuestionUseCase: i.get<UpdateQuestionUseCase>(),
        deleteQuestionUseCase: i.get<DeleteQuestionUseCase>(),
        watchAllQuestionsUseCase: i.get<WatchAllQuestionsUseCase>(),
      ),
    )
    ..registerBuilder<QuestionDisplayCubit>(
      (i) => QuestionDisplayCubit(getSingleQuestionUseCase: i.get<GetSingleQuestionUseCase>()),
    );
}

class AppwriteQuestionCollectionId {
  const AppwriteQuestionCollectionId({
    required this.value,
  });

  final String value;
}
