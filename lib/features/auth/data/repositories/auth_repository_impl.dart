import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/auth/data/models/email_session_credentials_model.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.logger,
    required this.authDataSource,
  });

  final QuizLabLogger logger;

  final AuthAppwriteDataSource authDataSource;

  @override
  Future<Result<Unit, AuthRepositoryError>> loginWithEmailCredentials(
    EmailCredentials credentials,
  ) async {
    logger.debug('Login in with email credentials...');

    final result = await authDataSource.createEmailSession(
      EmailSessionCredentialsModel(
        email: credentials.email,
        password: credentials.password,
      ),
    );

    if (result.isErr) {
      final e = AuthRepositoryError.unexpected(message: result.unwrapErr());

      logger.error('Unable to login');
      return Err(e);
    }

    return const Ok(unit);
  }

  @override
  Future<Result<Unit, String>> loginAnonymously() async {
    logger.debug('Logging in anonymously...');

    return (await authDataSource.createAnonymousSession())
        .inspectErr(logger.error)
        .mapErr((_) => 'Unable to login anonymously');
  }
}
