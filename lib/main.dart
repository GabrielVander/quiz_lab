import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/constants.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
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
    ..registerBuilder<FirebaseDataSource>((_) => FirebaseDataSource())
    ..registerBuilder<QuestionRepository>(
      (DependencyInjection di) => QuestionRepositoryFirebaseImpl(
        dataSource: di.get<FirebaseDataSource>(),
      ),
    )
    ..registerBuilder<WatchAllQuestionsUseCase>(
      (DependencyInjection di) => WatchAllQuestionsUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<DeleteQuestionUseCase>(
      (DependencyInjection di) => DeleteQuestionUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<CreateQuestionUseCase>(
      (DependencyInjection di) => CreateQuestionUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<UpdateQuestionUseCase>(
      (DependencyInjection di) => UpdateQuestionUseCase(
        questionRepository: di.get<QuestionRepository>(),
      ),
    )
    ..registerBuilder<BottomNavigationCubit>(
        (DependencyInjection di) => BottomNavigationCubit())
    ..registerBuilder<AssessmentsOverviewCubit>(
        (DependencyInjection di) => AssessmentsOverviewCubit())
    ..registerBuilder<QuestionsOverviewCubit>(
      (DependencyInjection di) => QuestionsOverviewCubit(
        watchAllQuestionsUseCase: di.get<WatchAllQuestionsUseCase>(),
        deleteQuestionUseCase: di.get<DeleteQuestionUseCase>(),
        updateQuestionUseCase: di.get<UpdateQuestionUseCase>(),
      ),
    )
    ..registerBuilder<QuestionCreationCubit>(
      (DependencyInjection di) => QuestionCreationCubit(
        createQuestionUseCase: di.get<CreateQuestionUseCase>(),
      ),
    );
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
