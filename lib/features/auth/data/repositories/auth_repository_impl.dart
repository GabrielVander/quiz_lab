import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AppwriteDataSource appwriteDataSource})
      : _appwriteDataSource = appwriteDataSource;

  final _logger = QuizLabLoggerFactory.createLogger<AuthRepository>();

  final AppwriteDataSource _appwriteDataSource;

  @override
  Future<Result<Unit, AuthRepositoryError>> loginWithEmailCredentials(
    EmailCredentials credentials,
  ) async {
    _logger.debug('Login in with email credentials...');
    final result = await _appwriteDataSource.createEmailSession(
      EmailSessionCredentialsModel(
        email: credentials.email,
        password: credentials.password,
      ),
    );

    if (result.isErr) {
      final e = AuthRepositoryError.unexpected(message: result.err!);

      _logger.error('Unable to login with email credentials');
      return Result.err(e);
    }

    return const Result.ok(unit);
  }
}
