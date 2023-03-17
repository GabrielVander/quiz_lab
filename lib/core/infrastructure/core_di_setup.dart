import 'package:appwrite/appwrite.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

void coreDependencyInjectionSetup(
  DependencyInjection di,
) {
  di
    ..registerFactory<Account>((di) => Account(di.get<Client>()))
    ..registerFactory<Databases>((di) => Databases(di.get<Client>()))
    ..registerFactory<Realtime>((di) => Realtime(di.get<Client>()))
    ..registerFactory<AppwriteDataSource>(
      (di) => AppwriteDataSource(
        appwriteAccountService: di.get<Account>(),
        appwriteDatabasesService: di.get<Databases>(),
        configuration: di.get<AppwriteDataSourceConfiguration>(),
        appwriteRealtimeService: di.get<Realtime>(),
      ),
    )
    ..registerFactory<NetworkCubit>((_) => NetworkCubit())
    ..registerFactory<BottomNavigationCubit>((_) => BottomNavigationCubit());
}

class Configuration {
  const Configuration({
    required this.databaseId,
    required this.questionsCollectionId,
  });

  final String databaseId;
  final String questionsCollectionId;
}
