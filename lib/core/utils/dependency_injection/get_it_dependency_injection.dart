import 'package:get_it/get_it.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class GetItDependencyInjection implements DependencyInjection {
  final GetIt _getItInstance = GetIt.instance;

  @override
  T get<T extends Object>() {
    return _getItInstance<T>();
  }

  @override
  void registerInstance<T extends Object>(T value) {
    try {
      _getItInstance.registerSingleton<T>(value);
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredException(key: value);
    }
  }

  @override
  void registerBuilder<T extends Object>(T Function() builder) {
    try {
      _getItInstance.registerLazySingleton<T>(builder);
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredException(key: builder());
    }
  }

  @override
  void registerFactory<T extends Object>(T Function() factory) {
    try {
      _getItInstance.registerFactory<T>(factory);
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredException(key: factory());
    }
  }

  @override
  Future<void> unregisterAll() async {
    await _getItInstance.reset();
  }
}
