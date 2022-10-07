import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/constants.dart';
import 'package:quiz_lab/core/utils/dependency_injection/impl/setup.dart';
import 'package:quiz_lab/features/quiz/utils/setup.dart';
import 'package:quiz_lab/firebase_options.dart';

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
  setupInjections();
}

void setupInjections() {
  dependencyInjection
    ..addSetup(coreDiSetup)
    ..addSetup(quizDiSetup)
    ..setUp();
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
