import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/common/data/dto/appwrite_error_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_session_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_user_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/create_appwrite_email_session_dto.dart';

// TODO(GabrielVander): Maybe this class would be better named AppwriteAccountDataSource
abstract interface class AuthAppwriteDataSource {
  Future<Result<AppwriteSessionDto, String>> createEmailSession(CreateAppwriteEmailSessionDto dto);

  Future<Result<Unit, String>> createAnonymousSession();

  Future<Result<AppwriteUserDto, String>> getCurrentUser();

  Future<Result<AppwriteSessionDto, AppwriteErrorDto>> getSession(String sessionId);
}

class AuthAppwriteDataSourceImpl implements AuthAppwriteDataSource {
  AuthAppwriteDataSourceImpl({
    required this.logger,
    required this.appwriteAccountService,
  });

  final QuizLabLogger logger;
  final Account appwriteAccountService;

  @override
  Future<Result<AppwriteSessionDto, String>> createEmailSession(CreateAppwriteEmailSessionDto dto) async {
    logger.debug('Creating email session...');

    try {
      final session = await appwriteAccountService.createEmailSession(
        email: dto.email,
        password: dto.password,
      );

      logger.debug('Email session created successfully');

      return Ok(AppwriteSessionDto.fromAppwriteSession(session));
    } on AppwriteException catch (e) {
      logger.error(e.toString());

      return Err(e.toString());
    }
  }

  @override
  Future<Result<Unit, String>> createAnonymousSession() async {
    logger.debug('Creating anonymous session...');

    return (await _createAnonymousSessionOnAccountService())
        .inspect((_) => logger.debug('Anonymous session created successfully'))
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr((_) => 'Unable to create anonymous session');
  }

  @override
  Future<Result<AppwriteUserDto, String>> getCurrentUser() async {
    logger.debug('Fetching user information...');

    return (await _getCurrentlyLoggedInUser())
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr((_) => 'Unable to fetch user information')
        .andThen(
          (appwriteModel) => _appwriteUserModelToUserDto(appwriteModel)
              .inspect((_) => logger.debug('User information fetched successfully')),
        );
  }

  @override
  Future<Result<AppwriteSessionDto, AppwriteErrorDto>> getSession(String sessionId) async {
    logger.debug('Retrieving given Appwrite session...');

    return (await _fetchAppwriteSession(sessionId))
        .inspectErr((error) => logger.error(error.toString()))
        .mapErr(AppwriteErrorDto.fromAppwriteException)
        .inspect((_) => logger.debug('Appwrite session retrieved successfully'))
        .map(AppwriteSessionDto.fromAppwriteSession);
  }

  Future<Result<Unit, AppwriteException>> _createAnonymousSessionOnAccountService() async {
    try {
      await appwriteAccountService.createAnonymousSession();
      return const Ok(unit);
    } on AppwriteException catch (e) {
      return Err(e);
    }
  }

  Result<AppwriteUserDto, String> _appwriteUserModelToUserDto(User model) {
    try {
      return Ok(AppwriteUserDto.fromAppwriteModel(model));
    } catch (e) {
      logger.error(e.toString());
      return const Err('Unable to map user information');
    }
  }

  Future<Result<User, AppwriteException>> _getCurrentlyLoggedInUser() async {
    try {
      return Ok(await appwriteAccountService.get());
    } on AppwriteException catch (e) {
      return Err(e);
    }
  }

  Future<Result<Session, AppwriteException>> _fetchAppwriteSession(
    String sessionId,
  ) async {
    try {
      return Ok(await appwriteAccountService.getSession(sessionId: sessionId));
    } on AppwriteException catch (e) {
      return Err(e);
    }
  }
}
