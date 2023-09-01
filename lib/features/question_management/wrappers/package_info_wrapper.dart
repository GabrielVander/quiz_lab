import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoWrapper {
  PackageInfoWrapper({required PackageInfo packageInfo})
      : _packageInfo = packageInfo;

  final PackageInfo _packageInfo;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on
  /// Android.
  String get applicationVersion => _packageInfo.version;
}
