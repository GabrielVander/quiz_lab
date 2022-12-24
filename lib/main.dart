import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quiz_lab/core/constants.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/features/question_management/utils/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();

  runApp(
    QuizLabApplication(dependencyInjection: dependencyInjection),
  );
}

Future<void> setUp() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('questions');
  setupInjections();
}

void setupInjections() {
  dependencyInjection
    ..addSetup(questionManagementDiSetup)
    ..setUp();
}
