import 'package:ansicolor/ansicolor.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';

class QuizLabLoggerImpl<T> extends Equatable implements QuizLabLogger {
  QuizLabLoggerImpl({
    logging.Logger? logger,
  }) : _logger = logger ?? logging.Logger(T.toString()) {
    logging.hierarchicalLoggingEnabled = true;
    _logger.level = logging.Level.ALL;
    _logger.onRecord.listen(onListen);
  }

  final logging.Logger _logger;

  @override
  void error(String message) => _logger.severe(message);

  @override
  void info(String message) => _logger.info(message);

  @override
  void warn(String message) => _logger.warning(message);

  @override
  void debug(String message) => _logger.fine(message);

  static void onListen(logging.LogRecord record) {
    final message =
        '${record.time} ${record.level.name} ${record.loggerName} - '
        '${record.message}';

    _Printer.fromLevel(record.level).printColorizedMessage(message);
  }

  @override
  List<Object> get props => [T];
}

final class _Printer {
  const _Printer._({
    required this.pen,
  });

  factory _Printer.fromLevel(logging.Level level) {
    switch (level) {
      case logging.Level.SHOUT:
      case logging.Level.SEVERE:
        return _Printer.red();
      case logging.Level.WARNING:
        return _Printer.yellow();
      case logging.Level.INFO:
        return _Printer.blue();
      case logging.Level.CONFIG:
        return _Printer.white();
      case logging.Level.FINE:
        return _Printer.green();
      default:
        return _Printer.gray();
    }
  }

  factory _Printer.white() => _Printer._(pen: AnsiPen()..white());

  factory _Printer.green() => _Printer._(pen: AnsiPen()..green());

  factory _Printer.gray() => _Printer._(pen: AnsiPen()..gray());

  factory _Printer.red() => _Printer._(pen: AnsiPen()..red());

  factory _Printer.yellow() => _Printer._(pen: AnsiPen()..yellow());

  factory _Printer.blue() => _Printer._(pen: AnsiPen()..blue());

  final AnsiPen pen;

  void printColorizedMessage(String message) {
    if (kDebugMode) {
      print(pen(message));
    }
  }
}
