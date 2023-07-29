import 'package:appwrite/appwrite.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/features/auth/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';

void authenticationDiSetup(DependencyInjection di) {
  di
    ..registerBuilder<AuthAppwriteDataSource>(
      (DependencyInjection di) => AuthAppwriteDataSourceImpl(
        logger: QuizLabLoggerImpl<AuthAppwriteDataSourceImpl>(),
        appwriteAccountService: di.get<Account>(),
      ),
    )
    ..registerBuilder<AuthRepository>(
      (DependencyInjection di) => AuthRepositoryImpl(
        logger: QuizLabLoggerImpl<AuthRepositoryImpl>(),
        authDataSource: di.get<AuthAppwriteDataSource>(),
      ),
    )
    ..registerBuilder<LoginWithCredentialsUseCase>(
      (di) => LoginWithCredentialsUseCaseImpl(
        authRepository: di.get<AuthRepository>(),
      ),
    )
    ..registerBuilder<LoginAnonymouslyUseCase>(
      (di) => LoginAnonymouslyUseCaseImpl(
        logger: QuizLabLoggerImpl<LoginAnonymouslyUseCaseImpl>(),
        authRepository: di.get<AuthRepository>(),
      ),
    )
    ..registerBuilder<CheckIfUserIsLoggedInUseCase>(
      (di) => CheckIfUserIsLoggedInUseCaseImpl(
        logger: QuizLabLoggerImpl<CheckIfUserIsLoggedInUseCaseImpl>(),
        authRepository: di.get<AuthRepository>(),
      ),
    )
    ..registerBuilder<LoginPageCubit>(
      (di) => LoginPageCubit(
        logger: QuizLabLoggerImpl<LoginPageCubit>(),
        loginWithCredentionsUseCase: di.get<LoginWithCredentialsUseCase>(),
        loginAnonymouslyUseCase: di.get<LoginAnonymouslyUseCase>(),
        fetchApplicationVersionUseCase:
            di.get<FetchApplicationVersionUseCase>(),
      ),
    );
}
