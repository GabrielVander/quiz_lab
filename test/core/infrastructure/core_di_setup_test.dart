import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';

void main() {
  late _DependencyInjectionMock diMock;

  setUp(() {
    diMock = _DependencyInjectionMock();
  });

  group(
    'should register all dependencies',
    () {
      for (final values in [
        [
          Account,
          () {
            mocktail.when(() => diMock.get<Client>()).thenReturn(_FakeClient());

            _checkFactory<Account>(diMock);
          }
        ],
        [
          Databases,
          () {
            mocktail.when(() => diMock.get<Client>()).thenReturn(_FakeClient());

            _checkFactory<Databases>(diMock);
          }
        ],
        [
          Realtime,
          () {
            mocktail.when(() => diMock.get<Client>()).thenReturn(_FakeClient());

            _checkFactory<Realtime>(diMock);
          }
        ],
        [
          AppwriteWrapper,
          () {
            mocktail.when(() => diMock.get<Databases>()).thenReturn(_DatabasesMock());

            _checkFactory<AppwriteWrapper>(diMock);
          }
        ],
        [
          AppwriteDataSource,
          () {
            mocktail.when(() => diMock.get<Databases>()).thenReturn(_DatabasesMock());
            mocktail.when(() => diMock.get<Realtime>()).thenReturn(_RealtimeMock());
            mocktail
                .when(() => diMock.get<AppwriteReferencesConfig>())
                .thenReturn(_AppwriteDataSourceConfigurationMock());

            _checkFactory<AppwriteDataSource>(diMock);
          }
        ],
        [NetworkCubit, () => _checkFactory<NetworkCubit>(diMock)],
        [BottomNavigationCubit, () => _checkFactory<BottomNavigationCubit>(diMock)],
        [
          PackageInfoWrapper,
          () {
            mocktail.when(() => diMock.get<PackageInfo>()).thenReturn(_PackageInfoMock());

            _checkFactory<PackageInfoWrapper>(diMock);
          }
        ],
        [
          FetchApplicationVersionUseCase,
          () {
            mocktail
                .when(() => diMock.get<PackageInfoWrapper>())
                .thenReturn(_PackageInfoWrapperMock());
            _checkBuilder<FetchApplicationVersionUseCase>(diMock);
          }
        ],
      ]) {
        test(values.toString(), () {
          final check = values[1] as void Function();

          check();
        });
      }
    },
  );
}

void _checkFactory<T extends Object>(
  _DependencyInjectionMock diMock,
) {
  coreDependencyInjectionSetup(diMock);

  final captured = mocktail
      .verify(
        () => diMock.registerFactory<T>(mocktail.captureAny()),
      )
      .captured;

  final getter = captured.last as T Function(_DependencyInjectionMock);

  final instance = getter(diMock);

  expect(instance, isA<T>());
}

void _checkBuilder<T extends Object>(
  _DependencyInjectionMock diMock,
) {
  coreDependencyInjectionSetup(diMock);

  final captured = mocktail
      .verify(
        () => diMock.registerBuilder<T>(mocktail.captureAny()),
      )
      .captured;

  final getter = captured.last as T Function(_DependencyInjectionMock);

  final instance = getter(diMock);

  expect(instance, isA<T>());
}

class _DependencyInjectionMock extends mocktail.Mock implements DependencyInjection {}

class _FakeClient extends mocktail.Fake implements Client {}

class _DatabasesMock extends mocktail.Mock implements Databases {}

class _AppwriteDataSourceConfigurationMock extends mocktail.Mock
    implements AppwriteReferencesConfig {}

class _RealtimeMock extends mocktail.Mock implements Realtime {}

class _PackageInfoMock extends mocktail.Mock implements PackageInfo {}

class _PackageInfoWrapperMock extends mocktail.Mock implements PackageInfoWrapper {}
