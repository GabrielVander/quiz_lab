import 'package:ansicolor/ansicolor.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/constants.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_application.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/appwrite_references_config.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/environment.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/features/answer_question/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/get_question_with_id.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/infrastructure/di_setup.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setUp();

  runApp(
    QuizLabApplication(
      router: QuizLabRouterImpl(
        bottomNavigationCubit: dependencyInjection.get<BottomNavigationCubit>(),
        loginPageCubit: dependencyInjection.get<LoginPageCubit>(),
        questionDisplayCubit: dependencyInjection.get<QuestionAnsweringCubit>(),
        questionCreationCubit: dependencyInjection.get<QuestionCreationCubit>(),
        questionsOverviewCubit: dependencyInjection.get<QuestionsOverviewCubit>(),
        networkCubit: dependencyInjection.get<NetworkCubit>(),
        checkIfUserIsLoggedInUseCase: dependencyInjection.get<CheckIfUserIsLoggedInUseCase>(),
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

  setUpAnswerQuestionDependencies();
}

void setUpAnswerQuestionDependencies() => dependencyInjection
  ..registerBuilder<QuestionRepository>(
    (di) => QuestionRepositoryImpl(
      logger: QuizLabLoggerImpl<QuestionRepositoryImpl>(),
      questionsAppwriteDataSource: di.get(),
    ),
  )
  ..registerBuilder<GetQuestionWithId>(
    (di) => GetQuestionWithIdImpl(
      logger: QuizLabLoggerImpl<GetQuestionWithId>(),
      questionRepository: di.get(),
    ),
  )
  ..registerBuilder<QuestionAnsweringCubit>(
    (di) => QuestionAnsweringCubit(
      logger: QuizLabLoggerImpl<QuestionAnsweringCubit>(),
      getSingleQuestionUseCase: di.get<GetQuestionWithId>(),
    ),
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
