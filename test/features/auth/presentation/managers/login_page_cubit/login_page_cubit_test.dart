import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';

void main() {
  late PackageInfoWrapper packageInfoWrapperMock;
  late LoginWithCredentialsUseCase loginWithCredentionsUseCaseMock;
  late LoginPageCubit cubit;

  setUp(() {
    packageInfoWrapperMock = _PackageInfoWrapperMock();
    loginWithCredentionsUseCaseMock = _LoginWithCredentionsUseCaseMock();
    cubit = LoginPageCubit(
      loginWithCredentionsUseCase: loginWithCredentionsUseCaseMock,
      packageInfoWrapper: packageInfoWrapperMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('hydrate', () {
    group(
      'should emit [LoginPageViewModelUpdated] with default view model',
      () {
        for (final applicationVersion in [
          '',
        ]) {
          test(applicationVersion, () {
            mocktail
                .when(() => packageInfoWrapperMock.applicationVersion)
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
                .when(() => packageInfoWrapperMock.applicationVersion)
                .thenReturn(dummyApplicationVersion);

            cubit
              ..hydrate()
              ..onEmailChange(email);

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
                .when(() => packageInfoWrapperMock.applicationVersion)
                .thenReturn(dummyApplicationVersion);

            cubit
              ..hydrate()
              ..onPasswordChange(password);

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
                .when(() => packageInfoWrapperMock.applicationVersion)
                .thenReturn(dummyApplicationVersion);

            final email = values[0];
            final password = values[1];

            cubit
              ..hydrate()
              ..onEmailChange(email)
              ..onPasswordChange(password)
              ..onLogin();

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
                .when(() => packageInfoWrapperMock.applicationVersion)
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
                .thenAnswer((_) async => const Result.err('plM430*8'));

            expectLater(
              cubit.stream,
              emitsInOrder([
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageLoading>(),
                isA<LoginPageViewModelUpdated>(),
                const LoginPageDisplayErrorMessage(
                  LoginPageErrorTypeViewModel.unableToLogin,
                ),
              ]),
            );

            cubit
              ..hydrate()
              ..onEmailChange(email)
              ..onPasswordChange(password)
              ..onLogin();
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
                .when(() => packageInfoWrapperMock.applicationVersion)
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
                  (_) async => const Result.ok(unit),
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
                    isA<LoginPageDisplayLoggedInMessage>(),
                    const LoginPagePushRouteReplacing(
                      route: Routes.questionsOverview,
                    ),
                  ],
                ),
              ),
            );

            cubit
              ..hydrate()
              ..onEmailChange(dummyEmail)
              ..onPasswordChange(dummyPassword);

            await cubit.onLogin();
          },
        );
      },
    );
  });

  test('onSignUp', () {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<LoginPageDisplayNotYetImplementedMessage>(),
      ]),
    );

    cubit.onSignUp();
  });

  group('onEnterAnonymously', () {
    test('not implemented', () {
      expect(() => cubit.onEnterAnonymously(), throwsUnimplementedError);
    });
  });
}

class _LoginWithCredentionsUseCaseMock extends mocktail.Mock
    implements LoginWithCredentialsUseCase {}

class _PackageInfoWrapperMock extends mocktail.Mock
    implements PackageInfoWrapper {}
