import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/infrastructure/di_setup.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

void main() {
  late DependencyInjection diMock;

  setUp(() {
    diMock = _DependencyInjectionMock();
  });

  group('should register all dependencies', () {
    test('appwrite account service', () {
      mocktail.when(() => diMock.get<Client>()).thenReturn(_FakeClient());

      coreDependencyInjectionSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock.registerInstance<Account>(mocktail.captureAny()),
          )
          .captured;

      final getter = captured.last as Account Function(DependencyInjection);

      final account = getter(diMock);

      expect(account, isA<Account>());
    });

    test('appwrite datasource', () {
      mocktail.when(() => diMock.get<Account>()).thenReturn(_FakeAccount());

      coreDependencyInjectionSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock
                .registerFactory<AppwriteDataSource>(mocktail.captureAny()),
          )
          .captured;

      final factory =
          captured.last as AppwriteDataSource Function(DependencyInjection);

      final dataSource = factory(diMock);

      expect(dataSource, isA<AppwriteDataSource>());
    });

    test('network cubit', () {
      coreDependencyInjectionSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock.registerFactory<NetworkCubit>(
              mocktail.captureAny(),
            ),
          )
          .captured;

      final factory =
          captured.last as NetworkCubit Function(DependencyInjection);

      final cubit = factory(diMock);

      expect(cubit, isA<NetworkCubit>());
    });

    test('bottom navigation cubit', () {
      coreDependencyInjectionSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock.registerFactory<BottomNavigationCubit>(
              mocktail.captureAny(),
            ),
          )
          .captured;

      final factory = captured.last as BottomNavigationCubit Function(
        DependencyInjection,
      );

      final cubit = factory(diMock);

      expect(cubit, isA<BottomNavigationCubit>());
    });
  });
}

class _DependencyInjectionMock extends mocktail.Mock
    implements DependencyInjection {}

class _FakeClient extends mocktail.Fake implements Client {}

class _FakeAccount extends mocktail.Fake implements Account {}
