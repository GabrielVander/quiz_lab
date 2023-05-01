import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';

void main() {
  late Logger loggerMock;
  late QuizLabLoggerImpl loggerImpl;

  setUp(() {
    loggerMock = _LoggerMock();
    loggerImpl = QuizLabLoggerImpl(
      logger: loggerMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group(
    'error',
    () {
      for (final message in [
        '',
        'NQJ9LFrX',
      ]) {
        test(message, () {
          mocktail.when(() => loggerMock.severe(message)).thenReturn(null);

          loggerImpl.error(message);

          mocktail.verify(() => loggerMock.severe(message)).called(1);
        });
      }
    },
  );

  group(
    'info',
    () {
      for (final message in [
        '',
        '0R#',
      ]) {
        test(message, () {
          mocktail.when(() => loggerMock.info(message)).thenReturn(null);

          loggerImpl.info(message);

          mocktail.verify(() => loggerMock.info(message)).called(1);
        });
      }
    },
  );

  group(
    'warn',
    () {
      for (final message in [
        '',
        '@%y^^',
      ]) {
        test(message, () {
          mocktail.when(() => loggerMock.warning(message)).thenReturn(null);

          loggerImpl.warn(message);

          mocktail.verify(() => loggerMock.warning(message)).called(1);
        });
      }
    },
  );
}

class _LoggerMock extends mocktail.Mock implements Logger {}
