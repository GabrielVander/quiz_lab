import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';

// ignore: one_member_abstracts
abstract class FetchApplicationVersionUseCase {
  String execute();
}

class FetchApplicationVersionUseCaseImpl implements FetchApplicationVersionUseCase {
  FetchApplicationVersionUseCaseImpl({required PackageInfoWrapper packageInfoWrapper})
      : _packageInfoWrapper = packageInfoWrapper;

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<FetchApplicationVersionUseCaseImpl>();
  final PackageInfoWrapper _packageInfoWrapper;

  @override
  String execute() {
    _logger.debug('Executing...');

    return _packageInfoWrapper.applicationVersion;
  }
}
