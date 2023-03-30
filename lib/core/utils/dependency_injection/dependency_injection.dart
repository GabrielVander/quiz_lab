import 'package:equatable/equatable.dart';

abstract class DependencyInjection {
  void addSetup(DiSetup setup);

  void setUp();

  T get<T extends Object>();

  void registerInstance<T extends Object>(
    T? Function(DependencyInjection di) getter,
  );

  void registerBuilder<T extends Object>(
    T? Function(DependencyInjection di) builder,
  );

  void registerFactory<T extends Object>(
    T? Function(DependencyInjection di) factory,
  );

  Future<void> unregisterAll();
}

abstract class DiFailure extends Equatable {}

class KeyAlreadyRegisteredFailure extends Equatable implements Exception {
  const KeyAlreadyRegisteredFailure({
    required this.key,
  });

  final Object key;

  @override
  String toString() {
    final keyName = _buildKeyName();

    return 'Unable to register key $keyName as it is already registered';
  }

  String _buildKeyName() {
    if (key is String) {
      return key as String;
    }

    return key.toString();
  }

  @override
  List<Object?> get props => [key];
}

class KeyNotRegisteredFailure extends Equatable implements Exception {
  const KeyNotRegisteredFailure({
    required this.key,
  });

  final Object key;

  @override
  String toString() {
    final keyName = _buildKeyName();

    return 'Unable to get instance for key $keyName as it is not registered';
  }

  String _buildKeyName() {
    if (key is String) {
      return key as String;
    }

    return key.toString();
  }

  @override
  List<Object?> get props => [key];
}

typedef DiSetup = void Function(DependencyInjection di);
