import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';

abstract class DependencyInjection {
  void addSetup(DiSetup setup);

  void setUp();

  Result<T, DiFailure> get<T extends Object>();

  Result<Unit, DiFailure> registerInstance<T extends Object>(
    T? Function(DependencyInjection di) getter,
  );

  Result<Unit, DiFailure> registerBuilder<T extends Object>(
    T? Function(DependencyInjection di) builder,
  );

  Result<Unit, DiFailure> registerFactory<T extends Object>(
    T? Function(DependencyInjection di) factory,
  );

  Future<Result<Unit, DiFailure>> unregisterAll();
}

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

typedef DiSetup = void Function(DependencyInjection di);
