import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/view_models/login_page_view_model.dart';

void main() {
  late QuizLabLogger logger;
  late FetchApplicationVersionUseCase fetchApplicationVersionUseCaseMock;
  late LoginWithCredentialsUseCase loginWithCredentionsUseCaseMock;
  late LoginAnonymouslyUseCase loginAnonymouslyUseCaseMock;

  late LoginPageCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    fetchApplicationVersionUseCaseMock = _MockFetchApplicationVersionUseCase();
    loginWithCredentionsUseCaseMock = _MockLoginWithCredentionsUseCase();
    loginAnonymouslyUseCaseMock = _MockLoginAnonymouslyUseCase();

    cubit = LoginPageCubit(
      logger: logger,
      loginWithCredentionsUseCase: loginWithCredentionsUseCaseMock,
      fetchApplicationVersionUseCase: fetchApplicationVersionUseCaseMock,
      loginAnonymouslyUseCase: loginAnonymouslyUseCaseMock,
    );
  });

  tearDown(resetMocktailState);

  group('hydrate', () {
    group(
      'should emit [LoginPageViewModelUpdated] with default view model',
      () {
        for (final applicationVersion in ['', '%%@%Z@', 'S&b0^F']) {
          test(applicationVersion, () {
            when(() => fetchApplicationVersionUseCaseMock.execute()).thenReturn(applicationVersion);

            cubit.hydrate();

            expect(
              cubit.state,
              LoginPageViewModelUpdated(
                viewModel: LoginPageViewModel(
                  email: const EmailViewModel(value: ''),
                  password: const PasswordViewModel(value: ''),
                  applicationVersion: 'v$applicationVersion',
                ),
              ),
            );
          });
        }
      },
    );
  });

  group('onEmailChange', () {
    group(
      'should emit [LoginPageViewModelUpdated] with given email value and '
      'should be showing errors',
      () {
        for (final email in [
          '',
          '6bpedZ*',
        ]) {
          test(email, () {
            const dummyApplicationVersion = 'T4qkCa#n';

            when(() => fetchApplicationVersionUseCaseMock.execute()).thenReturn(dummyApplicationVersion);

            cubit
              ..hydrate()
              ..updateEmail(email);

            expect(
              cubit.state,
              LoginPageViewModelUpdated(
                viewModel: LoginPageViewModel(
                  email: EmailViewModel(
                    value: email,
                    showError: true,
                  ),
                  password: const PasswordViewModel(
                    value: '',
                  ),
                  applicationVersion: 'v$dummyApplicationVersion',
                ),
              ),
            );
          });
        }
      },
    );
  });

  group('onPasswordChange', () {
    group(
      'should emit [LoginPageViewModelUpdated] with given password value and '
      'should be showing errors',
      () {
        for (final password in [
          '',
          'NE#o%',
        ]) {
          test(password, () {
            const dummyApplicationVersion = 'wQg01jsN';

            when(() => fetchApplicationVersionUseCaseMock.execute()).thenReturn(dummyApplicationVersion);

            cubit
              ..hydrate()
              ..updatePassword(password);

            expect(
              cubit.state,
              LoginPageViewModelUpdated(
                viewModel: LoginPageViewModel(
                  email: const EmailViewModel(
                    value: '',
                  ),
                  password: PasswordViewModel(
                    value: password,
                    showError: true,
                  ),
                  applicationVersion: 'v$dummyApplicationVersion',
                ),
              ),
            );
          });
        }
      },
    );
  });

  group('onLogin', () {
    group(
      'should emit [LoginPageViewModelUpdated] showing errors if email/password have issues',
      () {
        for (final values in [
          ['', ''],
        ]) {
          test(values.toString(), () {
            const dummyApplicationVersion = 'jF%';

            when(() => fetchApplicationVersionUseCaseMock.execute()).thenReturn(dummyApplicationVersion);

            final email = values[0];
            final password = values[1];

            cubit
              ..hydrate()
              ..updateEmail(email)
              ..updatePassword(password)
              ..login();

            expect(
              cubit.state,
              LoginPageViewModelUpdated(
                viewModel: LoginPageViewModel(
                  email: EmailViewModel(
                    value: email,
                    showError: true,
                  ),
                  password: PasswordViewModel(
                    value: password,
                    showError: true,
                  ),
                  applicationVersion: 'v$dummyApplicationVersion',
                ),
              ),
            );
          });
        }
      },
    );

    group(
      'err flow',
      () {
        test('should emit [LoginUnableToLogin]', () {
          const email = '0NSu';
          const password = 'eG#*2IGw';
          const dummyApplicationVersion = 'jF%';

          when(() => fetchApplicationVersionUseCaseMock.execute()).thenReturn(dummyApplicationVersion);

          when(
            () => loginWithCredentionsUseCaseMock.call(
              const LoginWithCredentialsUseCaseInput(
                email: email,
                password: password,
              ),
            ),
          ).thenAnswer((_) async => const Err('plM430*8'));

          expectLater(
            cubit.stream,
            emitsInOrder([
              isA<LoginPageViewModelUpdated>(),
              isA<LoginPageViewModelUpdated>(),
              isA<LoginPageViewModelUpdated>(),
              isA<LoginPageLoading>(),
              const LoginPageUnableToLogin(),
              isA<LoginPageViewModelUpdated>(),
            ]),
          );

          cubit
            ..hydrate()
            ..updateEmail(email)
            ..updatePassword(password)
            ..login();
        });
      },
    );

    group(
      'ok flow',
      () {
        test(
          'should emit '
          '[LoginPageDisplayLoggedInMessage, LoginPagePushRouteReplacing]',
          () async {
            const dummyEmail = 'k%qMlC';
            const dummyPassword = '5G4tC3';
            const dummyApplicationVersion = 'jF%';

            when(() => fetchApplicationVersionUseCaseMock.execute()).thenReturn(dummyApplicationVersion);

            when(
              () => loginWithCredentionsUseCaseMock.call(
                const LoginWithCredentialsUseCaseInput(
                  email: dummyEmail,
                  password: dummyPassword,
                ),
              ),
            ).thenAnswer(
              (_) async => const Ok(unit),
            );

            unawaited(
              expectLater(
                cubit.stream,
                emitsInOrder(
                  [
                    isA<LoginPageViewModelUpdated>(),
                    isA<LoginPageViewModelUpdated>(),
                    isA<LoginPageViewModelUpdated>(),
                    isA<LoginPageLoading>(),
                    isA<LoginPageLoggedInSuccessfully>(),
                    const LoginPagePushRouteReplacing(
                      route: Routes.questionsOverview,
                    ),
                    emitsDone,
                  ],
                ),
              ),
            );

            cubit
              ..hydrate()
              ..updateEmail(dummyEmail)
              ..updatePassword(dummyPassword);

            await cubit.login();
            await cubit.close();
          },
        );
      },
    );
  });

  test('onSignUp', () {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<LoginPageNotYetImplemented>(),
      ]),
    );

    cubit.signUp();
  });

  group('enterAnonymously', () {
    test('should emit [LoginPageLoading]', () {
      when(() => loginAnonymouslyUseCaseMock.call()).thenAnswer((_) async => const Err('DGI'));

      expectLater(cubit.stream, emits(const LoginPageLoading()));

      cubit.enterAnonymously();
    });

    group(
      'should emit [LoginPageUnableToLogin, LoginPageInitial] if login anonymously use case fails',
      () {
        for (final error in ['8dNTWA', '1FAaAW2']) {
          test(error, () async {
            when(loginAnonymouslyUseCaseMock.call).thenAnswer((_) async => Err(error));

            unawaited(
              expectLater(
                cubit.stream,
                emitsInOrder([
                  const LoginPageLoading(),
                  const LoginPageUnableToLogin(),
                  const LoginPageInitial(),
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

    test('should emit [LoginPageLoggedInSuccessfully, LoginPagePushRouteReplacing]', () async {
      when(loginAnonymouslyUseCaseMock.call).thenAnswer((_) async => const Ok(unit));

      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            const LoginPageLoading(),
            const LoginPageLoggedInSuccessfully(),
            const LoginPagePushRouteReplacing(route: Routes.questionsOverview),
            emitsDone,
          ]),
        ),
      );

      await cubit.enterAnonymously();
      await cubit.close();

      verify(() => logger.info('Logged in successfully. Redirecting...')).called(1);
    });
  });
}

class _MockLoginWithCredentionsUseCase extends Mock implements LoginWithCredentialsUseCase {}

class _MockFetchApplicationVersionUseCase extends Mock implements FetchApplicationVersionUseCase {}

class _MockLoginAnonymouslyUseCase extends Mock implements LoginAnonymouslyUseCase {}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}
