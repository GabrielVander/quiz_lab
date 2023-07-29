import 'package:flutter/foundation.dart';

@immutable
class SessionModel {
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
  final ProviderInfo sessionProviderInfo;
  final String ipUsedInSession;
  final OperatingSystemInfo operatingSystemInfo;
  final ClientInfo clientInfo;
  final DeviceInfo deviceInfo;
  final String countryCode;
  final String countryName;
  final bool isCurrentSession;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          sessionId == other.sessionId &&
          sessionCreationDate == other.sessionCreationDate &&
          sessionExpirationDate == other.sessionExpirationDate &&
          sessionProviderInfo == other.sessionProviderInfo &&
          ipUsedInSession == other.ipUsedInSession &&
          operatingSystemInfo == other.operatingSystemInfo &&
          clientInfo == other.clientInfo &&
          deviceInfo == other.deviceInfo &&
          countryCode == other.countryCode &&
          countryName == other.countryName &&
          isCurrentSession == other.isCurrentSession;

  @override
  int get hashCode =>
      userId.hashCode ^
      sessionId.hashCode ^
      sessionCreationDate.hashCode ^
      sessionExpirationDate.hashCode ^
      sessionProviderInfo.hashCode ^
      ipUsedInSession.hashCode ^
      operatingSystemInfo.hashCode ^
      clientInfo.hashCode ^
      deviceInfo.hashCode ^
      countryCode.hashCode ^
      countryName.hashCode ^
      isCurrentSession.hashCode;
}

@immutable
class ProviderInfo {
  const ProviderInfo({
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          uid == other.uid &&
          accessToken == other.accessToken &&
          accessTokenExpirationDate == other.accessTokenExpirationDate &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode =>
      name.hashCode ^
      uid.hashCode ^
      accessToken.hashCode ^
      accessTokenExpirationDate.hashCode ^
      refreshToken.hashCode;
}

@immutable
class OperatingSystemInfo {
  const OperatingSystemInfo({
    required this.code,
    required this.name,
    required this.version,
  });

  final String code;
  final String name;
  final String version;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperatingSystemInfo &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          name == other.name &&
          version == other.version;

  @override
  int get hashCode => code.hashCode ^ name.hashCode ^ version.hashCode;
}

@immutable
class ClientInfo {
  const ClientInfo({
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientInfo &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          code == other.code &&
          name == other.name &&
          version == other.version &&
          engineName == other.engineName &&
          engineVersion == other.engineVersion;

  @override
  int get hashCode =>
      type.hashCode ^
      code.hashCode ^
      name.hashCode ^
      version.hashCode ^
      engineName.hashCode ^
      engineVersion.hashCode;
}

@immutable
class DeviceInfo {
  const DeviceInfo({
    required this.name,
    required this.brand,
    required this.model,
  });

  final String name;
  final String brand;
  final String model;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          brand == other.brand &&
          model == other.model;

  @override
  int get hashCode => name.hashCode ^ brand.hashCode ^ model.hashCode;
}
