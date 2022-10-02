import 'package:get_it/get_it.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class DependencyInjectionGetItImpl implements DependencyInjection {
  final GetIt _getItInstance = GetIt.instance;

  @override
  Result<T, DiFailure> get<T extends Object>() {
    try {
      return ok(_getItInstance<T>());
      // ignore: avoid_catching_errors
    } on AssertionError {
      return err(KeyNotRegisteredFailure(key: T));
    }
  }

  @override
  Result<void, DiFailure> registerInstance<T extends Object>(
    T Function(DependencyInjection di) getter,
  ) {
    try {
      return ok(_getItInstance.registerSingleton<T>(getter(this)));
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return err(KeyAlreadyRegisteredFailure(key: T));
    }
  }

  @override
  Result<void, DiFailure> registerBuilder<T extends Object>(
    T Function(DependencyInjection di) builder,
  ) {
    try {
      return ok(_getItInstance.registerLazySingleton<T>(() => builder(this)));
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return err(KeyAlreadyRegisteredFailure(key: T));
    }
  }

  @override
  Result<void, DiFailure> registerFactory<T extends Object>(
    T Function(DependencyInjection di) factory,
  ) {
    try {
      return ok(_getItInstance.registerFactory<T>(() => factory(this)));
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return err(KeyAlreadyRegisteredFailure(key: T));
    }
  }

  @override
  Future<Result<void, DiFailure>> unregisterAll() async {
    return ok(await _getItInstance.reset());
  }
}
