import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';

// ignore: one_member_abstracts
abstract interface class LoginWithCredentialsUseCase {
  Future<Result<Unit, String>> call(
    LoginWithCredentialsUseCaseInput input,
  );
}

class LoginWithCredentialsUseCaseInput extends Equatable {
  const LoginWithCredentialsUseCaseInput({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class LoginWithCredentialsUseCaseImpl implements LoginWithCredentialsUseCase {
  LoginWithCredentialsUseCaseImpl({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final _logger = QuizLabLoggerFactory.createLogger<LoginWithCredentialsUseCase>();

  final AuthRepository _authRepository;

  @override
  Future<Result<Unit, String>> call(
    LoginWithCredentialsUseCaseInput input,
  ) async {
    _logger.debug('Executing...');

    final loginResult = await _authRepository.loginWithEmailCredentials(
      EmailCredentials(
        email: input.email,
        password: input.password,
      ),
    );

    return loginResult.mapErr((_) {
      _logger.error('Login failed');

      return 'Login failed';
    });
  }
}
