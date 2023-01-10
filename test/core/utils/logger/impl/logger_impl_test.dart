import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/utils/logger/impl/logger_impl.dart';

void main() {
  late Logger loggerMock;
  late LoggerImpl loggerImpl;

  setUp(() {
    loggerMock = _LoggerMock();
    loggerImpl = LoggerImpl(
      logger: loggerMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  parameterizedTest(
    'logError',
    ParameterizedSource.value([
      '',
      'NQJ9LFrX',
    ]),
    (values) {
      final message = values[0] as String;

      mocktail.when(() => loggerMock.severe(message)).thenReturn(null);

      loggerImpl.logError(message);

      mocktail.verify(() => loggerMock.severe(message)).called(1);
    },
  );

  parameterizedTest(
    'logInfo',
    ParameterizedSource.value([
      '',
      '0R#',
    ]),
    (values) {
      final message = values[0] as String;

      mocktail.when(() => loggerMock.info(message)).thenReturn(null);

      loggerImpl.logInfo(message);

      mocktail.verify(() => loggerMock.info(message)).called(1);
    },
  );

  parameterizedTest(
    'logWarning',
    ParameterizedSource.value([
      '',
      '@%y^^',
    ]),
    (values) {
      final message = values[0] as String;

      mocktail.when(() => loggerMock.warning(message)).thenReturn(null);

      loggerImpl.logWarning(message);

      mocktail.verify(() => loggerMock.warning(message)).called(1);
    },
  );
}

class _LoggerMock extends mocktail.Mock implements Logger {}
