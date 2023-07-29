import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';

// ignore: one_member_abstracts
abstract interface class LoginAnonymouslyUseCase {
  Future<Result<Unit, String>> call();
}

class LoginAnonymouslyUseCaseImpl implements LoginAnonymouslyUseCase {
  LoginAnonymouslyUseCaseImpl({
    required this.logger,
    required this.authRepository,
  });

  final QuizLabLogger logger;
  final AuthRepository authRepository;

  @override
  Future<Result<Unit, String>> call() async {
    logger.debug('Executing...');

    return (await performAnonymousAuthentication())
        .inspectErr(logger.error)
        .mapErr((_) => 'Unable to login anonymously');
  }

  Future<Result<Unit, String>> performAnonymousAuthentication() async =>
      authRepository.loginAnonymously();
}
