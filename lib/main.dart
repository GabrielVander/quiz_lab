import 'package:ansicolor/ansicolor.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/constants.dart';
import 'package:quiz_lab/core/infrastructure/router_di_setup.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_application.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/appwrite_references_config.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/environment.dart';
import 'package:quiz_lab/features/question_management/infrastructure/di_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setUp();

  runApp(
    QuizLabApplication(
      router: dependencyInjection.get<QuizLabRouter>(),
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
    ..addSetup(routerDiSetup)
    ..setUp();
}

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
