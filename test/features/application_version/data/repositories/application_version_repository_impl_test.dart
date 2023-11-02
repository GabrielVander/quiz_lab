import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/cache_data_source.dart';
import 'package:quiz_lab/common/data/data_sources/package_info_data_source.dart';
import 'package:quiz_lab/common/data/dto/package_info_dto.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/application_version/data/repositories/application_version_repository_impl.dart';
import 'package:quiz_lab/features/application_version/domain/repositories/application_version_repository.dart';

void main() {
  late QuizLabLogger logger;
  late CacheDataSource<String> cacheDataSource;
  late PackageInfoDataSource packageInfoDataSource;

  late ApplicationVersionRepository repository;

  setUp(() {
    logger = _MockQuizLabLogger();
    cacheDataSource = _MockCacheDataSource();
    packageInfoDataSource = _MockPackageInfoDataSource();

    repository = ApplicationVersionRepositoryImpl(
      logger: logger,
      cacheDataSource: cacheDataSource,
      packageInfoDataSource: packageInfoDataSource,
    );
  });

  group('fetchVersionName', () {
    test('should log initial message', () {
      when(() => cacheDataSource.fetchValue(any<String>())).thenAnswer((_) async => const Ok('7Vbg!'));

      repository.fetchVersionName();

      verify(() => logger.debug('Fetching version name...')).called(1);
    });

    group('should return Ok if cache data source contains a cached version name', () {
      for (final version in ['!Xd0%i&', r'C$pF']) {
        test('with version: $version', () async {
          when(() => cacheDataSource.fetchValue(any<String>())).thenAnswer((_) async => Ok(version));

          final result = await repository.fetchVersionName();

          verify(() => cacheDataSource.fetchValue('applicationVersionName')).called(1);
          verifyNever(() => packageInfoDataSource.fetchPackageInformation());
          expect(result, Ok<String, dynamic>(version));
        });
      }
    });

    group('should return Err if package info data source fails', () {
      for (final entry in [('T3DM9b', 'T5c3ppT'), (r'%pG%J$5w', 'VDa')]) {
        final cacheDataSourceMessage = entry.$1;
        final packageInfoDataSourceMessage = entry.$2;

        test(
          'with $cacheDataSourceMessage as cache data source message and $packageInfoDataSourceMessage as package info data source message',
          () async {
            when(() => cacheDataSource.fetchValue(any<String>())).thenAnswer((_) async => Err(cacheDataSourceMessage));
            when(() => packageInfoDataSource.fetchPackageInformation())
                .thenAnswer((_) async => Err(packageInfoDataSourceMessage));

            final result = await repository.fetchVersionName();

            verify(() => logger.debug(cacheDataSourceMessage)).called(1);
            verify(() => packageInfoDataSource.fetchPackageInformation()).called(1);
            verify(() => logger.error(packageInfoDataSourceMessage)).called(1);
            expect(result, const Err<dynamic, String>("Unable to fetch application's version name"));
            verifyNever(() => cacheDataSource.storeValue(any<String>(), any<String>()));
          },
        );
      }
    });

    group('should return Ok if unable to cache version name', () {
      for (final entry in [('^K!1Dq', '@588'), ('G%OMr', 'BYm7U76')]) {
        final version = entry.$1;
        final cacheDataSourceMessage = entry.$2;

        test('with $version as version and $cacheDataSourceMessage as cache data source message', () async {
          when(() => cacheDataSource.fetchValue(any<String>())).thenAnswer((_) async => Err(cacheDataSourceMessage));
          when(() => packageInfoDataSource.fetchPackageInformation()).thenAnswer(
            (_) async => Ok(
              PackageInfoDto(
                appName: '*nM^',
                buildNumber: '@eJh7Q6&',
                buildSignature: 'i*dS',
                installerStore: null,
                packageName: 'oEoMh2',
                version: version,
              ),
            ),
          );
          when(() => cacheDataSource.storeValue(any<String>(), any<String>())).thenAnswer((_) async => Err(cacheDataSourceMessage));

          final result = await repository.fetchVersionName();

          verify(() => cacheDataSource.storeValue('applicationVersionName', version)).called(1);
          verify(() => logger.warn(cacheDataSourceMessage)).called(1);
          expect(result, Ok<String, dynamic>(version));
        });
      }
    });

    group('should return Ok if version is cached successfully', () {
      for (final entry in [(r'hiHOy4$', 'tv#SC4'), ('rS#BB4&3', '7Gi4X')]) {
        final cacheDataSourceMessage = entry.$1;
        final version = entry.$2;

        test('with $cacheDataSourceMessage as cache data source message and $version as version', () async {
          when(() => cacheDataSource.fetchValue(any<String>())).thenAnswer((_) async => Err(cacheDataSourceMessage));
          when(() => packageInfoDataSource.fetchPackageInformation()).thenAnswer(
            (_) async => Ok(
              PackageInfoDto(
                appName: '*nM^',
                buildNumber: '@eJh7Q6&',
                buildSignature: 'i*dS',
                installerStore: null,
                packageName: 'oEoMh2',
                version: version,
              ),
            ),
          );
          when(() => cacheDataSource.storeValue(any<String>(), any<String>())).thenAnswer((_) async => const Ok(unit));

          final result = await repository.fetchVersionName();

          verify(() => logger.debug(cacheDataSourceMessage)).called(1);
          verify(() => packageInfoDataSource.fetchPackageInformation()).called(1);
          verify(() => cacheDataSource.storeValue('applicationVersionName', version)).called(1);
          expect(result, Ok<String, dynamic>(version));
        });
      }
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockPackageInfoDataSource extends Mock implements PackageInfoDataSource {}

class _MockCacheDataSource<String> extends Mock implements CacheDataSource<String> {}
