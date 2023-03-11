import 'package:appwrite/appwrite.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

void main() {
  late _DependencyInjectionMock diMock;

  setUp(() {
    diMock = _DependencyInjectionMock();
  });

  parameterizedTest(
    'should register all dependencies',
    ParameterizedSource.values([
      [Account, () => _check<Account>(diMock)],
      [Databases, () => _check<Databases>(diMock)],
      [AppwriteDataSource, () => _check<AppwriteDataSource>(diMock)],
      [NetworkCubit, () => _check<NetworkCubit>(diMock)],
      [BottomNavigationCubit, () => _check<BottomNavigationCubit>(diMock)],
    ]),
    (values) {
      final check = values[1] as void Function();

      mocktail.when(() => diMock.get<Client>()).thenReturn(_FakeClient());
      mocktail.when(() => diMock.get<Account>()).thenReturn(_AccountMock());
      mocktail.when(() => diMock.get<Databases>()).thenReturn(_DatabasesMock());
      mocktail
          .when(() => diMock.get<AppwriteDataSourceConfiguration>())
          .thenReturn(_AppwriteDataSourceConfigurationMock());

      check();
    },
  );
}

void _check<T extends Object>(
  _DependencyInjectionMock diMock,
) {
  coreDependencyInjectionSetup(diMock);

  final captured = mocktail
      .verify(
        () => diMock.registerFactory<T>(mocktail.captureAny()),
      )
      .captured;

  final getter = captured.last as T Function(_DependencyInjectionMock);

  final account = getter(diMock);

  expect(account, isA<T>());
}

class _DependencyInjectionMock extends mocktail.Mock
    implements DependencyInjection {}

class _FakeClient extends mocktail.Fake implements Client {}

class _AccountMock extends mocktail.Mock implements Account {}

class _DatabasesMock extends mocktail.Mock implements Databases {}

class _AppwriteDataSourceConfigurationMock extends mocktail.Mock
    implements AppwriteDataSourceConfiguration {}
