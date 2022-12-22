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
        'SomeKey': 'Unable to register key SomeKey as it is already registered',
        DummyKey: 'Unable to register key DummyKey as it is already registered',
        AnotherDummyKey: 'Unable to register key AnotherDummyKey as it is '
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
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);
      await dependencyInjection.unregisterAll();
      dependencyInjection.registerInstance<DummyInstance>((_) => instance);
    });
  });

  group('get', () {
    test('returns failure when key is not registered', () {
      final instanceResult = dependencyInjection.get<DummyInstance>();

      expect(
        instanceResult.isErrAnd(
          (error) =>
              error is KeyNotRegisteredFailure && error.key == DummyInstance,
        ),
        true,
      );
    });

    test('returns correct instance', () {
      final instance = DummyInstance();

      final registrationResult =
          dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      expect(registrationResult.isOk, true);

      final instanceResult = dependencyInjection.get<DummyInstance>();

      expect(
        instanceResult.isOkAnd(
          (value) => value == instance,
        ),
        true,
      );
    });
  });

  group('registerInstance', () {
    test('returns failure when key is already registered', () {
      final instance = DummyInstance();

      final firstRegistrationResult =
          dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      expect(firstRegistrationResult.isOk, true);

      final secondRegistrationResult =
          dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      expect(
        secondRegistrationResult.isErrAnd(
          (error) =>
              error is KeyAlreadyRegisteredFailure &&
              error.key == DummyInstance,
        ),
        true,
      );
    });

    test('registers', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<DummyInstance>();

      expect(actualResult.isOkAnd((value) => value == instance), true);
    });
  });

  group('registerBuilder', () {
    test('returns failure when key is already registered', () {
      final instance = DummyInstance();

      final firstRegistrationResult =
          dependencyInjection.registerBuilder<DummyInstance>((_) => instance);

      expect(firstRegistrationResult.isOk, true);

      final secondRegistrationResult =
          dependencyInjection.registerBuilder<DummyInstance>((_) => instance);

      expect(
        secondRegistrationResult.isErrAnd(
          (error) =>
              error is KeyAlreadyRegisteredFailure &&
              error.key == DummyInstance,
        ),
        true,
      );
    });

    test('registers', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<DummyInstance>();

      expect(actualResult.isOkAnd((value) => value == instance), true);
    });
  });

  group('registerFactory', () {
    test('returns failure when key is already registered', () {
      final instance = DummyInstance();

      final firstRegistration =
          dependencyInjection.registerFactory<DummyInstance>((_) => instance);

      expect(firstRegistration.isOk, true);

      final secondRegistration =
          dependencyInjection.registerFactory<DummyInstance>((_) => instance);

      expect(
        secondRegistration.isErrAnd(
          (error) =>
              error is KeyAlreadyRegisteredFailure &&
              error.key == DummyInstance,
        ),
        true,
      );
    });

    test('registers', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<DummyInstance>();

      expect(actualResult.isOkAnd((value) => value == instance), true);
    });
  });
}

class DummyInstance {}

class DummyKey {}

class AnotherDummyKey {}
