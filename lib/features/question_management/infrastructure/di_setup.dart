import 'package:appwrite/appwrite.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/data/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/utils/appwrite_references_config.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/profile_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_can_create_public_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/wrappers/package_info_wrapper.dart';

void questionManagementDiSetup(DependencyInjection di) {
  di
    ..registerFactory<AppwriteWrapper>(
      (i) => AppwriteWrapper(
        databases: i.get<Databases>(),
      ),
    )
    ..registerFactory<PackageInfoWrapper>(
      (i) => PackageInfoWrapper(packageInfo: i.get<PackageInfo>()),
    );

  _registerDataSources(di);
  _registerRepositories(di);
  _registerUseCases(di);
  _registerCubits(di);
}

void _registerDataSources(DependencyInjection di) {
  di
    ..registerBuilder<QuestionCollectionAppwriteDataSource>(
      (i) => QuestionCollectionAppwriteDataSourceImpl(
        logger: QuizLabLoggerImpl<QuestionCollectionAppwriteDataSourceImpl>(),
        appwriteDatabaseId: i.get<AppwriteReferencesConfig>().databaseId,
        appwriteQuestionCollectionId: i.get<AppwriteReferencesConfig>().questionCollectionId,
        appwriteWrapper: i.get<AppwriteWrapper>(),
        databases: i.get<Databases>(),
        realtime: i.get<Realtime>(),
      ),
    )
    ..registerBuilder<ProfileCollectionAppwriteDataSource>(
      (i) => ProfileCollectionAppwriteDataSourceImpl(
        logger: QuizLabLoggerImpl<ProfileCollectionAppwriteDataSourceImpl>(),
        appwriteDatabaseId: i.get<AppwriteReferencesConfig>().databaseId,
        appwriteProfileCollectionId: i.get<AppwriteReferencesConfig>().profileCollectionId,
        databases: i.get<Databases>(),
      ),
    )
    ..registerBuilder<AuthAppwriteDataSource>(
      (DependencyInjection di) => AuthAppwriteDataSourceImpl(
        logger: QuizLabLoggerImpl<AuthAppwriteDataSourceImpl>(),
        appwriteAccountService: di.get<Account>(),
      ),
    );
}

void _registerRepositories(DependencyInjection di) {
  di
    ..registerBuilder<QuestionRepository>(
      (i) => QuestionRepositoryImpl(
        logger: QuizLabLoggerImpl<QuestionRepositoryImpl>(),
        questionsAppwriteDataSource: i.get<QuestionCollectionAppwriteDataSource>(),
        authAppwriteDataSource: i.get<AuthAppwriteDataSource>(),
        profileAppwriteDataSource: i.get<ProfileCollectionAppwriteDataSource>(),
      ),
    )
    ..registerBuilder<AuthRepository>(
      (DependencyInjection di) => AuthRepositoryImpl(
        logger: QuizLabLoggerImpl<AuthRepositoryImpl>(),
        authDataSource: di.get<AuthAppwriteDataSource>(),
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
        questionRepository: i.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      (i) => UpdateQuestionUseCase(questionRepository: i.get<QuestionRepository>()),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      (i) => DeleteQuestionUseCase(questionRepository: i.get<QuestionRepository>()),
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
    ..registerBuilder<LoginCubit>(
      (di) => LoginCubit(
        logger: QuizLabLoggerImpl<LoginCubit>(),
        loginWithCredentialsUseCase: di.get<LoginWithCredentialsUseCase>(),
        loginAnonymouslyUseCase: di.get<LoginAnonymouslyUseCase>(),
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
    ..registerFactory<NetworkCubit>((_) => NetworkCubit())
    ..registerFactory<BottomNavigationCubit>((_) => BottomNavigationCubit());
}
