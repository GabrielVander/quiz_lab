import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/entities/email_credentials.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/impl/login_with_credentials_use_case_impl.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';

void main() {
  late AuthRepository authRepository;

  late LoginWithCredentialsUseCaseImpl useCase;

  setUp(
    () => {
      authRepository = _AuthRepositoryMock(),
      useCase = LoginWithCredentialsUseCaseImpl(authRepository: authRepository),
      mocktail.registerFallbackValue(
        _FakeEmailCredentials(),
      ),
    },
  );

  group('err flow', () {
    parameterizedTest(
      'should return auth repository error message if it fails',
      ParameterizedSource.value([
        '',
        '#SG',
      ]),
      (values) async {
        const dummyEmail = 'N3GKON@F';
        const dummyPassword = 's5o';

        final errorMessage = values[0] as String;

        mocktail
            .when(
              () => authRepository.loginWithCredentions(
                mocktail.any(
                  that: isA<EmailCredentials>()
                      .having((e) => e.email, 'email', dummyEmail)
                      .having((e) => e.password, 'password', dummyPassword),
                ),
              ),
            )
            .thenAnswer((_) async => Result<Unit, String>.err(errorMessage));

        final result = await useCase(
          const LoginWithCredentialsUseCaseInput(
            email: dummyEmail,
            password: dummyPassword,
          ),
        );

        expect(result.isErr, true);
        expect(result.err, errorMessage);
      },
    );
  });

  group('ok flow', () {
    test(
      'should return nothing if auth repository succeeds',
      () async {
        const dummyEmail = 'dz536IRG';
        const dummyPassword = 'ErSV';

        mocktail
            .when(
              () => authRepository.loginWithCredentions(
                mocktail.any(
                  that: isA<EmailCredentials>()
                      .having((e) => e.email, 'email', dummyEmail)
                      .having((e) => e.password, 'password', dummyPassword),
                ),
              ),
            )
            .thenAnswer((_) async => const Result<Unit, String>.ok(unit));

        final result = await useCase(
          const LoginWithCredentialsUseCaseInput(
            email: dummyEmail,
            password: dummyPassword,
          ),
        );

        expect(result.isOk, true);
        expect(result.ok, unit);
      },
    );
  });
}

class _AuthRepositoryMock extends mocktail.Mock implements AuthRepository {}

class _FakeEmailCredentials extends mocktail.Fake implements EmailCredentials {}
