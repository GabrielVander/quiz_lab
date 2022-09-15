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

  group('unregisterAll', () {
    test('unregisters', () async {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);
      await dependencyInjection.unregisterAll();
      dependencyInjection.registerInstance<DummyInstance>((_) => instance);
    });
  });

  group('registerInstance', () {
    test('raises', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      expect(
        () => dependencyInjection
            .registerInstance<DummyInstance>((_) => instance),
        throwsA(const TypeMatcher<KeyAlreadyRegisteredException>()),
      );
    });

    test('registers', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<DummyInstance>();

      expect(actualResult, instance);
    });
  });

  group('registerBuilder', () {
    test('raises', () {
      final instance = DummyInstance();

      dependencyInjection.registerBuilder<DummyInstance>((_) => instance);

      expect(
        () =>
            dependencyInjection.registerBuilder<DummyInstance>((_) => instance),
        throwsA(const TypeMatcher<KeyAlreadyRegisteredException>()),
      );
    });

    test('registers', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<DummyInstance>();

      expect(actualResult, instance);
    });
  });

  group('registerFactory', () {
    test('raises', () {
      final instance = DummyInstance();

      dependencyInjection.registerFactory<DummyInstance>((_) => instance);

      expect(
        () =>
            dependencyInjection.registerFactory<DummyInstance>((_) => instance),
        throwsA(const TypeMatcher<KeyAlreadyRegisteredException>()),
      );
    });

    test('registers', () {
      final instance = DummyInstance();

      dependencyInjection.registerInstance<DummyInstance>((_) => instance);

      final actualResult = dependencyInjection.get<DummyInstance>();

      expect(actualResult, instance);
    });
  });
}

class DummyInstance {}
