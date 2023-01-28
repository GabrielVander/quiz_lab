import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';

void authenticationDiSetup(DependencyInjection di) {
  di.registerFactory<LoginPageCubit>(
    (di) => LoginPageCubit(),
  );
}
