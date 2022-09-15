import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/constants.dart';
import 'package:quiz_lab/features/quiz/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/quiz/data/repositories/question_repository_firebase_impl.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/fetch_questions_use_case.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/update_question_use_case.dart';
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
    ..registerBuilder<FirebaseDataSource>(FirebaseDataSource.new)
    ..registerBuilder<QuestionRepository>(
      () => QuestionRepositoryFirebaseImpl(
        dataSource: dependencyInjection.get<FirebaseDataSource>(),
      ),
    )
    ..registerBuilder<WatchAllQuestionsUseCase>(
      () => WatchAllQuestionsUseCase(
        questionRepository: dependencyInjection.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      () => DeleteQuestionUseCase(
        questionRepository: dependencyInjection.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      () => CreateQuestionUseCase(
        questionRepository: dependencyInjection.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      () => UpdateQuestionUseCase(
        questionRepository: dependencyInjection.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<BottomNavigationCubit>(BottomNavigationCubit.new)
    ..registerBuilder<AssessmentsOverviewCubit>(AssessmentsOverviewCubit.new)
    ..registerBuilder<QuestionsOverviewCubit>(
      () => QuestionsOverviewCubit(
        watchAllQuestionsUseCase:
            dependencyInjection.get<WatchAllQuestionsUseCase>(),
        deleteQuestionUseCase: dependencyInjection.get<DeleteQuestionUseCase>(),
        updateQuestionUseCase: dependencyInjection.get<UpdateQuestionUseCase>(),
      ),
    )
    ..registerBuilder<QuestionCreationCubit>(
      () => QuestionCreationCubit(
        createQuestionUseCase: dependencyInjection.get<CreateQuestionUseCase>(),
      ),
    );
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
