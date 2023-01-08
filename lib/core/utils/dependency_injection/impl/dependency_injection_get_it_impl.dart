import 'package:get_it/get_it.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class DependencyInjectionGetItImpl implements DependencyInjection {
  final GetIt _getItInstance = GetIt.instance;
  final List<DiSetup> _setups = [];

  @override
  T get<T extends Object>() {
    try {
      return _getItInstance<T>();
      // ignore: avoid_catching_errors
    } on AssertionError {
      throw KeyNotRegisteredFailure(key: T);
    }
  }

  @override
  void registerInstance<T extends Object>(
    T? Function(DependencyInjection di) getter,
  ) {
    try {
      final instance = getter(this);

      if (instance != null) {
        _getItInstance.registerSingleton<T>(instance);
      }

      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredFailure(key: T);
    }
  }

  @override
  void registerBuilder<T extends Object>(
    T? Function(DependencyInjection di) builder,
  ) {
    try {
      final instance = builder(this);

      if (instance != null) {
        _getItInstance.registerLazySingleton<T>(() => instance);
      }

      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredFailure(key: T);
    }
  }

  @override
  void registerFactory<T extends Object>(
    T? Function(DependencyInjection di) factory,
  ) {
    try {
      final instance = factory(this);

      if (instance != null) {
        _getItInstance.registerFactory<T>(() => instance);
      }

      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      throw KeyAlreadyRegisteredFailure(key: T);
    }
  }

  @override
  Future<void> unregisterAll() async {
    await _getItInstance.reset();
  }

  @override
  void addSetup(DiSetup setup) {
    _setups.add(setup);
  }

  @override
  void setUp() {
    for (final setup in _setups) {
      setup(this);
    }
  }
}
