import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';

void main() {
  late HiveInterface mockHiveInterface;
  late DataSourceFactory dataSourceFactory;

  setUp(() {
    mockHiveInterface = _MockHiveInterface();
    dataSourceFactory = DataSourceFactory(
      hiveInterface: mockHiveInterface,
    );
  });

  group('makeHiveDataSource', () {
    test('should return a HiveDataSource', () {
      final mockBox = _MockBox();

      when(() => mockHiveInterface.box<String>('questions'))
          .thenReturn(mockBox);

      final result = dataSourceFactory.makeHiveDataSource();

      expect(result, isA<HiveDataSource>());
    });
  });
}

class _MockHiveInterface extends Mock implements HiveInterface {}

class _MockBox extends Mock implements Box<String> {}
