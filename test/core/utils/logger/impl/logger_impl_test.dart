import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';

void main() {
  late Logger loggerMock;

  setUp(() {
    loggerMock = _LoggerMock();
  });

  tearDown(resetMocktailState);

  for (final message in [
    'n74',
    'NQJ9LFrX',
  ]) {
    test('error -> $message', () {
      when(() => loggerMock.onRecord)
          .thenAnswer((_) => const Stream<LogRecord>.empty());

      QuizLabLoggerImpl<dynamic>(logger: loggerMock).error(message);

      verify(() => loggerMock.severe(message)).called(1);
    });

    test('info -> $message', () {
      when(() => loggerMock.onRecord)
          .thenAnswer((_) => const Stream<LogRecord>.empty());

      QuizLabLoggerImpl<dynamic>(logger: loggerMock).info(message);

      verify(() => loggerMock.info(message)).called(1);
    });

    test('warn -> $message', () {
      when(() => loggerMock.onRecord)
          .thenAnswer((_) => const Stream<LogRecord>.empty());

      QuizLabLoggerImpl<dynamic>(logger: loggerMock).warn(message);

      verify(() => loggerMock.warning(message)).called(1);
    });

    test('debug -> $message', () {
      when(() => loggerMock.onRecord)
          .thenAnswer((_) => const Stream<LogRecord>.empty());

      QuizLabLoggerImpl<dynamic>(logger: loggerMock).debug(message);

      verify(() => loggerMock.fine(message)).called(1);
    });
  }
}

class _LoggerMock extends Mock implements Logger {}
