import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/features/auth/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/impl/login_with_credentials_use_case_impl.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/infrastructure/auth_di_setup.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';

void main() {
  late DependencyInjection diMock;

  setUp(() {
    diMock = _DependencyInjectionMock();
  });

  group('should register', () {
    test('AuthRepository', () {
      mocktail
          .when(() => diMock.get<AuthAppwriteDataSource>())
          .thenReturn(_MockAuthAppwriteDataSource());

      authenticationDiSetup(diMock);

      final captured = mocktail
          .verify(() => diMock.registerBuilder<AuthRepository>(mocktail.captureAny()))
          .captured;

      final builder = captured.single as AuthRepository Function(DependencyInjection);
      final authRepository = builder(diMock);

      expect(authRepository, isA<AuthRepositoryImpl>());
    });

    test('LoginWithCredentialsUseCase', () {
      mocktail.when(() => diMock.get<AuthRepository>()).thenReturn(_MockAuthRepository());

      authenticationDiSetup(diMock);

      final captured = mocktail
          .verify(() => diMock.registerBuilder<LoginWithCredentialsUseCase>(mocktail.captureAny()))
          .captured;

      final builder = captured.single as LoginWithCredentialsUseCase Function(DependencyInjection);
      final useCase = builder(diMock);

      expect(useCase, isA<LoginWithCredentialsUseCaseImpl>());
    });

    test('LoginAnonymouslyUseCase', () {
      final mockAuthRepository = _MockAuthRepository();

      mocktail.when(() => diMock.get<AuthRepository>()).thenReturn(mockAuthRepository);

      authenticationDiSetup(diMock);

      final builderCaptor = mocktail
          .verify(() => diMock.registerBuilder<LoginAnonymouslyUseCase>(mocktail.captureAny()))
          .captured;

      final builder = builderCaptor.single as LoginAnonymouslyUseCase Function(DependencyInjection);
      final useCase = builder(diMock);

      expect(useCase, isA<LoginAnonymouslyUseCaseImpl>());

      final useCaseImpl = useCase as LoginAnonymouslyUseCaseImpl;

      expect(useCaseImpl.authRepository, same(mockAuthRepository));
      expect(useCaseImpl.logger, isA<QuizLabLoggerImpl<LoginAnonymouslyUseCaseImpl>>());
    });

    test('LoginPageCubit', () {
      mocktail
          .when(() => diMock.get<LoginWithCredentialsUseCase>())
          .thenReturn(_FakeLoginWithCredentialsUseCase());

      mocktail
          .when(() => diMock.get<FetchApplicationVersionUseCase>())
          .thenReturn(_FetchApplicationVersionUseCaseMock());

      authenticationDiSetup(diMock);

      final captured = mocktail
          .verify(() => diMock.registerBuilder<LoginPageCubit>(mocktail.captureAny()))
          .captured;

      final builder = captured.single as LoginPageCubit Function(DependencyInjection);
      final cubit = builder(diMock);

      expect(cubit, isA<LoginPageCubit>());
    });
  });
}

class _DependencyInjectionMock extends Mock implements DependencyInjection {}

class _MockAuthAppwriteDataSource extends Mock implements AuthAppwriteDataSource {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _FakeLoginWithCredentialsUseCase extends mocktail.Fake
    implements LoginWithCredentialsUseCase {}

class _FetchApplicationVersionUseCaseMock extends mocktail.Fake
    implements FetchApplicationVersionUseCase {}
