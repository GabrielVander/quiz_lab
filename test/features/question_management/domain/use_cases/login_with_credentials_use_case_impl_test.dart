import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';

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
    group(
      'should return expected error message if auth repository fails',
      () {
        for (final authError in [
          AuthRepositoryError.unexpected(message: ''),
          AuthRepositoryError.unexpected(message: '#SG'),
          _FakeAuthRepositoryError(),
        ]) {
          test(authError.toString(), () async {
            const dummyEmail = 'N3GKON@F';
            const dummyPassword = 's5o';

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
                  (_) async => Err(authError),
                );

            final result = await useCase(
              const LoginWithCredentialsUseCaseInput(
                email: dummyEmail,
                password: dummyPassword,
              ),
            );

            expect(result.isErr, true);
            expect(result.unwrapErr(), 'Login failed');
          });
        }
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
            .thenAnswer((_) async => const Ok(unit));

        final result = await useCase(
          const LoginWithCredentialsUseCaseInput(
            email: dummyEmail,
            password: dummyPassword,
          ),
        );

        expect(result.isOk, true);
        expect(result.unwrap(), unit);
      },
    );
  });
}

class _AuthRepositoryMock extends mocktail.Mock implements AuthRepository {}

class _FakeEmailCredentials extends mocktail.Fake implements EmailCredentials {}

class _FakeAuthRepositoryError extends mocktail.Fake implements AuthRepositoryError {}
