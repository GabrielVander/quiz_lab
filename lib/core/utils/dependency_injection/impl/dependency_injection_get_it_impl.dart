import 'package:get_it/get_it.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class DependencyInjectionGetItImpl implements DependencyInjection {
  final GetIt _getItInstance = GetIt.instance;

  @override
  T get<T extends Object>() {
    return _getItInstance<T>();
  }

  @override
  void registerInstance<T extends Object>(
    T Function(DependencyInjection di) getter,
  ) {
    try {
      _getItInstance.registerSingleton<T>(getter(this));
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredException(key: T);
    }
  }

  @override
  void registerBuilder<T extends Object>(
    T Function(DependencyInjection di) builder,
  ) {
    try {
      _getItInstance.registerLazySingleton<T>(() => builder(this));
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredException(key: T);
    }
  }

  @override
  void registerFactory<T extends Object>(
    T Function(DependencyInjection di) factory,
  ) {
    try {
      _getItInstance.registerFactory<T>(() => factory(this));
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredException(key: T);
    }
  }

  @override
  Future<void> unregisterAll() async {
    await _getItInstance.reset();
  }
}
