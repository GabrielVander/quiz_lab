import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/dto/package_info_dto.dart';

// ignore: one_member_abstracts
abstract interface class PackageInfoDataSource {
  Future<Result<PackageInfoDto, String>> fetchPackageInformation();
}
