import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';

class QuizLabLoggerImpl implements QuizLabLogger {
  QuizLabLoggerImpl({
    required logging.Logger logger,
  }) : _logger = logger;

  final logging.Logger _logger;

  @override
  void logError(String message) => _logger.severe(message);

  @override
  void logInfo(String message) => _logger.info(message);

  @override
  void logWarning(String message) => _logger.warning(message);

  static void onListen(logging.LogRecord record) {
    final message =
        '${record.time} ${record.loggerName} ${record.level.name} - '
        '${record.message}';

    switch (record.level.name) {
      case 'SHOUT':
      case 'SEVERE':
        _Printer.printRed(message);
        break;
      case 'WARNING':
        _Printer.printYellow(message);
        break;
      case 'INFO':
        _Printer.printBlue(message);
        break;
      case 'CONFIG':
        _Printer.printGreen(message);
        break;
      default:
        _Printer.printNoColor(message);
    }
  }
}

class _Printer {
  static void printNoColor(String message) {
    final pen = AnsiPen();

    _print(pen, message);
  }

  static void printRed(String message) {
    final pen = AnsiPen()..red();

    _print(pen, message);
  }

  static void printYellow(String message) {
    final pen = AnsiPen()..yellow();

    _print(pen, message);
  }

  static void printGreen(String message) {
    final pen = AnsiPen()..green();

    _print(pen, message);
  }

  static void printBlue(String message) {
    final pen = AnsiPen()..blue();

    _print(pen, message);
  }

  static void _print(AnsiPen pen, String message) {
    if (kDebugMode) {
      print(pen(message));
    }
  }
}
