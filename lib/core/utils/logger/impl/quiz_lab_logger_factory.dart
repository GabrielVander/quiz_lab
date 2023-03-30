import 'package:logging/logging.dart' as logging;
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';

class QuizLabLoggerFactory {
  static QuizLabLogger createLogger<T>() =>
      QuizLabLoggerImpl(logger: logging.Logger(T.toString()));
}
