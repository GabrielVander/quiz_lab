import 'package:appwrite/appwrite.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/core/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/core/domain/repository/auth_repository.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/environment.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';

void coreDependencyInjectionSetup(
  DependencyInjection di,
) {
  di
    ..registerInstance<AppwriteDatabaseId>(
      (_) => AppwriteDatabaseId(
        value: EnvironmentVariable.appwriteDatabaseId.getRequiredValue,
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
    ..registerBuilder<AuthAppwriteDataSource>(
      (DependencyInjection di) => AuthAppwriteDataSourceImpl(
        logger: QuizLabLoggerImpl<AuthAppwriteDataSourceImpl>(),
        appwriteAccountService: di.get<Account>(),
      ),
    )
    ..registerBuilder<AuthRepository>(
      (DependencyInjection di) => AuthRepositoryImpl(
        logger: QuizLabLoggerImpl<AuthRepositoryImpl>(),
        authDataSource: di.get<AuthAppwriteDataSource>(),
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

class AppwriteDatabaseId {
  const AppwriteDatabaseId({
    required this.value,
  });

  final String value;
}
