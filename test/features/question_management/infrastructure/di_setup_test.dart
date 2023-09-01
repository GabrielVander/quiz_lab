import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/appwrite_references_config.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/profile_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_can_create_public_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/question_management/infrastructure/di_setup.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/wrappers/appwrite_wrapper.dart';

void main() {
  late DependencyInjection dependencyInjection;

  setUp(() {
    dependencyInjection = _MockDependencyInjection();
  });

  test('AuthAppwriteDataSource', () {
    final mockAppwriteAccountService = _MockAccount();

    when(() => dependencyInjection.get<Account>()).thenReturn(mockAppwriteAccountService);

    questionManagementDiSetup(dependencyInjection);

    final captured = verify(() => dependencyInjection.registerBuilder<AuthAppwriteDataSource>(captureAny())).captured;

    final builder = captured.single as AuthAppwriteDataSource Function(DependencyInjection);
    final dataSource = builder(dependencyInjection);

    expect(dataSource, isA<AuthAppwriteDataSourceImpl>());
    final dataSourceImpl = dataSource as AuthAppwriteDataSourceImpl;

    expect(dataSourceImpl.logger, isA<QuizLabLoggerImpl<AuthAppwriteDataSourceImpl>>());
    expect(dataSourceImpl.appwriteAccountService, same(mockAppwriteAccountService));
  });

  group('QuestionCollectionAppwriteDataSource', () {
    for (final values in [('a5XM8DQ', 'Gsdt3Zo'), ('3C64', '8Y4dNY')]) {
      final databaseId = values.$1;
      final collectionId = values.$2;

      test('with databaseId: $databaseId', () {
        final databases = _MockDatabases();
        final realtime = _MockRealtime();
        final appwriteWrapper = _MockAppwriteWrapper();

        when(() => dependencyInjection.get<AppwriteReferencesConfig>()).thenReturn(
          AppwriteReferencesConfig(
            databaseId: databaseId,
            questionCollectionId: collectionId,
            profileCollectionId: 'S04',
          ),
        );
        when(() => dependencyInjection.get<Databases>()).thenReturn(databases);
        when(() => dependencyInjection.get<AppwriteWrapper>()).thenReturn(appwriteWrapper);
        when(() => dependencyInjection.get<Realtime>()).thenReturn(realtime);

        questionManagementDiSetup(dependencyInjection);

        final builder =
            verify(() => dependencyInjection.registerBuilder<QuestionCollectionAppwriteDataSource>(captureAny()))
                .captured
                .single;

        expect(builder, isA<QuestionCollectionAppwriteDataSourceImpl Function(DependencyInjection)>());
        final dataSourceBuilder = builder as QuestionCollectionAppwriteDataSourceImpl Function(DependencyInjection);

        final dataSource = dataSourceBuilder(dependencyInjection);

        expect(dataSource.logger, QuizLabLoggerImpl<QuestionCollectionAppwriteDataSourceImpl>());
        expect(dataSource.appwriteDatabaseId, databaseId);
        expect(dataSource.appwriteQuestionCollectionId, collectionId);
        expect(dataSource.databases, databases);
        expect(dataSource.realtime, realtime);
      });
    }
  });

  group('ProfileCollectionAppwriteDataSource', () {
    for (final values in [('a5XM8DQ', 'Gsdt3Zo'), ('3C64', '8Y4dNY')]) {
      final databaseId = values.$1;
      final collectionId = values.$2;

      test('with databaseId: $databaseId', () {
        final databases = _MockDatabases();

        when(() => dependencyInjection.get<AppwriteReferencesConfig>()).thenReturn(
          AppwriteReferencesConfig(
            databaseId: databaseId,
            profileCollectionId: collectionId,
            questionCollectionId: 'ZPth6',
          ),
        );
        when(() => dependencyInjection.get<Databases>()).thenReturn(databases);

        questionManagementDiSetup(dependencyInjection);

        final builder =
            verify(() => dependencyInjection.registerBuilder<ProfileCollectionAppwriteDataSource>(captureAny()))
                .captured
                .single;

        expect(builder, isA<ProfileCollectionAppwriteDataSourceImpl Function(DependencyInjection)>());
        final dataSourceBuilder = builder as ProfileCollectionAppwriteDataSourceImpl Function(DependencyInjection);

        final dataSource = dataSourceBuilder(dependencyInjection);

        expect(dataSource.logger, QuizLabLoggerImpl<ProfileCollectionAppwriteDataSourceImpl>());
        expect(dataSource.appwriteDatabaseId, databaseId);
        expect(dataSource.databases, databases);
      });
    }
  });

  test('QuestionRepository', () {
    final questionCollectionAppwriteDataSource = _MockQuestionCollectionAppwriteDataSource();
    final authAppwriteDataSource = _MockAuthAppwriteDataSource();
    final profileCollectionAppwriteDataSource = _MockProfileCollectionAppwriteDataSource();

    when(() => dependencyInjection.get<QuestionCollectionAppwriteDataSource>())
        .thenReturn(questionCollectionAppwriteDataSource);
    when(() => dependencyInjection.get<AuthAppwriteDataSource>()).thenReturn(authAppwriteDataSource);
    when(() => dependencyInjection.get<ProfileCollectionAppwriteDataSource>())
        .thenReturn(profileCollectionAppwriteDataSource);

    questionManagementDiSetup(dependencyInjection);

    final builder = verify(
      () => dependencyInjection.registerBuilder<QuestionRepository>(
        captureAny(that: isA<QuestionRepository Function(DependencyInjection)>()),
      ),
    ).captured.single;

    final repositoryBuilder = builder as QuestionRepository Function(DependencyInjection);

    final repository = repositoryBuilder(dependencyInjection);
    expect(repository, isA<QuestionRepositoryImpl>());
    final repositoryImpl = repository as QuestionRepositoryImpl;

    expect(repositoryImpl.logger, QuizLabLoggerImpl<QuestionRepositoryImpl>());
    expect(repositoryImpl.questionsAppwriteDataSource, questionCollectionAppwriteDataSource);
    expect(repositoryImpl.authAppwriteDataSource, authAppwriteDataSource);
    expect(repositoryImpl.profileAppwriteDataSource, profileCollectionAppwriteDataSource);
  });

  test('AuthRepository', () {
    final mockAuthAppwriteDataSource = _MockAuthAppwriteDataSource();

    when(() => dependencyInjection.get<AuthAppwriteDataSource>()).thenReturn(mockAuthAppwriteDataSource);

    questionManagementDiSetup(dependencyInjection);

    final captured = verify(() => dependencyInjection.registerBuilder<AuthRepository>(captureAny())).captured;

    final builder = captured.single as AuthRepository Function(DependencyInjection);
    final repository = builder(dependencyInjection);

    expect(repository, isA<AuthRepositoryImpl>());
    final repositoryImpl = repository as AuthRepositoryImpl;

    expect(repositoryImpl.logger, isA<QuizLabLoggerImpl<AuthRepositoryImpl>>());
    expect(repositoryImpl.authDataSource, same(mockAuthAppwriteDataSource));
  });

  test('CheckIfUserCanCreatePublicQuestionsUseCase', () {
    final authRepository = _MockAuthRepository();

    when(() => dependencyInjection.get<AuthRepository>()).thenReturn(authRepository);

    questionManagementDiSetup(dependencyInjection);

    final builder = verify(
      () => dependencyInjection.registerBuilder<CheckIfUserCanCreatePublicQuestionsUseCase>(
        captureAny(that: isA<CheckIfUserCanCreatePublicQuestionsUseCase Function(DependencyInjection)>()),
      ),
    ).captured.single;
    final useCaseBuilder = builder as CheckIfUserCanCreatePublicQuestionsUseCase Function(DependencyInjection);

    final useCase = useCaseBuilder(dependencyInjection);
    expect(useCase, isA<CheckIfUserCanCreatePublicQuestionsUseCaseImpl>());
    final useCaseImpl = useCase as CheckIfUserCanCreatePublicQuestionsUseCaseImpl;

    expect(useCaseImpl.logger, isA<QuizLabLoggerImpl<CheckIfUserCanCreatePublicQuestionsUseCaseImpl>>());
    expect(useCaseImpl.authRepository, authRepository);
  });

  test('LoginWithCredentialsUseCase', () {
    when(() => dependencyInjection.get<AuthRepository>()).thenReturn(_MockAuthRepository());

    questionManagementDiSetup(dependencyInjection);

    final captured =
        verify(() => dependencyInjection.registerBuilder<LoginWithCredentialsUseCase>(captureAny())).captured;

    final builder = captured.single as LoginWithCredentialsUseCase Function(DependencyInjection);
    final useCase = builder(dependencyInjection);

    expect(useCase, isA<LoginWithCredentialsUseCaseImpl>());
  });

  test('LoginAnonymouslyUseCase', () {
    final mockAuthRepository = _MockAuthRepository();

    when(() => dependencyInjection.get<AuthRepository>()).thenReturn(mockAuthRepository);

    questionManagementDiSetup(dependencyInjection);

    final builderCaptor =
        verify(() => dependencyInjection.registerBuilder<LoginAnonymouslyUseCase>(captureAny())).captured;

    final builder = builderCaptor.single as LoginAnonymouslyUseCase Function(DependencyInjection);
    final useCase = builder(dependencyInjection);

    expect(useCase, isA<LoginAnonymouslyUseCaseImpl>());

    final useCaseImpl = useCase as LoginAnonymouslyUseCaseImpl;

    expect(useCaseImpl.authRepository, same(mockAuthRepository));
    expect(useCaseImpl.logger, isA<QuizLabLoggerImpl<LoginAnonymouslyUseCaseImpl>>());
  });

  test('CheckIfUserIsLoggedInUseCase', () {
    final mockAuthRepository = _MockAuthRepository();

    when(() => dependencyInjection.get<AuthRepository>()).thenReturn(mockAuthRepository);

    questionManagementDiSetup(dependencyInjection);

    final builderCaptor =
        verify(() => dependencyInjection.registerBuilder<CheckIfUserIsLoggedInUseCase>(captureAny())).captured;

    final builder = builderCaptor.single as CheckIfUserIsLoggedInUseCase Function(DependencyInjection);
    final useCase = builder(dependencyInjection);

    expect(useCase, isA<CheckIfUserIsLoggedInUseCaseImpl>());

    final useCaseImpl = useCase as CheckIfUserIsLoggedInUseCaseImpl;

    expect(useCaseImpl.authRepository, same(mockAuthRepository));
    expect(useCaseImpl.logger, isA<QuizLabLoggerImpl<CheckIfUserIsLoggedInUseCaseImpl>>());
  });

  test('QuestionCreationCubit', () {
    final createQuestionUseCase = _MockCreateQuestionUseCase();
    final checkIfUserCanCreatePublicQuestionsUseCase = _MockCheckIfUserCanCreatePublicQuestionsUseCase();

    when(() => dependencyInjection.get<CheckIfUserCanCreatePublicQuestionsUseCase>())
        .thenReturn(checkIfUserCanCreatePublicQuestionsUseCase);
    when(() => dependencyInjection.get<CreateQuestionUseCase>()).thenReturn(createQuestionUseCase);

    questionManagementDiSetup(dependencyInjection);

    final builder = verify(
      () => dependencyInjection.registerBuilder<QuestionCreationCubit>(
        captureAny(that: isA<QuestionCreationCubit Function(DependencyInjection)>()),
      ),
    ).captured.single;
    final cubitBuilder = builder as QuestionCreationCubit Function(DependencyInjection);

    final cubit = cubitBuilder(dependencyInjection);
    expect(cubit.logger, isA<QuizLabLoggerImpl<QuestionCreationCubit>>());
    expect(cubit.createQuestionUseCase, createQuestionUseCase);
    expect(cubit.checkIfUserCanCreatePublicQuestionsUseCase, checkIfUserCanCreatePublicQuestionsUseCase);
  });

  test('LoginPageCubit', () {
    final mockLoginWithCredentialsUseCase = _MockLoginWithCredentialsUseCase();
    final mockFetchApplicationVersionUseCase = _MockFetchApplicationVersionUseCase();
    final mockLoginAnonymouslyUseCase = _MockLoginAnonymouslyUseCase();

    when(() => dependencyInjection.get<LoginWithCredentialsUseCase>()).thenReturn(mockLoginWithCredentialsUseCase);
    when(() => dependencyInjection.get<FetchApplicationVersionUseCase>())
        .thenReturn(mockFetchApplicationVersionUseCase);
    when(() => dependencyInjection.get<LoginAnonymouslyUseCase>()).thenReturn(mockLoginAnonymouslyUseCase);

    questionManagementDiSetup(dependencyInjection);

    final captured = verify(() => dependencyInjection.registerBuilder<LoginPageCubit>(captureAny())).captured;

    final builder = captured.single as LoginPageCubit Function(DependencyInjection);
    final cubit = builder(dependencyInjection);

    expect(cubit.logger, isA<QuizLabLoggerImpl<LoginPageCubit>>());
    expect(cubit.fetchApplicationVersionUseCase, mockFetchApplicationVersionUseCase);
    expect(cubit.loginWithCredentionsUseCase, mockLoginWithCredentialsUseCase);
    expect(cubit.loginAnonymouslyUseCase, mockLoginAnonymouslyUseCase);
  });
}

class _MockDependencyInjection extends Mock implements DependencyInjection {}

class _MockAppwriteWrapper extends Mock implements AppwriteWrapper {}

class _MockDatabases extends Mock implements Databases {}

class _MockQuestionCollectionAppwriteDataSource extends Mock implements QuestionCollectionAppwriteDataSource {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockCreateQuestionUseCase extends Mock implements CreateQuestionUseCase {}

class _MockCheckIfUserCanCreatePublicQuestionsUseCase extends Mock
    implements CheckIfUserCanCreatePublicQuestionsUseCase {}

class _MockLoginWithCredentialsUseCase extends Mock implements LoginWithCredentialsUseCase {}

class _MockFetchApplicationVersionUseCase extends Mock implements FetchApplicationVersionUseCase {}

class _MockLoginAnonymouslyUseCase extends Mock implements LoginAnonymouslyUseCase {}

class _MockAccount extends Mock implements Account {}

class _MockRealtime extends Mock implements Realtime {}

class _MockAuthAppwriteDataSource extends Mock implements AuthAppwriteDataSource {}

class _MockProfileCollectionAppwriteDataSource extends Mock implements ProfileCollectionAppwriteDataSource {}
