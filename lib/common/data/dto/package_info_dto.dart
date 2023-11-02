import 'package:equatable/equatable.dart';

class PackageInfoDto extends Equatable {
  const PackageInfoDto({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.buildSignature,
    required this.installerStore,
  });

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  /// Note, on iOS if an app has no buildNumber specified this property will return version
  /// Docs about CFBundleVersion: https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleversion
  final String buildNumber;

  /// The build signature. Empty string on iOS, signing key signature (hex) on Android.
  final String buildSignature;

  /// The installer store. Indicates through which store this application was installed.
  final String? installerStore;

  @override
  String toString() {
    return 'PackageInfoDto{appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber, buildSignature: $buildSignature, installerStore: $installerStore}';
  }

  @override
  List<Object?> get props => [
        appName,
        packageName,
        version,
        buildNumber,
        buildSignature,
        installerStore,
      ];
}
