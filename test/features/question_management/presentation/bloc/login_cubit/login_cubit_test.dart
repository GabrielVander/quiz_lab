import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:rust_core/result.dart';

void main() {
  late QuizLabLogger logger;
  late LoginWithCredentialsUseCase loginWithCredentialsUseCase;
  late LoginAnonymouslyUseCase loginAnonymouslyUseCase;

  late LoginCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    loginWithCredentialsUseCase = _MockLoginWithCredentialsUseCase();
    loginAnonymouslyUseCase = _MockLoginAnonymouslyUseCase();

    cubit = LoginCubit(
      logger: logger,
      loginWithCredentialsUseCase: loginWithCredentialsUseCase,
      loginAnonymouslyUseCase: loginAnonymouslyUseCase,
    );
  });

  tearDown(resetMocktailState);

  test('should emit initial state', () async {
    expect(cubit.state, const LoginState());

    await cubit.close();
  });

  group('onEmailChange', () {
    group('should emit state with given email value', () {
      for (final email in ['8Ox', '6bpedZ*']) {
        test(email, () async {
          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder([
                emitsThrough(
                  LoginState(email: email),
                ),
                emitsDone,
              ]),
            ),
          );

          cubit.updateEmail(email);
          await cubit.close();
        });
      }
    });

    test('should emit state with show errors true if email is empty', () async {
      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            emitsThrough(
              const LoginState(
                emailErrorCode: 'emptyValue',
                showEmailError: true,
              ),
            ),
            emitsDone,
          ]),
        ),
      );

      cubit.updateEmail('');
      await cubit.close();
    });
  });

  group('onPasswordChange', () {
    group('should emit state with given password value', () {
      for (final password in ['W6q', 'NE#o%']) {
        test(password, () async {
          unawaited(
            expectLater(
              cubit.stream,
              emitsThrough(
                LoginState(password: password),
              ),
            ),
          );

          cubit.updatePassword(password);

          await cubit.close();
        });
      }
    });

    test('should emit state with emptyValue error code', () async {
      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            emitsThrough(
              const LoginState(
                passwordErrorCode: 'emptyValue',
                showPasswordError: true,
              ),
            ),
            emitsDone,
          ]),
        ),
      );

      cubit.updatePassword('');
      await cubit.close();
    });
  });

  group('onLogin', () {
    test('should emit loading true', () async {
      when(
        () => loginWithCredentialsUseCase.call(
          const LoginWithCredentialsUseCaseInput(email: '', password: ''),
        ),
      ).thenAnswer((_) async => const Err('oXy2d8^%'));

      unawaited(
        expectLater(
          cubit.stream,
          emitsThrough(const LoginState(loading: true)),
        ),
      );

      await cubit.login();
      await cubit.close();
    });

    group('should emit state showing errors if email/password have issues', () {
      const email = '';
      const password = '';

      test('with $email as email and $password as password', () async {
        when(
          () => loginWithCredentialsUseCase
              .call(const LoginWithCredentialsUseCaseInput(email: email, password: password)),
        ).thenAnswer((_) async => const Err('fiii8S'));

        unawaited(
          expectLater(
            cubit.stream,
            emitsInOrder([
              emitsThrough(
                const LoginState(
                  emailErrorCode: 'emptyValue',
                  showEmailError: true,
                  passwordErrorCode: 'emptyValue',
                  showPasswordError: true,
                ),
              ),
            ]),
          ),
        );

        cubit
          ..updateEmail(email)
          ..updatePassword(password);

        await cubit.login();
        await cubit.close();
      });
    });

    group(
      'err flow',
      () {
        test('should emit state with unableToLoginErrorCode', () async {
          const email = '0NSu';
          const password = 'eG#*2IGw';

          when(
            () => loginWithCredentialsUseCase.call(
              const LoginWithCredentialsUseCaseInput(
                email: email,
                password: password,
              ),
            ),
          ).thenAnswer((_) async => const Err('plM430*8'));

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder([
                emitsThrough(
                  const LoginState(
                    email: email,
                    password: password,
                    generalErrorCode: 'unableToLogin',
                  ),
                ),
                // emitsDone,
              ]),
            ),
          );

          cubit
            ..updateEmail(email)
            ..updatePassword(password);

          await cubit.login();
          await cubit.close();
        });
      },
    );

    group('ok flow', () {
      test('should emit success', () async {
        const dummyEmail = 'k%qMlC';
        const dummyPassword = '5G4tC3';

        when(
          () => loginWithCredentialsUseCase.call(
            const LoginWithCredentialsUseCaseInput(
              email: dummyEmail,
              password: dummyPassword,
            ),
          ),
        ).thenAnswer((_) async => const Ok(unit));

        unawaited(
          expectLater(
            cubit.stream,
            emitsInOrder(
              [
                emitsThrough(
                  const LoginState(
                    email: dummyEmail,
                    password: dummyPassword,
                    success: true,
                  ),
                ),
                emitsDone,
              ],
            ),
          ),
        );

        cubit
          ..updateEmail(dummyEmail)
          ..updatePassword(dummyPassword);

        await cubit.login();
        await cubit.close();
      });
    });
  });

  test('onSignUp should emit state with not implemented message', () async {
    unawaited(
      expectLater(
        cubit.stream,
        emitsInOrder([
          const LoginState(generalMessageCode: 'notImplemented'),
          emitsDone,
        ]),
      ),
    );

    cubit.signUp();
    await cubit.close();
  });

  group('enterAnonymously', () {
    test('should emit state with loading = true', () async {
      when(() => loginAnonymouslyUseCase.call()).thenAnswer((_) async => const Err('DGI'));

      unawaited(
        expectLater(cubit.stream, emits(const LoginState(loading: true))),
      );

      await cubit.enterAnonymously();
      await cubit.close();
    });

    group(
      'should emit error code unableToLogin if login anonymously use case fails',
      () {
        for (final error in ['8dNTWA', '1FAaAW2']) {
          test(error, () async {
            when(loginAnonymouslyUseCase.call).thenAnswer((_) async => Err(error));

            unawaited(
              expectLater(
                cubit.stream,
                emitsInOrder([
                  emitsThrough(
                    const LoginState(
                      generalErrorCode: 'unableToLogin',
                    ),
                  ),
                  emitsDone,
                ]),
              ),
            );

            await cubit.enterAnonymously();
            await cubit.close();

            verify(() => logger.error(error)).called(1);
          });
        }
      },
    );

    test('should emit state with successful true', () async {
      when(loginAnonymouslyUseCase.call).thenAnswer((_) async => const Ok(unit));

      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            emitsThrough(
              const LoginState(
                email: 'email',
                password: 'password',
                success: true,
              ),
            ),
            emitsDone,
          ]),
        ),
      );

      cubit
        ..updateEmail('email')
        ..updatePassword('password');

      await cubit.enterAnonymously();
      await cubit.close();
    });
  });
}

class _MockLoginWithCredentialsUseCase extends Mock implements LoginWithCredentialsUseCase {}

class _MockLoginAnonymouslyUseCase extends Mock implements LoginAnonymouslyUseCase {}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}
