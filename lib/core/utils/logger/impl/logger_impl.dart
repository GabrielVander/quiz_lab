import 'package:logging/logging.dart' as logging;
import 'package:quiz_lab/core/utils/logger/logger.dart';

class LoggerImpl implements Logger {
  LoggerImpl({
    required logging.Logger logger,
  }) : _logger = logger;

  final logging.Logger _logger;

  @override
  void logError(String message) => _logger.severe(message);

  @override
  void logInfo(String message) => _logger.info(message);

  @override
  void logWarning(String message) => _logger.warning(message);
}
