import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';
import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class CheckIfUserIsLoggedInUseCase {
  Future<Result<bool, String>> call();
}

class CheckIfUserIsLoggedInUseCaseImpl implements CheckIfUserIsLoggedInUseCase {
  CheckIfUserIsLoggedInUseCaseImpl({
    required this.logger,
    required this.authRepository,
  });

  final QuizLabLogger logger;
  final AuthRepository authRepository;

  @override
  Future<Result<bool, String>> call() async {
    logger.debug('Executing...');

    return (await authRepository.isLoggedIn())
        .inspectErr(logger.error)
        .mapErr((_) => 'Unable to check if user is logged in');
  }
}
