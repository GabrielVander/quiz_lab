import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/json_parser.dart';

void main() {
  late String Function(Object) mockEncoder;
  late dynamic Function(String) mockDecoder;
  late JsonParser<Map<String, dynamic>> parser;

  setUp(() {
    mockEncoder = _MockEncoder().call;
    mockDecoder = _MockDecoder().call;
    parser = JsonParser(encoder: mockEncoder, decoder: mockDecoder);
  });

  group('encode', () {
    group('Err flow', () {
      group(
        'should return failure when exception occurs',
        () {
          for (final values in [
            [
              <String, Object>{},
              Exception(''),
              EncodeFailure.exception(message: 'Exception: ')
            ],
            [
              {'D5N': 'QLGG', 'QPuP!Dnd': 23},
              Exception(r'lK1$BDx'),
              EncodeFailure.exception(message: r'Exception: lK1$BDx')
            ],
          ]) {
            test(values.toString(), () {
              final input = values[0] as Map<String, Object>;
              final exception = values[1] as Exception;
              final expectedFailure = values[2] as EncodeFailure;

              when(() => mockEncoder(input)).thenThrow(exception);

              final actual = parser.encode(input);

              expect(actual.isErr, isTrue);
              expect(actual.err, expectedFailure);
            });
          }
        },
      );
    });

    group('Ok flow', () {
      group(
        'should return success when no exception occurs',
        () {
          for (final values in [
            [
              <String, Object>{},
              '',
            ],
            [
              {'D5N': 'QLGG', 'QPuP!Dnd': 23},
              'au87U4D',
            ],
          ]) {
            test(values.toString(), () {
              final input = values[0] as Map<String, Object>;
              final expected = values[1] as String;

              when(() => mockEncoder(input)).thenReturn(expected);

              final actual = parser.encode(input);

              expect(actual.isOk, isTrue);
              expect(actual.ok, expected);
            });
          }
        },
      );
    });
  });

  group('decode', () {
    group('Err flow', () {
      group(
        'should return failure when exception occurs',
        () {
          for (final values in [
            [
              '',
              Exception(''),
              DecodeFailure.exception(message: 'Exception: ')
            ],
            [
              'EOQ86',
              Exception('*uDo5B9r'),
              DecodeFailure.exception(message: 'Exception: *uDo5B9r')
            ],
          ]) {
            test(values.toString(), () {
              final input = values[0] as String;
              final exception = values[1] as Exception;
              final expectedFailure = values[2] as DecodeFailure;

              when(() => mockDecoder(input)).thenThrow(exception);

              final actual = parser.decode(input);

              expect(actual.isErr, isTrue);
              expect(actual.err, expectedFailure);
            });
          }
        },
      );
    });

    group('Ok flow', () {
      group(
        'should return success when no exception occurs',
        () {
          for (final values in [
            [
              '',
              <String, Object>{},
            ],
            [
              'au87U4D',
              {'D5N': 'QLGG', 'QPuP!Dnd': 23},
            ],
          ]) {
            test(values.toString(), () {
              final input = values[0] as String;
              final expected = values[1] as Map<String, Object>;

              when(() => mockDecoder(input)).thenReturn(expected);

              final actual = parser.decode(input);

              expect(actual.isOk, isTrue);
              expect(actual.ok, expected);
            });
          }
        },
      );
    });
  });
}

class _MockEncoder extends Mock {
  String call(Object map);
}

class _MockDecoder extends Mock {
  dynamic call(String string);
}
