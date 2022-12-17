import 'package:hive/hive.dart';
import 'package:quiz_lab/core/common/manager_factory.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/json_parser.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/firebase_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:uuid/uuid.dart';

void quizDiSetup(DependencyInjection di) {
  di
    ..registerBuilder<QuestionRepository>(
      (DependencyInjection di) {
        final dataSourceResult = di.get<FirebaseDataSource>();

        if (dataSourceResult.isErr) {
          return null;
        }

        return QuestionRepositoryImpl(
          hiveDataSource: HiveDataSource(
            questionsBox: Hive.box('questions'),
            jsonParser: JsonParser<Map<String, dynamic>>(
              encoder: jsonEncode,
              decoder: jsonDecode,
            ),
          ),
          questionMapper: QuestionEntityMapper(),
          hiveQuestionModelMapper: HiveQuestionModelMapper(),
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
          uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
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
          questionEntityMapper: QuestionEntityMapper(),
          questionOverviewItemViewModelMapper:
              QuestionOverviewItemViewModelMapper(),
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
    )
    ..registerBuilder<NetworkCubit>((DependencyInjection di) => NetworkCubit())
    ..registerBuilder<ManagerFactory>(
      (DependencyInjection di) => ManagerFactory(dependencyInjection: di),
    );
}
