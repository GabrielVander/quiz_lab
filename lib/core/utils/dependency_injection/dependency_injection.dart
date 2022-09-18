import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';

abstract class DependencyInjection {
  Result<T, DiFailure> get<T extends Object>();

  Result<void, DiFailure> registerInstance<T extends Object>(
    T Function(DependencyInjection di) getter,
  );

  Result<void, DiFailure> registerBuilder<T extends Object>(
    T Function(DependencyInjection di) builder,
  );

  Result<void, DiFailure> registerFactory<T extends Object>(
    T Function(DependencyInjection di) factory,
  );

  Future<Result<void, DiFailure>> unregisterAll();
}

abstract class DiSetup {}

abstract class DiFailure extends Equatable {}

class KeyAlreadyRegisteredFailure implements DiFailure {
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
  List<Object?> get props => [
        key,
      ];

  @override
  bool? get stringify => true;
}

class KeyNotRegisteredFailure implements DiFailure {
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
  List<Object?> get props => [
        key,
      ];

  @override
  bool? get stringify => true;
}
