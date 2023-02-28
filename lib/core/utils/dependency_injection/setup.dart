import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/factories/core_cubit_factory.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

void coreDependencyInjectionSetup(DependencyInjection di) {
  di
    ..registerBuilder<NetworkCubit>((_) => NetworkCubit())
    ..registerBuilder<BottomNavigationCubit>((_) => BottomNavigationCubit())
    ..registerBuilder<CoreCubitFactory>(
      (di) => CoreCubitFactory(
        networkCubit: di.get<NetworkCubit>(),
        bottomNavigationCubit: di.get<BottomNavigationCubit>(),
      ),
    );
}
