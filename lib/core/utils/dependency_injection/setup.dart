import 'package:logging/logging.dart' as logging;
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/factories/core_cubit_factory.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/logger_impl.dart';
import 'package:quiz_lab/core/utils/logger/logger.dart';

void coreDependencyInjectionSetup(DependencyInjection di) {
  di
    ..registerBuilder<Logger>((_) => LoggerImpl(logger: logging.Logger.root))
    ..registerBuilder<NetworkCubit>((_) => NetworkCubit())
    ..registerBuilder<BottomNavigationCubit>((_) => BottomNavigationCubit())
    ..registerBuilder<CoreCubitFactory>(
      (di) => CoreCubitFactory(
        networkCubit: di.get<NetworkCubit>(),
        bottomNavigationCubit: di.get<BottomNavigationCubit>(),
      ),
    );
}
