import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Uuid dummyUuid;
  late ResourceUuidGenerator generator;

  setUp(() {
    dummyUuid = _MockUuid();
    generator = ResourceUuidGenerator(uuid: dummyUuid);
  });

  group('generate', () {
    group(
      'should return a valid uuid',
      () {
        for (final expectedUuid in [
          '',
          r'd85$4',
        ]) {
          test(expectedUuid, () {
            when(() => dummyUuid.v4()).thenReturn(expectedUuid);

            final result = generator.generate();

            expect(result, expectedUuid);
          });
        }
      },
    );
  });
}

class _MockUuid extends Mock implements Uuid {}
