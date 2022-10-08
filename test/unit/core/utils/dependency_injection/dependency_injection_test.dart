import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/dependency_injection/dependency_injection.dart';

void main() {
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
}

class DummyKey {}

class AnotherDummyKey {}
