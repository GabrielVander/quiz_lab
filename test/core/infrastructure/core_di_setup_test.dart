import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/core/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/core/domain/repository/auth_repository.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';

void main() {
  late DependencyInjection di;

  setUp(() {
    di = _DependencyInjectionMock();
  });

  group(
    'should register all dependencies',
    () {
      // TODO(gabriel): This is a nightmare. In an attempt of generalization these tests became almost unreadable and unnassertive
      for (final values in [
        [
          Account,
          () {
            when(() => di.get<Client>()).thenReturn(_FakeClient());

            _checkFactory<Account>(di);
          }
        ],
        [
          Databases,
          () {
            when(() => di.get<Client>()).thenReturn(_FakeClient());

            _checkFactory<Databases>(di);
          }
        ],
        [
          Realtime,
          () {
            when(() => di.get<Client>()).thenReturn(_FakeClient());

            _checkFactory<Realtime>(di);
          }
        ],
        [
          AppwriteWrapper,
          () {
            when(() => di.get<Databases>()).thenReturn(_DatabasesMock());

            _checkFactory<AppwriteWrapper>(di);
          }
        ],
        [
          AppwriteDataSource,
          () {
            when(() => di.get<Databases>()).thenReturn(_DatabasesMock());
            when(() => di.get<Realtime>()).thenReturn(_RealtimeMock());
            when(() => di.get<AppwriteReferencesConfig>()).thenReturn(_AppwriteDataSourceConfigurationMock());

            _checkFactory<AppwriteDataSource>(di);
          }
        ],
        [NetworkCubit, () => _checkFactory<NetworkCubit>(di)],
        [BottomNavigationCubit, () => _checkFactory<BottomNavigationCubit>(di)],
        [
          PackageInfoWrapper,
          () {
            when(() => di.get<PackageInfo>()).thenReturn(_PackageInfoMock());

            _checkFactory<PackageInfoWrapper>(di);
          }
        ],
        [
          FetchApplicationVersionUseCase,
          () {
            when(() => di.get<PackageInfoWrapper>()).thenReturn(_PackageInfoWrapperMock());
            _checkBuilder<FetchApplicationVersionUseCase>(di);
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

  test('AuthAppwriteDataSource', () {
    final mockAppwriteAccountService = _MockAccount();

    when(() => di.get<Account>()).thenReturn(mockAppwriteAccountService);

    coreDependencyInjectionSetup(di);

    final captured = verify(() => di.registerBuilder<AuthAppwriteDataSource>(captureAny())).captured;

    final builder = captured.single as AuthAppwriteDataSource Function(DependencyInjection);
    final dataSource = builder(di);

    expect(dataSource, isA<AuthAppwriteDataSourceImpl>());
    final dataSourceImpl = dataSource as AuthAppwriteDataSourceImpl;

    expect(dataSourceImpl.logger, isA<QuizLabLoggerImpl<AuthAppwriteDataSourceImpl>>());
    expect(dataSourceImpl.appwriteAccountService, same(mockAppwriteAccountService));
  });

  test('AuthRepository', () {
    final mockAuthAppwriteDataSource = _MockAuthAppwriteDataSource();

    when(() => di.get<AuthAppwriteDataSource>()).thenReturn(mockAuthAppwriteDataSource);

    coreDependencyInjectionSetup(di);

    final captured = verify(() => di.registerBuilder<AuthRepository>(captureAny())).captured;

    final builder = captured.single as AuthRepository Function(DependencyInjection);
    final repository = builder(di);

    expect(repository, isA<AuthRepositoryImpl>());
    final repositoryImpl = repository as AuthRepositoryImpl;

    expect(repositoryImpl.logger, isA<QuizLabLoggerImpl<AuthRepositoryImpl>>());
    expect(repositoryImpl.authDataSource, same(mockAuthAppwriteDataSource));
  });
}

void _checkFactory<T extends Object>(DependencyInjection diMock) {
  coreDependencyInjectionSetup(diMock);

  final captured = verify(() => diMock.registerFactory<T>(captureAny())).captured;

  final getter = captured.last as T Function(DependencyInjection);

  final instance = getter(diMock);

  expect(instance, isA<T>());
}

void _checkBuilder<T extends Object>(DependencyInjection diMock) {
  coreDependencyInjectionSetup(diMock);

  final captured = verify(() => diMock.registerBuilder<T>(captureAny())).captured;

  final getter = captured.last as T Function(DependencyInjection);

  final instance = getter(diMock);

  expect(instance, isA<T>());
}

class _DependencyInjectionMock extends Mock implements DependencyInjection {}

class _MockAccount extends Mock implements Account {}

class _MockAuthAppwriteDataSource extends Mock implements AuthAppwriteDataSource {}

class _FakeClient extends Fake implements Client {}

class _DatabasesMock extends Mock implements Databases {}

class _AppwriteDataSourceConfigurationMock extends Mock implements AppwriteReferencesConfig {}

class _RealtimeMock extends Mock implements Realtime {}

class _PackageInfoMock extends Mock implements PackageInfo {}

class _PackageInfoWrapperMock extends Mock implements PackageInfoWrapper {}
