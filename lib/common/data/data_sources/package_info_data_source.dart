import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/common/data/dto/package_info_dto.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class PackageInfoDataSource {
  Future<Result<PackageInfoDto, String>> fetchPackageInformation();
}

class PackageInfoDataSourceImpl implements PackageInfoDataSource {
  PackageInfoDataSourceImpl({required this.logger});

  final QuizLabLogger logger;

  @override
  Future<Result<PackageInfoDto, String>> fetchPackageInformation() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return Ok(
      PackageInfoDto(
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        buildSignature: packageInfo.buildSignature,
        installerStore: packageInfo.installerStore,
      ),
    );
  }
}
