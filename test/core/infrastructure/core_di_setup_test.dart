import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';

void main() {
  late DependencyInjection depedencyInjection;

  setUp(() {
    depedencyInjection = _DependencyInjectionMock();
  });

  group(
    'should register all dependencies',
    () {
      // TODO(gabriel): This is a nightmare. In an attempt of generalization these tests became almost unreadable and unnassertive
      for (final values in [
        [
          Account,
          () {
            when(() => depedencyInjection.get<Client>())
                .thenReturn(_FakeClient());

            _checkFactory<Account>(depedencyInjection);
          }
        ],
        [
          Databases,
          () {
            when(() => depedencyInjection.get<Client>())
                .thenReturn(_FakeClient());

            _checkFactory<Databases>(depedencyInjection);
          }
        ],
        [
          Realtime,
          () {
            when(() => depedencyInjection.get<Client>())
                .thenReturn(_FakeClient());

            _checkFactory<Realtime>(depedencyInjection);
          }
        ],
        [
          AppwriteWrapper,
          () {
            when(() => depedencyInjection.get<Databases>())
                .thenReturn(_DatabasesMock());

            _checkFactory<AppwriteWrapper>(depedencyInjection);
          }
        ],
        [
          AppwriteDataSource,
          () {
            when(() => depedencyInjection.get<Databases>())
                .thenReturn(_DatabasesMock());
            when(() => depedencyInjection.get<Realtime>())
                .thenReturn(_RealtimeMock());
            when(() => depedencyInjection.get<AppwriteReferencesConfig>())
                .thenReturn(_AppwriteDataSourceConfigurationMock());

            _checkFactory<AppwriteDataSource>(depedencyInjection);
          }
        ],
        [NetworkCubit, () => _checkFactory<NetworkCubit>(depedencyInjection)],
        [
          BottomNavigationCubit,
          () => _checkFactory<BottomNavigationCubit>(depedencyInjection)
        ],
        [
          PackageInfoWrapper,
          () {
            when(() => depedencyInjection.get<PackageInfo>())
                .thenReturn(_PackageInfoMock());

            _checkFactory<PackageInfoWrapper>(depedencyInjection);
          }
        ],
        [
          FetchApplicationVersionUseCase,
          () {
            when(() => depedencyInjection.get<PackageInfoWrapper>())
                .thenReturn(_PackageInfoWrapperMock());
            _checkBuilder<FetchApplicationVersionUseCase>(depedencyInjection);
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

void _checkFactory<T extends Object>(DependencyInjection diMock) {
  coreDependencyInjectionSetup(diMock);

  final captured =
      verify(() => diMock.registerFactory<T>(captureAny())).captured;

  final getter = captured.last as T Function(DependencyInjection);

  final instance = getter(diMock);

  expect(instance, isA<T>());
}

void _checkBuilder<T extends Object>(DependencyInjection diMock) {
  coreDependencyInjectionSetup(diMock);

  final captured =
      verify(() => diMock.registerBuilder<T>(captureAny())).captured;

  final getter = captured.last as T Function(DependencyInjection);

  final instance = getter(diMock);

  expect(instance, isA<T>());
}

class _DependencyInjectionMock extends Mock implements DependencyInjection {}

class _FakeClient extends Fake implements Client {}

class _DatabasesMock extends Mock implements Databases {}

class _AppwriteDataSourceConfigurationMock extends Mock
    implements AppwriteReferencesConfig {}

class _RealtimeMock extends Mock implements Realtime {}

class _PackageInfoMock extends Mock implements PackageInfo {}

class _PackageInfoWrapperMock extends Mock implements PackageInfoWrapper {}
