import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/constants.dart';
import 'core/firebase_options.dart';
import 'core/quiz_lab_application.dart';
import 'features/question_management/utils/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();

  runApp(
    QuizLabApplication(
      dependencyInjection: dependencyInjection,
    ),
  );
}

Future<void> setUp() async {
  await initializeFirebase();
  await Hive.initFlutter();
  await Hive.openBox<String>('questions');
  setupInjections();
}

void setupInjections() {
  dependencyInjection
    ..addSetup(quizDiSetup)
    ..setUp();
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
