import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/common/data/data_sources/package_info_data_source.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(channel.name, (data) async {
    final call = channel.codec.decodeMethodCall(data);
    if (call.method == 'getAll') {
      return channel.codec.encodeSuccessEnvelope(
        <String, dynamic>{'appName': '...', 'packageName': '...', 'version': '0.0.1', 'buildNumber': '1'},
      );
    }
    return null;
  });
  late QuizLabLogger logger;

  late PackageInfoDataSource dataSource;

  setUp(() {
    logger = _MockQuizLabLogger();

    dataSource = PackageInfoDataSourceImpl(logger: logger);
  });

  group('fetchPackageInformation', () {
    test('should return Ok', () async {
      final result = await dataSource.fetchPackageInformation();

      expect(result.isOk, true);
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}
