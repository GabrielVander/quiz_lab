import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/cache_data_source.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';

void main() {
  late QuizLabLogger logger;

  late CacheDataSourceImpl<String> dataSource;

  setUp(() {
    logger = _MockQuizLabLogger();

    dataSource = CacheDataSourceImpl<String>(logger: logger);
  });

  group('fetchValue', () {
    group('should log initial message', () {
      for (final key in ['3@9vH', '2!8']) {
        test('when key is $key', () async {
          await dataSource.fetchValue(key);

          verify(() => logger.debug('Fetching value for key: $key')).called(1);
        });
      }
    });

    group('should return Err if key is not set', () {
      for (final key in ['&HBzSN', 'g@Z']) {
        test('when key is $key', () async {
          final result = await dataSource.fetchValue(key);

          expect(result, const Err<dynamic, String>('Key is not set'));
        });
      }
    });

    group('should return Ok with set value', () {
      for (final entry in [('vMo5AH#J', '4NG'), ('W71@', '8!ic7')]) {
        final key = entry.$1;
        final value = entry.$2;

        test('with $key as key and $value as value', () async {
          await dataSource.storeValue(key, value);
          final result = await dataSource.fetchValue(key);

          expect(result, Ok<String, dynamic>(value));
        });
      }
    });
  });

  group('storeValue', () {
    group('should log initial message', () {
      for (final key in ['soFyO0E*', '0%0p']) {
        test('with $key as value', () async {
          await dataSource.storeValue(key, '33&Sf0Y');

          verify(() => logger.debug('Storing value for key: $key')).called(1);
        });
      }
    });

    group('should return Err if key is already set', () {
      for (final entry in [('3@9vH', '4NG'), ('W71@', '8!ic7')]) {
        final key = entry.$1;
        final value = entry.$2;

        test('with $key as key and $value as value', () async {
          await dataSource.storeValue(key, value);
          final result = await dataSource.storeValue(key, value);

          expect(result, const Err<dynamic, String>('Key is already set'));
        });
      }
    });

    group('should return Ok', () {
      for (final entry in [('3@9vH', '4NG'), ('W71@', '8!ic7')]) {
        final key = entry.$1;
        final value = entry.$2;

        test('with $key as key and $value as value', () async {
          final result = await dataSource.storeValue(key, value);

          expect(result, const Ok<Unit, dynamic>(unit));
        });
      }
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}
