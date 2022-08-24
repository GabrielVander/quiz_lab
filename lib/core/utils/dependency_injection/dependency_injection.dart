abstract class DependencyInjection {
  T get<T extends Object>();

  void registerInstance<T extends Object>(T value);

  void registerBuilder<T extends Object>(T Function() builder);

  void registerFactory<T extends Object>(T Function() factory);

  Future<void> unregisterAll();
}

class KeyAlreadyRegisteredException implements Exception {
  const KeyAlreadyRegisteredException({
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
}
