import 'package:get_it/get_it.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/unit.dart';

class DependencyInjectionGetItImpl implements DependencyInjection {
  final GetIt _getItInstance = GetIt.instance;
  final List<DiSetup> _setups = [];

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
  Result<Unit, DiFailure> registerInstance<T extends Object>(
    T? Function(DependencyInjection di) getter,
  ) {
    try {
      final instance = getter(this);

      if (instance != null) {
        _getItInstance.registerSingleton<T>(instance);
      }

      return ok(Unit());
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return err(KeyAlreadyRegisteredFailure(key: T));
    }
  }

  @override
  Result<Unit, DiFailure> registerBuilder<T extends Object>(
    T? Function(DependencyInjection di) builder,
  ) {
    try {
      final instance = builder(this);

      if (instance != null) {
        _getItInstance.registerLazySingleton<T>(() => instance);
      }

      return ok(Unit());
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return err(KeyAlreadyRegisteredFailure(key: T));
    }
  }

  @override
  Result<Unit, DiFailure> registerFactory<T extends Object>(
    T? Function(DependencyInjection di) factory,
  ) {
    try {
      final instance = factory(this);

      if (instance != null) {
        _getItInstance.registerFactory<T>(() => instance);
      }

      return ok(Unit());
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return err(KeyAlreadyRegisteredFailure(key: T));
    }
  }

  @override
  Future<Result<Unit, DiFailure>> unregisterAll() async {
    await _getItInstance.reset();

    return ok(Unit());
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
