import 'package:appwrite/appwrite.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void coreDependencyInjectionSetup(
  DependencyInjection di,
) {
  di
    ..registerBuilder<QuizLabRouter>(
      (i) => QuizLabRouterImpl(
        bottomNavigationCubit: i.get<BottomNavigationCubit>(),
        loginPageCubit: i.get<LoginPageCubit>(),
        questionCreationCubit: i.get<QuestionCreationCubit>(),
        questionsOverviewCubit: i.get<QuestionsOverviewCubit>(),
        networkCubit: i.get<NetworkCubit>(),
      ),
    )
    ..registerFactory<Account>((i) => Account(i.get<Client>()))
    ..registerFactory<Databases>((i) => Databases(i.get<Client>()))
    ..registerFactory<Realtime>((i) => Realtime(i.get<Client>()))
    ..registerFactory<AppwriteWrapper>(
      (i) => AppwriteWrapper(
        databases: i.get<Databases>(),
      ),
    )
    ..registerFactory<PackageInfoWrapper>(
      (i) => PackageInfoWrapper(packageInfo: i.get<PackageInfo>()),
    )
    ..registerFactory<AppwriteDataSource>(
      (i) => AppwriteDataSource(
        appwriteDatabasesService: i.get<Databases>(),
        configuration: i.get<AppwriteReferencesConfig>(),
        appwriteRealtimeService: i.get<Realtime>(),
      ),
    )
    ..registerBuilder<FetchApplicationVersionUseCase>(
      (i) => FetchApplicationVersionUseCaseImpl(
        packageInfoWrapper: i.get<PackageInfoWrapper>(),
      ),
    )
    ..registerFactory<NetworkCubit>((_) => NetworkCubit())
    ..registerFactory<BottomNavigationCubit>((_) => BottomNavigationCubit());
}
