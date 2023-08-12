import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:okay/okay.dart';
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
          sessionId: session.$id,
          sessionCreationDate: session.$createdAt,
          sessionExpirationDate: session.expire,
          sessionProviderInfo: ProviderInfo(
            uid: session.providerUid,
            name: session.provider,
            accessToken: session.providerAccessToken,
            accessTokenExpirationDate: session.providerAccessTokenExpiry,
            refreshToken: session.providerRefreshToken,
          ),
          ipUsedInSession: session.ip,
          operatingSystemInfo: OperatingSystemInfo(
            code: session.osCode,
            name: session.osName,
            version: session.osVersion,
          ),
          clientInfo: ClientInfo(
            type: session.clientType,
            code: session.clientCode,
            name: session.clientName,
            version: session.clientVersion,
            engineName: session.clientEngine,
            engineVersion: session.clientEngineVersion,
          ),
          deviceInfo: DeviceInfo(
            name: session.deviceName,
            brand: session.deviceBrand,
            model: session.deviceModel,
          ),
          countryCode: session.countryCode,
          countryName: session.countryName,
          isCurrentSession: session.current,
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
}
