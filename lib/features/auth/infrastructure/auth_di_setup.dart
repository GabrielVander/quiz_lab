import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/impl/login_with_credentials_use_case_impl.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';

void authenticationDiSetup(DependencyInjection di) {
  di
    ..registerFactory<AuthRepository>(
      (DependencyInjection di) => AuthRepositoryImpl(authDataSource: di.get()),
    )
    ..registerFactory<LoginWithCredentialsUseCase>(
      (di) => LoginWithCredentialsUseCaseImpl(
        authRepository: di.get<AuthRepository>(),
      ),
    )
    ..registerFactory<LoginPageCubit>(
      (di) => LoginPageCubit(
        loginWithCredentionsUseCase: di.get<LoginWithCredentialsUseCase>(),
      ),
    );
}
