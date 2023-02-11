import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';

class LoginWithCredentialsUseCaseImpl implements LoginWithCredentialsUseCase {
  LoginWithCredentialsUseCaseImpl({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<Unit, String>> call(
    LoginWithCredentialsUseCaseInput input,
  ) async {
    final loginResult = await _authRepository.loginWithEmailCredentials(
      EmailCredentials(
        email: input.email,
        password: input.password,
      ),
    );

    return loginResult.mapErr(_mapError);
  }

  String _mapError(AuthRepositoryError error) {
    if (error is AuthRepositoryUnexpectedError) {
      return 'Unable to login: ${error.message}';
    }

    return 'Unable to login: Unknown error\n$error';
  }
}
