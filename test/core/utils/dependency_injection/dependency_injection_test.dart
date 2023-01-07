import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/dependency_injection/impl/dependency_injection_get_it_impl.dart';

void main() {
  late DependencyInjection dependencyInjection;

  setUp(() {
    dependencyInjection = DependencyInjectionGetItImpl();
  });

  tearDown(() async {
    await dependencyInjection.unregisterAll();
  });

  group('KeyAlreadyRegisteredFailure', () {
    group('toString', () {
      <Object, String>{
        '_SomeKey':
            'Unable to register key _SomeKey as it is already registered',
        _DummyKey:
            'Unable to register key _DummyKey as it is already registered',
        _AnotherDummyKey: 'Unable to register key _AnotherDummyKey as it is '
            'already registered',
      }.forEach(
        (Object key, String value) => test('$key -> $value', () {
          expect(KeyAlreadyRegisteredFailure(key: key).toString(), value);
        }),
      );
    });
  });

  group('unregisterAll', () {
    test('unregisters', () async {
      final instance = _DummyInstance();

      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);
      await dependencyInjection.unregisterAll();
      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);
    });
  });

  group('get', () {
    test('throws when key is not registered', () {
      expect(
        () => dependencyInjection.get<_DummyInstance>(),
        throwsA(const KeyNotRegisteredFailure(key: _DummyInstance)),
      );
    });

    test('returns correct instance', () {
      final instance = _DummyInstance();

      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);

      final result = dependencyInjection.get<_DummyInstance>();

      expect(result, instance);
    });
  });

  group('registerInstance', () {
    test('throws when key is already registered', () {
      final instance = _DummyInstance();

      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);

      expect(
        () => dependencyInjection
            .registerInstance<_DummyInstance>((_) => instance),
        throwsA(const KeyAlreadyRegisteredFailure(key: _DummyInstance)),
      );
    });

    test('registers', () {
      final instance = _DummyInstance();

      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<_DummyInstance>();

      expect(actualResult, instance);
    });
  });

  group('registerBuilder', () {
    test('throws when key is already registered', () {
      final instance = _DummyInstance();

      dependencyInjection.registerBuilder<_DummyInstance>((_) => instance);

      expect(
        () => dependencyInjection
            .registerBuilder<_DummyInstance>((_) => instance),
        throwsA(const KeyAlreadyRegisteredFailure(key: _DummyInstance)),
      );
    });

    test('registers', () {
      final instance = _DummyInstance();

      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<_DummyInstance>();

      expect(actualResult, instance);
    });
  });

  group('registerFactory', () {
    test('throws when key is already registered', () {
      final instance = _DummyInstance();

      dependencyInjection.registerFactory<_DummyInstance>((_) => instance);

      expect(
        () => dependencyInjection
            .registerFactory<_DummyInstance>((_) => instance),
        throwsA(const KeyAlreadyRegisteredFailure(key: _DummyInstance)),
      );
    });

    test('registers', () {
      final instance = _DummyInstance();

      dependencyInjection.registerInstance<_DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<_DummyInstance>();

      expect(actualResult, instance);
    });
  });
}

class _DummyInstance {}

class _DummyKey {}

class _AnotherDummyKey {}
