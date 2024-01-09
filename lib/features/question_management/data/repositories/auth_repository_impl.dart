import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_session_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/create_appwrite_email_session_dto.dart';
import 'package:quiz_lab/features/question_management/domain/entities/current_user_session.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';

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
      CreateAppwriteEmailSessionDto(
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

  @override
  Future<Result<bool, String>> isLoggedIn() async {
    logger.debug('Checking if user is logged in...');

    return (await authDataSource.getCurrentUser())
        .inspectErr(logger.error)
        .map((_) => true)
        .inspect((_) => logger.debug('User is logged in'))
        .or(const Ok<bool, String>(false));
  }

  @override
  Future<Result<CurrentUserSession?, String>> getCurrentSession() async {
    logger.debug('Fetching current session...');

    return (await authDataSource.getSession('current'))
        .inspectErr((error) => logger.error(error.toString()))
        .mapErr((_) => 'Unable to fetch current session')
        .map((dto) => CurrentUserSession(provider: _buildProvider(dto)));
  }

  SessionProvider _buildProvider(AppwriteSessionDto dto) {
    switch (dto.provider) {
      case 'email':
        return SessionProvider.email;
      case 'anonymous':
        return SessionProvider.anonymous;
      default:
        return SessionProvider.unknown;
    }
  }
}
