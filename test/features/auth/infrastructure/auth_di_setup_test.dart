import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';

void main() {
  late DependencyInjection diMock;

  setUp(() {
    diMock = _DependencyInjectionMock();
  });

  group('should register correctly', () {
    test('AuthAppwriteDataSource', () {
      final mockAppwriteAccountService = _MockAccount();

      when(() => diMock.get<Account>()).thenReturn(mockAppwriteAccountService);

      authenticationDiSetup(diMock);

      final captured = verify(
        () => diMock.registerBuilder<AuthAppwriteDataSource>(captureAny()),
      ).captured;

      final builder = captured.single as AuthAppwriteDataSource Function(
        DependencyInjection,
      );
      final dataSource = builder(diMock);

      expect(dataSource, isA<AuthAppwriteDataSourceImpl>());
      final dataSourceImpl = dataSource as AuthAppwriteDataSourceImpl;

      expect(
        dataSourceImpl.logger,
        isA<QuizLabLoggerImpl<AuthAppwriteDataSourceImpl>>(),
      );
      expect(
        dataSourceImpl.appwriteAccountService,
        same(mockAppwriteAccountService),
      );
    });

    test('AuthRepository', () {
      final mockAuthAppwriteDataSource = _MockAuthAppwriteDataSource();

      when(() => diMock.get<AuthAppwriteDataSource>())
          .thenReturn(mockAuthAppwriteDataSource);

      authenticationDiSetup(diMock);

      final captured =
          verify(() => diMock.registerBuilder<AuthRepository>(captureAny()))
              .captured;

      final builder =
          captured.single as AuthRepository Function(DependencyInjection);
      final repository = builder(diMock);

      expect(repository, isA<AuthRepositoryImpl>());
      final repositoryImpl = repository as AuthRepositoryImpl;

      expect(
        repositoryImpl.logger,
        isA<QuizLabLoggerImpl<AuthRepositoryImpl>>(),
      );
      expect(repositoryImpl.authDataSource, same(mockAuthAppwriteDataSource));
    });

    test('LoginWithCredentialsUseCase', () {
      when(() => diMock.get<AuthRepository>())
          .thenReturn(_MockAuthRepository());

      authenticationDiSetup(diMock);

      final captured = verify(
        () => diMock.registerBuilder<LoginWithCredentialsUseCase>(
          captureAny(),
        ),
      ).captured;

      final builder = captured.single as LoginWithCredentialsUseCase Function(
        DependencyInjection,
      );
      final useCase = builder(diMock);

      expect(useCase, isA<LoginWithCredentialsUseCaseImpl>());
    });

    test('LoginAnonymouslyUseCase', () {
      final mockAuthRepository = _MockAuthRepository();

      when(() => diMock.get<AuthRepository>()).thenReturn(mockAuthRepository);

      authenticationDiSetup(diMock);

      final builderCaptor = verify(
        () => diMock.registerBuilder<LoginAnonymouslyUseCase>(captureAny()),
      ).captured;

      final builder = builderCaptor.single as LoginAnonymouslyUseCase Function(
        DependencyInjection,
      );
      final useCase = builder(diMock);

      expect(useCase, isA<LoginAnonymouslyUseCaseImpl>());

      final useCaseImpl = useCase as LoginAnonymouslyUseCaseImpl;

      expect(useCaseImpl.authRepository, same(mockAuthRepository));
      expect(
        useCaseImpl.logger,
        isA<QuizLabLoggerImpl<LoginAnonymouslyUseCaseImpl>>(),
      );
    });

    test('LoginPageCubit', () {
      final mockLoginWithCredentialsUseCase =
          _MockLoginWithCredentialsUseCase();
      final mockFetchApplicationVersionUseCase =
          _MockFetchApplicationVersionUseCase();
      final mockLoginAnonymouslyUseCase = _MockLoginAnonymouslyUseCase();

      when(() => diMock.get<LoginWithCredentialsUseCase>())
          .thenReturn(mockLoginWithCredentialsUseCase);
      when(() => diMock.get<FetchApplicationVersionUseCase>())
          .thenReturn(mockFetchApplicationVersionUseCase);
      when(() => diMock.get<LoginAnonymouslyUseCase>())
          .thenReturn(mockLoginAnonymouslyUseCase);

      authenticationDiSetup(diMock);

      final captured =
          verify(() => diMock.registerBuilder<LoginPageCubit>(captureAny()))
              .captured;

      final builder =
          captured.single as LoginPageCubit Function(DependencyInjection);
      final cubit = builder(diMock);

      expect(cubit.logger, isA<QuizLabLoggerImpl<LoginPageCubit>>());
      expect(
        cubit.fetchApplicationVersionUseCase,
        mockFetchApplicationVersionUseCase,
      );
      expect(
        cubit.loginWithCredentionsUseCase,
        mockLoginWithCredentialsUseCase,
      );
      expect(
        cubit.loginAnonymouslyUseCase,
        mockLoginAnonymouslyUseCase,
      );
    });
  });
}

class _DependencyInjectionMock extends Mock implements DependencyInjection {}

class _MockAuthAppwriteDataSource extends Mock
    implements AuthAppwriteDataSource {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockLoginWithCredentialsUseCase extends Mock
    implements LoginWithCredentialsUseCase {}

class _MockFetchApplicationVersionUseCase extends Mock
    implements FetchApplicationVersionUseCase {}

class _MockLoginAnonymouslyUseCase extends Mock
    implements LoginAnonymouslyUseCase {}

class _MockAccount extends Mock implements Account {}
