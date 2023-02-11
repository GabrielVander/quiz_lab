import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
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
      'should return expected error message if auth repository fails',
      ParameterizedSource.values([
        [AuthRepositoryError.unexpected(message: ''), 'Unable to login: '],
        [
          AuthRepositoryError.unexpected(message: '#SG'),
          'Unable to login: #SG',
        ],
        [
          _FakeAuthRepositoryError(),
          'Unable to login: Unknown error\nInstance of '
              "'_FakeAuthRepositoryError'",
        ]
      ]),
      (values) async {
        const dummyEmail = 'N3GKON@F';
        const dummyPassword = 's5o';

        final authError = values[0] as AuthRepositoryError;
        final expectedErrorMessage = values[1] as String;

        mocktail
            .when(
              () => authRepository.loginWithEmailCredentials(
                const EmailCredentials(
                  email: dummyEmail,
                  password: dummyPassword,
                ),
              ),
            )
            .thenAnswer(
              (_) async => Result.err(authError),
            );

        final result = await useCase(
          const LoginWithCredentialsUseCaseInput(
            email: dummyEmail,
            password: dummyPassword,
          ),
        );

        expect(result.isErr, true);
        expect(result.err, expectedErrorMessage);
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
              () => authRepository.loginWithEmailCredentials(
                const EmailCredentials(
                  email: dummyEmail,
                  password: dummyPassword,
                ),
              ),
            )
            .thenAnswer((_) async => const Result.ok(unit));

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

class _FakeAuthRepositoryError extends mocktail.Fake
    implements AuthRepositoryError {}
