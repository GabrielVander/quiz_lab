import 'package:okay/okay.dart';
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

class QuizDiSetup implements DiSetup {
  @override
  void execute(DependencyInjection di) {
    di
      ..registerBuilder<FirebaseDataSource>((_) => FirebaseDataSource())
      ..registerBuilder<QuestionRepository>(
        (DependencyInjection di) {
          final dataSourceResult = di.get<FirebaseDataSource>();

          if (dataSourceResult.isErr) {
            return null;
          }

          return QuestionRepositoryFirebaseImpl(
            dataSource: dataSourceResult.unwrap(),
          );
        },
      )
      ..registerBuilder<WatchAllQuestionsUseCase>(
        (DependencyInjection di) {
          final repositoryResult = di.get<QuestionRepository>();

          if (repositoryResult.isErr) {
            return null;
          }

          return WatchAllQuestionsUseCase(
            questionRepository: repositoryResult.unwrap(),
          );
        },
      )
      ..registerBuilder<DeleteQuestionUseCase>(
        (DependencyInjection di) {
          final repositoryResult = di.get<QuestionRepository>();

          if (repositoryResult.isErr) {
            return null;
          }

          return DeleteQuestionUseCase(
            questionRepository: repositoryResult.unwrap(),
          );
        },
      )
      ..registerBuilder<CreateQuestionUseCase>(
        (DependencyInjection di) {
          final repositoryResult = di.get<QuestionRepository>();

          if (repositoryResult.isErr) {
            return null;
          }

          return CreateQuestionUseCase(
            questionRepository: repositoryResult.unwrap(),
          );
        },
      )
      ..registerBuilder<UpdateQuestionUseCase>(
        (DependencyInjection di) {
          final repositoryResult = di.get<QuestionRepository>();

          if (repositoryResult.isErr) {
            return null;
          }

          return UpdateQuestionUseCase(
            questionRepository: repositoryResult.unwrap(),
          );
        },
      )
      ..registerBuilder<BottomNavigationCubit>(
        (DependencyInjection di) => BottomNavigationCubit(),
      )
      ..registerBuilder<AssessmentsOverviewCubit>(
        (DependencyInjection di) => AssessmentsOverviewCubit(),
      )
      ..registerBuilder<QuestionsOverviewCubit>(
        (DependencyInjection di) {
          final watchAllQuestionsUseCaseResult =
              di.get<WatchAllQuestionsUseCase>();
          final deleteQuestionUseCaseResult = di.get<DeleteQuestionUseCase>();
          final updateQuestionUseCaseResult = di.get<UpdateQuestionUseCase>();

          if (watchAllQuestionsUseCaseResult.isErr ||
              deleteQuestionUseCaseResult.isErr ||
              updateQuestionUseCaseResult.isErr) {
            return null;
          }

          return QuestionsOverviewCubit(
            watchAllQuestionsUseCase: watchAllQuestionsUseCaseResult.unwrap(),
            deleteQuestionUseCase: deleteQuestionUseCaseResult.unwrap(),
            updateQuestionUseCase: updateQuestionUseCaseResult.unwrap(),
          );
        },
      )
      ..registerBuilder<QuestionCreationCubit>(
        (DependencyInjection di) {
          final createQuestionUseCaseResult = di.get<CreateQuestionUseCase>();

          if (createQuestionUseCaseResult.isErr) {
            return null;
          }

          return QuestionCreationCubit(
            createQuestionUseCase: createQuestionUseCaseResult.unwrap(),
          );
        },
      );
  }
}
