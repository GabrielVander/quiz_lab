import 'package:quiz_lab/common/data/data_sources/cache_data_source.dart';
import 'package:quiz_lab/common/data/data_sources/package_info_data_source.dart';
import 'package:quiz_lab/common/data/dto/package_info_dto.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/application_information/domain/repositories/application_version_repository.dart';
import 'package:rust_core/result.dart';

class ApplicationVersionRepositoryImpl implements ApplicationVersionRepository {
  ApplicationVersionRepositoryImpl({
    required QuizLabLogger logger,
    required CacheDataSource<String> cacheDataSource,
    required PackageInfoDataSource packageInfoDataSource,
  })  : _logger = logger,
        _cacheDataSource = cacheDataSource,
        _packageInfoDataSource = packageInfoDataSource;

  final QuizLabLogger _logger;
  final CacheDataSource<String> _cacheDataSource;
  final PackageInfoDataSource _packageInfoDataSource;

  @override
  Future<Result<String, String>> fetchVersionName() async {
    _logger.debug('Fetching version name...');

    final cacheResult = (await _fetchFromCache())
        .inspect((_) => _logger.debug('Version name fetched from cache'))
        .inspectErr(_logger.error);

    if (cacheResult.isErr()) {
      return _fetchFromPackageInformation();
    }

    return cacheResult;
  }

  Future<Result<String, String>> _fetchFromCache() async =>
      (await _cacheDataSource.fetchValue('applicationVersionName')).inspectErr(_logger.debug);

  Future<Result<String, String>> _fetchFromPackageInformation() async => (await _fetchPackageInformation())
      .map((PackageInfoDto _) => _.version)
      .inspect((String version) async => _cacheVersionName(version));

  Future<Result<PackageInfoDto, String>> _fetchPackageInformation() async =>
      (await _packageInfoDataSource.fetchPackageInformation())
          .inspectErr(_logger.error)
          .mapErr((_) => "Unable to fetch application's version name");

  Future<Result<Unit, String>> _cacheVersionName(String version) async =>
      (await _cacheDataSource.storeValue('applicationVersionName', version)).inspectErr(_logger.warn);
}
