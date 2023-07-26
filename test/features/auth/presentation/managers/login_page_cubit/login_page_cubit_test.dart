import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';

void main() {
  late FetchApplicationVersionUseCase fetchApplicationVersionUseCaseMock;
  late LoginWithCredentialsUseCase loginWithCredentionsUseCaseMock;
  late LoginPageCubit cubit;

  setUp(() {
    fetchApplicationVersionUseCaseMock = _FetchApplicationVersionUseCaseMock();
    loginWithCredentionsUseCaseMock = _LoginWithCredentionsUseCaseMock();
    cubit = LoginPageCubit(
      loginWithCredentionsUseCase: loginWithCredentionsUseCaseMock,
      fetchApplicationVersionUseCase: fetchApplicationVersionUseCaseMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('hydrate', () {
    group(
      'should emit [LoginPageViewModelUpdated] with default view model',
      () {
        for (final applicationVersion in ['', '%%@%Z@', 'S&b0^F']) {
          test(applicationVersion, () {
            mocktail
                .when(() => fetchApplicationVersionUseCaseMock.execute())
                .thenReturn(applicationVersion);

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

            mocktail
                .when(() => fetchApplicationVersionUseCaseMock.execute())
                .thenReturn(dummyApplicationVersion);

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

            mocktail
                .when(() => fetchApplicationVersionUseCaseMock.execute())
                .thenReturn(dummyApplicationVersion);

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

            mocktail
                .when(() => fetchApplicationVersionUseCaseMock.execute())
                .thenReturn(dummyApplicationVersion);

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
        test(
          'should emit [LoginPageDisplayErrorMessage] with unable to login '
          'type',
          () {
            const email = '0NSu';
            const password = 'eG#*2IGw';
            const dummyApplicationVersion = 'jF%';

            mocktail
                .when(() => fetchApplicationVersionUseCaseMock.execute())
                .thenReturn(dummyApplicationVersion);

            mocktail
                .when(
                  () => loginWithCredentionsUseCaseMock.call(
                    const LoginWithCredentialsUseCaseInput(
                      email: email,
                      password: password,
                    ),
                  ),
                )
                .thenAnswer((_) async => const Err('plM430*8'));

            expectLater(
              cubit.stream,
              emitsInOrder([
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageLoading>(),
                isA<LoginPageViewModelUpdated>(),
                const LoginPageError(
                  LoginPageErrorTypeViewModel.unableToLogin,
                ),
              ]),
            );

            cubit
              ..hydrate()
              ..updateEmail(email)
              ..updatePassword(password)
              ..login();
          },
        );
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

            mocktail
                .when(() => fetchApplicationVersionUseCaseMock.execute())
                .thenReturn(dummyApplicationVersion);

            mocktail
                .when(
                  () => loginWithCredentionsUseCaseMock.call(
                    const LoginWithCredentialsUseCaseInput(
                      email: dummyEmail,
                      password: dummyPassword,
                    ),
                  ),
                )
                .thenAnswer(
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
                  ],
                ),
              ),
            );

            cubit
              ..hydrate()
              ..updateEmail(dummyEmail)
              ..updatePassword(dummyPassword);

            await cubit.login();
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

  group('onEnterAnonymously', () {
    test('not implemented', () {
      expect(() => cubit.loginAnonymously(), throwsUnimplementedError);
    });
  });
}

class _LoginWithCredentionsUseCaseMock extends mocktail.Mock
    implements LoginWithCredentialsUseCase {}

class _FetchApplicationVersionUseCaseMock extends mocktail.Mock
    implements FetchApplicationVersionUseCase {}
