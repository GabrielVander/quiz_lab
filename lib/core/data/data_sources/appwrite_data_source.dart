import 'package:appwrite/appwrite.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/session_model.dart';

class AppwriteDataSource {
  AppwriteDataSource({
    required Account appwriteAccountService,
  }) : _appwriteAccountService = appwriteAccountService;

  final Account _appwriteAccountService;

  Future<Result<SessionModel, String>> createEmailSession(
    EmailSessionCredentialsModel credentialsModel,
  ) async {
    try {
      final session = await _appwriteAccountService.createEmailSession(
        email: credentialsModel.email,
        password: credentialsModel.password,
      );

      return Result.ok(
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
      return Result.err(e.toString());
    }
  }
}
