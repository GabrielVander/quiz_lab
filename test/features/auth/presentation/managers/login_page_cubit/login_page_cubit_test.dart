import 'dart:async';

import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';

void main() {
  late LoginWithCredentialsUseCase loginWithCredentionsUseCaseMock;
  late LoginPageCubit cubit;

  setUp(() {
    loginWithCredentionsUseCaseMock = _LoginWithCredentionsUseCaseMock();
    cubit = LoginPageCubit(
      loginWithCredentionsUseCase: loginWithCredentionsUseCaseMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  test(
    'should emit [LoginPageViewModelUpdated] with default view model as initial'
    ' state',
    () {
      expect(
        cubit.state,
        isA<LoginPageViewModelUpdated>().having(
          (state) => state.viewModel,
          'viewModel',
          _defaultViewModelMatcher(),
        ),
      );
    },
  );

  group('onEmailChange', () {
    parameterizedTest(
      'should emit [LoginPageViewModelUpdated] with given email value and '
      'should be showing errors',
      ParameterizedSource.value([
        '',
        '6bpedZ*',
      ]),
      (values) {
        final email = values[0] as String;

        cubit.onEmailChange(email);

        expect(
          cubit.state,
          isA<LoginPageViewModelUpdated>().having(
            (state) => state.viewModel,
            'viewModel',
            isA<LoginPageViewModel>().having(
              (viewModel) => viewModel.email,
              'email',
              isA<EmailViewModel>()
                  .having(
                    (vm) => vm.value,
                    'value',
                    email,
                  )
                  .having(
                    (vm) => vm.showError,
                    'showError',
                    true,
                  ),
            ),
          ),
        );
      },
    );
  });

  group('onPasswordChange', () {
    parameterizedTest(
      'should emit [LoginPageViewModelUpdated] with given password value and '
      'should be showing errors',
      ParameterizedSource.value([
        '',
        'NE#o%',
      ]),
      (values) {
        final password = values[0] as String;

        cubit.onPasswordChange(password);

        expect(
          cubit.state,
          isA<LoginPageViewModelUpdated>().having(
            (state) => state.viewModel,
            'viewModel',
            isA<LoginPageViewModel>().having(
              (viewModel) => viewModel.password,
              'password',
              isA<PasswordViewModel>()
                  .having(
                    (vm) => vm.value,
                    'value',
                    password,
                  )
                  .having(
                    (vm) => vm.showError,
                    'showError',
                    true,
                  ),
            ),
          ),
        );
      },
    );
  });

  group('onLogin', () {
    parameterizedTest(
      'should emit [LoginPageViewModelUpdated] showing errors if email/password have issues',
      ParameterizedSource.values([
        ['', ''],
      ]),
      (values) {
        final email = values[0] as String;
        final password = values[1] as String;

        cubit
          ..onEmailChange(email)
          ..onPasswordChange(password)
          ..onLogin();

        expect(
          cubit.state,
          isA<LoginPageViewModelUpdated>().having(
            (state) => state.viewModel,
            'viewModel',
            isA<LoginPageViewModel>()
                .having(
                  (viewModel) => viewModel.email,
                  'email',
                  isA<EmailViewModel>()
                      .having(
                        (vm) => vm.value,
                        'value',
                        email,
                      )
                      .having(
                        (vm) => vm.showError,
                        'showError',
                        true,
                      ),
                )
                .having(
                  (viewModel) => viewModel.password,
                  'password',
                  isA<PasswordViewModel>()
                      .having(
                        (vm) => vm.value,
                        'value',
                        password,
                      )
                      .having(
                        (vm) => vm.showError,
                        'showError',
                        true,
                      ),
                ),
          ),
        );
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
                isA<LoginPageLoading>(),
                isA<LoginPageViewModelUpdated>(),
                isA<LoginPageDisplayErrorMessage>().having(
                  (s) => s.type,
                  'type',
                  LoginPageErrorTypeViewModel.unableToLogin,
                ),
              ]),
            );

            cubit
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
                    isA<LoginPageLoading>(),
                    isA<LoginPageDisplayLoggedInMessage>(),
                    isA<LoginPagePushRouteReplacing>()
                        .having((s) => s.route, 'route', Routes.home),
                  ],
                ),
              ),
            );

            cubit
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
}

TypeMatcher<LoginPageViewModel> _defaultViewModelMatcher() {
  return isA<LoginPageViewModel>()
      .having(
        (viewModel) => viewModel.email,
        'email',
        isA<EmailViewModel>()
            .having(
              (vm) => vm.value,
              'value',
              '',
            )
            .having(
              (vm) => vm.showError,
              'showError',
              false,
            ),
      )
      .having(
        (viewModel) => viewModel.password,
        'password',
        isA<PasswordViewModel>()
            .having(
              (vm) => vm.value,
              'value',
              '',
            )
            .having(
              (vm) => vm.showError,
              'showError',
              false,
            ),
      );
}

class _LoginWithCredentionsUseCaseMock extends mocktail.Mock
    implements LoginWithCredentialsUseCase {}
