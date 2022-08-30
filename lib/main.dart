import 'package:flutter/material.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/constants.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/questions_overview/questions_overview_cubit.dart';

void main() async {
  setupInjections();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    QuizLabApplication(
      dependencyInjection: dependencyInjection,
    ),
  );
}

void setupInjections() {
  dependencyInjection
    ..registerBuilder<BottomNavigationCubit>(BottomNavigationCubit.new)
    ..registerBuilder<AssessmentsOverviewCubit>(AssessmentsOverviewCubit.new)
    ..registerBuilder<QuestionsOverviewCubit>(QuestionsOverviewCubit.new)
    ..registerBuilder<QuestionCreationCubit>(QuestionCreationCubit.new);
}
