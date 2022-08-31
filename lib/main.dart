import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/constants.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/questions_overview/questions_overview_cubit.dart';
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
    ..registerBuilder<BottomNavigationCubit>(BottomNavigationCubit.new)
    ..registerBuilder<AssessmentsOverviewCubit>(AssessmentsOverviewCubit.new)
    ..registerBuilder<QuestionsOverviewCubit>(QuestionsOverviewCubit.new)
    ..registerBuilder<QuestionCreationCubit>(QuestionCreationCubit.new);
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
