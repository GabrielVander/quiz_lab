import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  const SessionModel({
    required this.userId,
    required this.sessionId,
    required this.sessionCreationDate,
    required this.sessionExpirationDate,
    required this.sessionProviderInfo,
    required this.ipUsedInSession,
    required this.operatingSystemInfo,
    required this.clientInfo,
    required this.deviceInfo,
    required this.countryCode,
    required this.countryName,
    required this.isCurrentSession,
  });

  final String userId;
  final String sessionId;
  final String sessionCreationDate;
  final String sessionExpirationDate;
  final ProviderInfoModel sessionProviderInfo;
  final String ipUsedInSession;
  final OperatingSystemInfoModel operatingSystemInfo;
  final ClientInfoModel clientInfo;
  final DeviceInfoModel deviceInfo;
  final String countryCode;
  final String countryName;
  final bool isCurrentSession;

  @override
  List<Object> get props => [
        userId,
        sessionId,
        sessionCreationDate,
        sessionExpirationDate,
        sessionProviderInfo,
        ipUsedInSession,
        operatingSystemInfo,
        clientInfo,
        deviceInfo,
        countryCode,
        countryName,
        isCurrentSession,
      ];

  @override
  String toString() => 'SessionModel{'
      'userId: $userId, '
      'sessionId: $sessionId, '
      'sessionCreationDate: $sessionCreationDate, '
      'sessionExpirationDate: $sessionExpirationDate, '
      'sessionProviderInfo: $sessionProviderInfo, '
      'ipUsedInSession: $ipUsedInSession, '
      'operatingSystemInfo: $operatingSystemInfo, '
      'clientInfo: $clientInfo, '
      'deviceInfo: $deviceInfo, '
      'countryCode: $countryCode, '
      'countryName: $countryName, '
      'isCurrentSession: $isCurrentSession'
      '}';
}

class ProviderInfoModel extends Equatable {
  const ProviderInfoModel({
    required this.name,
    required this.uid,
    required this.accessToken,
    required this.accessTokenExpirationDate,
    required this.refreshToken,
  });

  final String name;
  final String uid;
  final String accessToken;
  final String accessTokenExpirationDate;
  final String refreshToken;

  @override
  String toString() => 'ProviderInfoModel{'
      'name: $name, '
      'uid: $uid, '
      'accessToken: $accessToken, '
      'accessTokenExpirationDate: $accessTokenExpirationDate, '
      'refreshToken: $refreshToken'
      '}';

  @override
  List<Object> get props => [
        name,
        uid,
        accessToken,
        accessTokenExpirationDate,
        refreshToken,
      ];
}

class OperatingSystemInfoModel extends Equatable {
  const OperatingSystemInfoModel({
    required this.code,
    required this.name,
    required this.version,
  });

  final String code;
  final String name;
  final String version;

  @override
  String toString() => 'OperatingSystemInfoModel{'
      'code: $code, '
      'name: $name, '
      'version: $version'
      '}';

  @override
  List<Object> get props => [code, name, version];
}

class ClientInfoModel extends Equatable {
  const ClientInfoModel({
    required this.type,
    required this.code,
    required this.name,
    required this.version,
    required this.engineName,
    required this.engineVersion,
  });

  final String type;
  final String code;
  final String name;
  final String version;
  final String engineName;
  final String engineVersion;

  @override
  String toString() => 'ClientInfoModel{'
      'type: $type, '
      'code: $code, '
      'name: $name, '
      'version: $version, '
      'engineName: $engineName, '
      'engineVersion: $engineVersion'
      '}';

  @override
  List<Object> get props => [
        type,
        code,
        name,
        version,
        engineName,
        engineVersion,
      ];
}

class DeviceInfoModel extends Equatable {
  const DeviceInfoModel({
    required this.name,
    required this.brand,
    required this.model,
  });

  final String name;
  final String brand;
  final String model;

  @override
  String toString() =>
      'DeviceInfoModel{name: $name, brand: $brand, model: $model}';

  @override
  List<Object> get props => [name, brand, model];
}
