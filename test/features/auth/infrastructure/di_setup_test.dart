import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/impl/login_with_credentials_use_case_impl.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/infrastructure/di_setup.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';

void main() {
  late DependencyInjection diMock;

  setUp(() {
    diMock = _DependencyInjectionMock();
  });

  group('should register all dependencies', () {
    test('auth repository', () {
      mocktail
          .when(() => diMock.get<AppwriteDataSource>())
          .thenReturn(_FakeAppwriteDataSource());

      authenticationDiSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock.registerFactory<AuthRepository>(mocktail.captureAny()),
          )
          .captured;

      final factory =
          captured.last as AuthRepository Function(DependencyInjection);

      final authRepository = factory(diMock);

      expect(authRepository, isA<AuthRepositoryImpl>());
    });

    test('login with credentials use case', () {
      mocktail
          .when(() => diMock.get<AuthRepository>())
          .thenReturn(_FakeAuthRepository());

      authenticationDiSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock.registerFactory<LoginWithCredentialsUseCase>(
              mocktail.captureAny(),
            ),
          )
          .captured;

      final factory = captured.last as LoginWithCredentialsUseCase Function(
        DependencyInjection,
      );

      final useCase = factory(diMock);

      expect(useCase, isA<LoginWithCredentialsUseCaseImpl>());
    });

    test('login page cubit', () {
      mocktail
          .when(() => diMock.get<LoginWithCredentialsUseCase>())
          .thenReturn(_FakeLoginWithCredentialsUseCase());

      authenticationDiSetup(diMock);

      final captured = mocktail
          .verify(
            () => diMock.registerFactory<LoginPageCubit>(
              mocktail.captureAny(),
            ),
          )
          .captured;

      final factory = captured.last as LoginPageCubit Function(
        DependencyInjection,
      );

      final cubit = factory(diMock);

      expect(cubit, isA<LoginPageCubit>());
    });
  });
}

class _DependencyInjectionMock extends mocktail.Mock
    implements DependencyInjection {}

class _FakeAppwriteDataSource extends mocktail.Fake
    implements AppwriteDataSource {}

class _FakeAuthRepository extends mocktail.Fake implements AuthRepository {}

class _FakeLoginWithCredentialsUseCase extends mocktail.Fake
    implements LoginWithCredentialsUseCase {}
