import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/application_information/domain/repositories/application_version_repository.dart';
import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class RetrieveApplicationVersion {
  Future<Result<String, String>> call();
}

class RetrieveApplicationVersionImpl implements RetrieveApplicationVersion {
  RetrieveApplicationVersionImpl({required this.logger, required this.applicationVersionRepository});

  final QuizLabLogger logger;
  final ApplicationVersionRepository applicationVersionRepository;

  @override
  Future<Result<String, String>> call() async {
    logger.debug('Executing...');

    return (await _fetchVersionName()).inspectErr(logger.error).mapErr((_) => 'Unable to retrieve application version');
  }

  Future<Result<String, String>> _fetchVersionName() async => applicationVersionRepository.fetchVersionName();
}
