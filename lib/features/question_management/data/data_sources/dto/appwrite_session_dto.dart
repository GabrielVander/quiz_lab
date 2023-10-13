import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';

class AppwriteSessionDto extends Equatable {
  const AppwriteSessionDto({
    required this.$id,
    required this.$createdAt,
    required this.userId,
    required this.expire,
    required this.provider,
    required this.providerUid,
    required this.providerAccessToken,
    required this.providerAccessTokenExpiry,
    required this.providerRefreshToken,
    required this.ip,
    required this.osCode,
    required this.osName,
    required this.osVersion,
    required this.clientType,
    required this.clientCode,
    required this.clientName,
    required this.clientVersion,
    required this.clientEngine,
    required this.clientEngineVersion,
    required this.deviceName,
    required this.deviceBrand,
    required this.deviceModel,
    required this.countryCode,
    required this.countryName,
    required this.current,
  });

  factory AppwriteSessionDto.fromAppwriteSession(Session session) => AppwriteSessionDto(
        $id: session.$id,
        $createdAt: session.$createdAt,
        userId: session.userId,
        expire: session.expire,
        provider: session.provider,
        providerUid: session.providerUid,
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
      );

  final String $id;
  final String $createdAt;
  final String userId;
  final String expire;
  final String provider;
  final String providerUid;
  final String providerAccessToken;
  final String providerAccessTokenExpiry;
  final String providerRefreshToken;
  final String ip;
  final String osCode;
  final String osName;
  final String osVersion;
  final String clientType;
  final String clientCode;
  final String clientName;
  final String clientVersion;
  final String clientEngine;
  final String clientEngineVersion;
  final String deviceName;
  final String deviceBrand;
  final String deviceModel;
  final String countryCode;
  final String countryName;
  final bool current;

  @override
  String toString() => 'AppwriteSessionDto{'
      '\$id: ${$id}, '
      '\$createdAt: ${$createdAt}, '
      'userId: $userId, '
      'expire: $expire, '
      'provider: $provider, '
      'providerUid: $providerUid, '
      'providerAccessToken: $providerAccessToken, '
      'providerAccessTokenExpiry: $providerAccessTokenExpiry, '
      'providerRefreshToken: $providerRefreshToken, '
      'ip: $ip, '
      'osCode: $osCode, '
      'osName: $osName, '
      'osVersion: $osVersion, '
      'clientType: $clientType, '
      'clientCode: $clientCode, '
      'clientName: $clientName, '
      'clientVersion: $clientVersion, '
      'clientEngine: $clientEngine, '
      'clientEngineVersion: $clientEngineVersion, '
      'deviceName: $deviceName, '
      'deviceBrand: $deviceBrand, '
      'deviceModel: $deviceModel, '
      'countryCode: $countryCode, '
      'countryName: $countryName, '
      'current: $current'
      '}';

  @override
  List<Object> get props => [
        $id,
        $createdAt,
        userId,
        expire,
        provider,
        providerUid,
        providerAccessToken,
        providerAccessTokenExpiry,
        providerRefreshToken,
        ip,
        osCode,
        osName,
        osVersion,
        clientType,
        clientCode,
        clientName,
        clientVersion,
        clientEngine,
        clientEngineVersion,
        deviceName,
        deviceBrand,
        deviceModel,
        countryCode,
        countryName,
        current,
      ];
}
