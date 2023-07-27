import 'package:appwrite/appwrite.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/features/auth/data/data_sources/models/session_model.dart';

class AuthAppwriteDataSource {
  AuthAppwriteDataSource({
    required Account appwriteAccountService,
  }) : _appwriteAccountService = appwriteAccountService;

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<AuthAppwriteDataSource>();

  final Account _appwriteAccountService;

  Future<Result<SessionModel, String>> createEmailSession(
    EmailSessionCredentialsModel credentialsModel,
  ) async {
    _logger.debug('Creating email session...');

    try {
      final session = await _appwriteAccountService.createEmailSession(
        email: credentialsModel.email,
        password: credentialsModel.password,
      );

      _logger.debug('Email session created successfully');

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
      _logger.error(e.toString());

      return Err(e.toString());
    }
  }

  Future<Result<Unit, String>> createAnonymousSession() async {
    throw UnimplementedError();
  }
}
