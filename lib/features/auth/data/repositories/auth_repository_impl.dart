import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/auth/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthAppwriteDataSource authDataSource,
  }) : _authDataSource = authDataSource;

  final _logger = QuizLabLoggerFactory.createLogger<AuthRepository>();

  final AuthAppwriteDataSource _authDataSource;

  @override
  Future<Result<Unit, AuthRepositoryError>> loginWithEmailCredentials(
    EmailCredentials credentials,
  ) async {
    _logger.debug('Login in with email credentials...');

    final result = await _authDataSource.createEmailSession(
      EmailSessionCredentialsModel(
        email: credentials.email,
        password: credentials.password,
      ),
    );

    if (result.isErr) {
      final e = AuthRepositoryError.unexpected(message: result.unwrapErr());

      _logger.error('Unable to login');
      return Err(e);
    }

    return const Ok(unit);
  }

  @override
  Future<Result<Unit, String>> loginAnonymously() {
    // TODO: implement loginAnonymously
    throw UnimplementedError();
  }
}
