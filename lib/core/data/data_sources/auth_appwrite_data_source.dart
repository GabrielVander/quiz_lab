import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/models/appwrite_error_model.dart';
import 'package:quiz_lab/core/data/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/data/models/session_model.dart';
import 'package:quiz_lab/core/data/models/user_model.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';

abstract interface class AuthAppwriteDataSource {
  Future<Result<SessionModel, String>> createEmailSession(
    EmailSessionCredentialsModel credentialsModel,
  );

  Future<Result<Unit, String>> createAnonymousSession();

  Future<Result<UserModel, String>> getCurrentUser();

  Future<Result<SessionModel, AppwriteErrorModel>> getSession(
    String sessionId,
  );
}

class AuthAppwriteDataSourceImpl implements AuthAppwriteDataSource {
  AuthAppwriteDataSourceImpl({
    required this.logger,
    required this.appwriteAccountService,
  });

  final QuizLabLogger logger;
  final Account appwriteAccountService;

  @override
  Future<Result<SessionModel, String>> createEmailSession(
    EmailSessionCredentialsModel credentialsModel,
  ) async {
    logger.debug('Creating email session...');

    try {
      final session = await appwriteAccountService.createEmailSession(
        email: credentialsModel.email,
        password: credentialsModel.password,
      );

      logger.debug('Email session created successfully');

      return Ok(
        SessionModel(
          userId: session.userId,
          $id: session.$id,
          $createdAt: session.$createdAt,
          expire: session.expire,
          providerUid: session.providerUid,
          provider: session.provider,
          providerAccessToken: session.providerAccessToken,
          providerAccessTokenExpiry: session.providerAccessTokenExpiry,
          providerRefreshToken: session.providerRefreshToken,
          ip: session.ip,
          osCode: session.osCode,
          osName: session.osName,
          osVersion: session.osVersion,
          clientType: session.clientType,
          clientCode: session.clientCode,
          clientName: session.clientName,
          clientVersion: session.clientVersion,
          clientEngine: session.clientEngine,
          clientEngineVersion: session.clientEngineVersion,
          deviceName: session.deviceName,
          deviceBrand: session.deviceBrand,
          deviceModel: session.deviceModel,
          countryCode: session.countryCode,
          countryName: session.countryName,
          current: session.current,
        ),
      );
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

  Future<Result<Unit, AppwriteException>>
      _createAnonymousSessionOnAccountService() async {
    try {
      await appwriteAccountService.createAnonymousSession();
      return const Ok(unit);
    } on AppwriteException catch (e) {
      return Err(e);
    }
  }

  @override
  Future<Result<UserModel, String>> getCurrentUser() async {
    logger.debug('Fetching user information...');

    return (await _getCurrentlyLoggedInUser())
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr((_) => 'Unable to fetch user information')
        .andThen(
          (appwriteModel) => _appwriteUserToUserModel(appwriteModel).inspect(
            (_) => logger.debug('User information fetched successfully'),
          ),
        );
  }

  Result<UserModel, String> _appwriteUserToUserModel(User user) {
    try {
      return Ok(UserModel.fromAppwriteModel(user));
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

  @override
  Future<Result<SessionModel, AppwriteErrorModel>> getSession(
    String sessionId,
  ) async {
    logger.debug('Retrieving given Appwrite session...');

    return (await _fetchAppwriteSession(sessionId))
        .inspectErr((error) => logger.error(error.toString()))
        .mapErr(AppwriteErrorModel.fromAppwriteException)
        .inspect((_) => logger.debug('Appwrite session retrieved successfully'))
        .map(SessionModel.fromAppwriteSession);
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
