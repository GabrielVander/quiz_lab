import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:quiz_lab/core/constants.dart';
import 'package:quiz_lab/core/presentation/manager/factories/core_cubit_factory.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/dependency_injection/setup.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/question_management_cubit_factory.dart';
import 'package:quiz_lab/features/question_management/utils/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setUp();

  runApp(
    QuizLabApplication(
      coreCubitFactory: dependencyInjection.get<CoreCubitFactory>(),
      questionManagementCubitFactory:
          dependencyInjection.get<QuestionManagementCubitFactory>(),
    ),
  );
}

Future<void> _setUp() async {
  await _setUpHive();
  _setUpLogger();
  _setUpInjections();
}

Future<void> _setUpHive() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('questions');
}

void _setUpLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.time}: ${record.level.name} - ${record.message}');
    }
  });
}

void _setUpInjections() {
  dependencyInjection
    ..addSetup(coreDependencyInjectionSetup)
    ..addSetup(questionManagementDiSetup)
    ..setUp();
}
