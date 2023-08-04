import 'package:ansicolor/ansicolor.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';

class QuizLabLoggerImpl<T> extends Equatable implements QuizLabLogger {
  QuizLabLoggerImpl({
    logging.Logger? logger,
  }) : _logger = logger ?? logging.Logger(T.toString());

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
        '${record.time} ${record.loggerName} ${record.level.name} - '
        '${record.message}';

    switch (record.level.name) {
      case 'SHOUT':
      case 'SEVERE':
        _Printer.printRed(message);
      case 'WARNING':
        _Printer.printYellow(message);
      case 'INFO':
        _Printer.printBlue(message);
      case 'CONFIG':
        _Printer.printGreen(message);
      default:
        _Printer.printNoColor(message);
    }
  }

  @override
  List<Object> get props => [T];
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
