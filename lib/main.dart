import 'package:ansicolor/ansicolor.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/common/data/data_sources/cache_data_source.dart';
import 'package:quiz_lab/common/data/data_sources/package_info_data_source.dart';
import 'package:quiz_lab/core/constants.dart';
import 'package:quiz_lab/core/ui/quiz_lab_application.dart';
import 'package:quiz_lab/core/ui/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/appwrite_references_config.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/environment.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/answer_question/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/retrieve_question.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/application_information/data/repositories/application_version_repository_impl.dart';
import 'package:quiz_lab/features/application_information/domain/repositories/application_version_repository.dart';
import 'package:quiz_lab/features/application_information/domain/usecases/retrieve_application_version.dart';
import 'package:quiz_lab/features/application_information/ui/bloc/version_display/version_display_cubit.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/infrastructure/di_setup.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setUp();

  runApp(
    QuizLabApplication(
      router: QuizLabRouterImpl(
        bottomNavigationCubit: dependencyInjection.get<BottomNavigationCubit>(),
        loginPageCubit: dependencyInjection.get<LoginCubit>(),
        questionDisplayCubit: dependencyInjection.get<QuestionAnsweringCubit>(),
        questionCreationCubit: dependencyInjection.get<QuestionCreationCubit>(),
        questionsOverviewCubit: dependencyInjection.get<QuestionsOverviewCubit>(),
        networkCubit: dependencyInjection.get<NetworkCubit>(),
        checkIfUserIsLoggedInUseCase: dependencyInjection.get<CheckIfUserIsLoggedInUseCase>(),
        versionDisplayCubit: dependencyInjection.get(),
      ),
    ),
  );
}

Future<void> _setUp() async {
  _setUpLogger();
  await _setUpHive();
  await _setUpInjections();
}

Future<void> _setUpHive() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('questions');
}

void _setUpLogger() {
  ansiColorDisabled = false;
}

Future<void> _setUpInjections() async {
  await _miscellaneousDependencyInjectionSetup(dependencyInjection);

  dependencyInjection
    ..addSetup(_appwriteDependencyInjectionSetup)
    ..addSetup(questionManagementDiSetup)
    ..setUp();

  _setUpCommonDependencies();
  _setUpFeaturesDependencies();
}

void _setUpFeaturesDependencies() {
  _setUpAnswerQuestionDependencies();
  _setApplicationInformationDependencies();
}

void _setUpCommonDependencies() => dependencyInjection
  ..registerBuilder<CacheDataSource<String>>(
    (di) => CacheDataSourceImpl(
      // ignore: strict_raw_type
      logger: QuizLabLoggerImpl<CacheDataSourceImpl>(),
    ),
  )
  ..registerBuilder<PackageInfoDataSource>(
    (di) => PackageInfoDataSourceImpl(
      logger: QuizLabLoggerImpl<PackageInfoDataSourceImpl>(),
    ),
  );

void _setUpAnswerQuestionDependencies() => dependencyInjection
  ..registerBuilder<QuestionRepository>(
    (di) => QuestionRepositoryImpl(
      logger: QuizLabLoggerImpl<QuestionRepositoryImpl>(),
      questionsAppwriteDataSource: di.get(),
      uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
    ),
  )
  ..registerBuilder<RetrieveQuestion>(
    (di) => RetrieveQuestionImpl(
      logger: QuizLabLoggerImpl<RetrieveQuestion>(),
      questionRepository: di.get(),
    ),
  )
  ..registerBuilder<QuestionAnsweringCubit>(
    (di) => QuestionAnsweringCubit(
      logger: QuizLabLoggerImpl<QuestionAnsweringCubit>(),
      getSingleQuestionUseCase: di.get<RetrieveQuestion>(),
    ),
  );

void _setApplicationInformationDependencies() => dependencyInjection
  ..registerBuilder<ApplicationVersionRepository>(
    (di) => ApplicationVersionRepositoryImpl(
      logger: QuizLabLoggerImpl<ApplicationVersionRepositoryImpl>(),
      cacheDataSource: di.get(),
      packageInfoDataSource: di.get(),
    ),
  )
  ..registerBuilder<RetrieveApplicationVersion>(
    (di) => RetrieveApplicationVersionImpl(
      logger: QuizLabLoggerImpl<RetrieveApplicationVersionImpl>(),
      applicationVersionRepository: di.get(),
    ),
  )
  ..registerBuilder<VersionDisplayCubit>(
    (di) => VersionDisplayCubit(QuizLabLoggerImpl<VersionDisplayCubit>(), di.get()),
  );

void _appwriteDependencyInjectionSetup(DependencyInjection di) {
  final client = _setUpAppwriteClient();

  di
    ..registerInstance<Client>((_) => client)
    ..registerBuilder<Account>((i) => Account(i.get<Client>()))
    ..registerBuilder<Databases>((i) => Databases(i.get<Client>()))
    ..registerBuilder<Realtime>((i) => Realtime(i.get<Client>()))
    ..registerInstance<AppwriteReferencesConfig>(
      (_) => AppwriteReferencesConfig(
        databaseId: Environment.getRequiredEnvironmentVariable(EnvironmentVariable.appwriteDatabaseId),
        questionCollectionId:
            Environment.getRequiredEnvironmentVariable(EnvironmentVariable.appwriteQuestionCollectionId),
        profileCollectionId:
            Environment.getRequiredEnvironmentVariable(EnvironmentVariable.appwriteProfileCollectionId),
      ),
    );
}

Future<void> _miscellaneousDependencyInjectionSetup(DependencyInjection di) async {
  final packageInfo = await PackageInfo.fromPlatform();

  di.registerInstance<PackageInfo>((_) => packageInfo);
}

Client _setUpAppwriteClient() {
  final environmentType = Environment.getEnvironmentType();
  final endpoint = Environment.getRequiredEnvironmentVariable(
    EnvironmentVariable.appwriteEndpoint,
  );
  final projectId = Environment.getRequiredEnvironmentVariable(
    EnvironmentVariable.appwriteProjectId,
  );

  final client = Client().setEndpoint(endpoint).setProject(projectId);

  if (environmentType == EnvironmentType.development) {
    client.setSelfSigned();
  }

  return client;
}
