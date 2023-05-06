import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';
import 'package:quiz_lab/features/auth/presentation/widgets/login_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

import '../../../../test_utils/helper_functions.dart' show safeTapByKey;

void main() {
  late S localizationsMock;
  late AppLocalizationDelegate localizationsDelegateMock;
  late GoRouter goRouterMock;
  late LoginPageCubit loginPageCubitMock;

  setUp(() {
    localizationsMock = _SMock();
    localizationsDelegateMock =
        _LocalizationsDelegateMock(localizations: localizationsMock);
    goRouterMock = _GoRouterMock();
    loginPageCubitMock = _LoginPageCubitMock();
  });

  tearDown(mocktail.resetMocktailState);

  testWidgets(
    'should display a circular progress indicator if cubit state is '
    '[LoginPageInitial]',
    (widgetTester) async {
      mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => const Stream.empty(),
          );
      mocktail
          .when(() => loginPageCubitMock.state)
          .thenReturn(LoginPageState.initial());

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsAtLeastNWidgets(1),
      );
    },
  );

  testWidgets(
    'should display a circular progress indicator if cubit state is '
    '[LoginPageLoading]',
    (widgetTester) async {
      mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => const Stream.empty(),
          );
      mocktail
          .when(() => loginPageCubitMock.state)
          .thenReturn(LoginPageState.loading());

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsAtLeastNWidgets(1),
      );
    },
  );

  for (final route in Routes.values) {
    testWidgets(
      'should redirect to ${route.name} if cubit state is '
      '[LoginPagePushRouteReplacing]',
      (widgetTester) async {
        mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
              (_) => Stream<LoginPageState>.value(
                LoginPageState.pushRouteReplacing(route),
              ),
            );

        mocktail.when(() => loginPageCubitMock.state).thenReturn(
              LoginPageState.pushRouteReplacing(route),
            );

        await _pumpTarget(
          widgetTester,
          localizationsDelegateMock,
          loginPageCubitMock,
          goRouterMock,
        );

        widgetTester.binding.scheduleWarmUpFrame();

        mocktail.verify(() => goRouterMock.goNamed(route.name)).called(1);
      },
    );
  }

  testWidgets(
    'should have expected structure',
    (WidgetTester widgetTester) async {
      mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => const Stream.empty(),
          );
      mocktail.when(() => loginPageCubitMock.state).thenReturn(
            LoginPageState.viewModelUpdated(
              const LoginPageViewModel(
                email: EmailViewModel(value: ''),
                password: PasswordViewModel(value: ''),
                applicationVersion: '',
              ),
            ),
          );

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      expect(
        find.text(localizationsMock.loginPageDisplayTitle),
        findsOneWidget,
      );

      expect(
        find.byKey(const ValueKey('loginForm'), skipOffstage: false),
        findsOneWidget,
      );

      expect(
        find.byKey(const ValueKey('emailFormField')),
        findsOneWidget,
      );
      expect(
        find.text(localizationsMock.emailLabel, skipOffstage: false),
        findsNWidgets(2),
      );

      expect(
        find.byKey(const ValueKey('passwordFormField')),
        findsOneWidget,
      );
      expect(find.text(localizationsMock.passwordLabel), findsNWidgets(2));

      expect(
        find.byKey(const ValueKey('loginButton')),
        findsOneWidget,
      );
      expect(find.text(localizationsMock.logInButtonLabel), findsOneWidget);

      expect(
        find.text(
          localizationsMock.dontHaveAnAccountPhrase,
          skipOffstage: false,
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(const ValueKey('signUpButton'), skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text(
          localizationsMock.loginPageSignUpButtonLabel,
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    },
  );

  group(
    'should replace with given route when cubit state is '
    '[LoginPagePushRouteReplacing]',
    () {
      for (final route in Routes.values) {
        testWidgets(
          route.toString(),
          (widgetTester) async {
            mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                  (_) => Stream.value(LoginPageState.pushRouteReplacing(route)),
                );
            mocktail.when(() => loginPageCubitMock.state).thenReturn(
                  LoginPageState.pushRouteReplacing(route),
                );

            await _pumpTarget(
              widgetTester,
              localizationsDelegateMock,
              loginPageCubitMock,
              goRouterMock,
            );

            widgetTester.binding.scheduleWarmUpFrame();

            mocktail.verify(() => goRouterMock.goNamed(route.name)).called(1);
          },
        );
      }
    },
  );

  group(
    'should display form errors when a form error view model is emitted',
    () {
      testWidgets(
        'empty password error',
        (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                (_) => const Stream.empty(),
              );

          mocktail.when(() => loginPageCubitMock.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  const LoginPageViewModel(
                    email: EmailViewModel(
                      value: '',
                      showError: true,
                    ),
                    password: PasswordViewModel(
                      value: '',
                    ),
                    applicationVersion: '',
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          expect(
            find.text(localizationsMock.mustBeSetMessage),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'empty password error',
        (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                (_) => const Stream.empty(),
              );
          mocktail.when(() => loginPageCubitMock.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  const LoginPageViewModel(
                    email: EmailViewModel(
                      value: '',
                    ),
                    password: PasswordViewModel(
                      value: '',
                      showError: true,
                    ),
                    applicationVersion: '',
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          expect(
            find.text(localizationsMock.mustBeSetMessage),
            findsOneWidget,
          );
        },
      );
    },
  );

  group(
    'should display email from view model',
    () {
      for (final email in [
        '',
        'Aqhv&Wf',
      ]) {
        testWidgets(email, (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                (_) => const Stream.empty(),
              );
          mocktail.when(() => loginPageCubitMock.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  LoginPageViewModel(
                    email: EmailViewModel(value: email),
                    password: const PasswordViewModel(value: ''),
                    applicationVersion: '',
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          expect(
            find.widgetWithText(TextFormField, email),
            findsAtLeastNWidgets(1),
          );
        });
      }
    },
  );

  group(
    'should display password from view model',
    () {
      for (final password in [
        '',
        '^P22!t',
      ]) {
        testWidgets(password, (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                (_) => const Stream.empty(),
              );
          mocktail.when(() => loginPageCubitMock.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  LoginPageViewModel(
                    email: const EmailViewModel(value: ''),
                    password: PasswordViewModel(value: password),
                    applicationVersion: '',
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          expect(
            find.widgetWithText(TextFormField, password),
            findsAtLeastNWidgets(1),
          );
        });
      }
    },
  );

  group(
    'should call cubit with given email on email input',
    () {
      for (final email in [
        'a',
        'aB',
        'aBwNUcz',
      ]) {
        testWidgets(email, (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                (_) => const Stream.empty(),
              );
          mocktail.when(() => loginPageCubitMock.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  const LoginPageViewModel(
                    email: EmailViewModel(value: ''),
                    password: PasswordViewModel(value: ''),
                    applicationVersion: '',
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          await widgetTester.enterText(
            find.byKey(const ValueKey('emailFormField')),
            email,
          );

          mocktail
              .verify(() => loginPageCubitMock.onEmailChange(email))
              .called(1);
        });
      }
    },
  );

  group(
    'should call cubit with given password on password input',
    () {
      for (final password in [
        'W',
        r'4bv1Bn$&',
      ]) {
        testWidgets(password, (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                (_) => const Stream.empty(),
              );
          mocktail.when(() => loginPageCubitMock.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  const LoginPageViewModel(
                    email: EmailViewModel(value: ''),
                    password: PasswordViewModel(value: ''),
                    applicationVersion: '',
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          await widgetTester.enterText(
            find.byKey(const ValueKey('passwordFormField')),
            password,
          );

          mocktail
              .verify(() => loginPageCubitMock.onPasswordChange(password))
              .called(1);
        });
      }
    },
  );

  group(
    'should display correct message when cubit emits '
    '[LoginPageDisplayErrorMessage]',
    () {
      for (final string in [
        '',
        '2*2l9vT',
      ]) {
        testWidgets(
          '${LoginPageErrorTypeViewModel.generic} -> $string',
          (WidgetTester widgetTester) async {
            mocktail
                .when(() => localizationsMock.genericErrorMessage)
                .thenReturn(string);

            mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                  (_) => Stream.value(
                    LoginPageState.displayErrorMessage(
                      LoginPageErrorTypeViewModel.generic,
                    ),
                  ),
                );
            mocktail.when(() => loginPageCubitMock.state).thenReturn(
                  LoginPageState.displayErrorMessage(
                    LoginPageErrorTypeViewModel.generic,
                  ),
                );

            await _pumpTarget(
              widgetTester,
              localizationsDelegateMock,
              loginPageCubitMock,
              goRouterMock,
            );

            widgetTester.binding.scheduleWarmUpFrame();
            await widgetTester.pump();

            expect(find.widgetWithText(SnackBar, string), findsOneWidget);
          },
        );
      }
    },
  );

  testWidgets(
    'should call cubit when login button is pressed',
    (WidgetTester widgetTester) async {
      mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => const Stream.empty(),
          );
      mocktail.when(() => loginPageCubitMock.state).thenReturn(
            LoginPageState.viewModelUpdated(
              const LoginPageViewModel(
                email: EmailViewModel(value: ''),
                password: PasswordViewModel(value: ''),
                applicationVersion: '',
              ),
            ),
          );

      mocktail
          .when(() => loginPageCubitMock.onLogin())
          .thenAnswer((_) async {});

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      await widgetTester.tap(find.byKey(const ValueKey('loginButton')));

      await widgetTester.pump();

      mocktail.verify(() => loginPageCubitMock.onLogin()).called(1);
    },
  );

  testWidgets(
    'should call cubit when sign up button is pressed',
    (WidgetTester widgetTester) async {
      mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => const Stream.empty(),
          );
      mocktail.when(() => loginPageCubitMock.state).thenReturn(
            LoginPageState.viewModelUpdated(
              const LoginPageViewModel(
                email: EmailViewModel(value: ''),
                password: PasswordViewModel(value: ''),
                applicationVersion: '',
              ),
            ),
          );

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      await safeTapByKey(widgetTester, const ValueKey('signUpButton'));

      mocktail.verify(() => loginPageCubitMock.onSignUp()).called(1);
    },
  );

  group(
    'should display not yet implemented message when cubit emits '
    '[LoginPageDisplayNotYetImplementedMessage]',
    () {
      for (final text in ['']) {
        testWidgets(
          text,
          (widgetTester) async {
            mocktail.when(() => localizationsMock.notYetImplemented).thenReturn(
                  text,
                );

            mocktail.when(() => loginPageCubitMock.state).thenReturn(
                  LoginPageState.displayNotYetImplementedMessage(),
                );

            mocktail.when(() => loginPageCubitMock.stream).thenAnswer(
                  (_) => Stream.value(
                    LoginPageState.displayNotYetImplementedMessage(),
                  ),
                );

            await _pumpTarget(
              widgetTester,
              localizationsDelegateMock,
              loginPageCubitMock,
              goRouterMock,
            );

            widgetTester.binding.scheduleWarmUpFrame();

            await widgetTester.pump();

            expect(find.text(text), findsOneWidget);
          },
        );
      }
    },
  );
}

Future<void> _pumpTarget(
  WidgetTester widgetTester,
  AppLocalizationDelegate localizationsDelegateMock,
  LoginPageCubit loginPageCubit,
  GoRouter goRouter,
) async {
  await widgetTester.pumpWidget(
    InheritedGoRouter(
      goRouter: goRouter,
      child: Localizations(
        locale: const Locale('en'),
        delegates: [
          localizationsDelegateMock,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        child: Theme(
          data: lightTheme,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (BuildContext context) => ScaffoldMessenger(
                    child: LoginPage(
                      loginPageCubit: loginPageCubit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _LocalizationsDelegateMock extends mocktail.Mock
    implements AppLocalizationDelegate {
  _LocalizationsDelegateMock({required S localizations}) : s = localizations;

  final S s;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<S> load(Locale locale) => SynchronousFuture(s);

  @override
  Type get type => S;
}

class _SMock extends mocktail.Mock implements S {
  @override
  String get emailLabel => 'lFR';

  @override
  String get loginPageSignUpButtonLabel => '9Hp!';

  @override
  String get passwordLabel => '6fm1%Tf@';

  @override
  String get enterAnonymouslyButtonLabel => r'v5u9&$L';

  @override
  String get dontHaveAnAccountPhrase => '@ao';

  @override
  String get loginPageDisplayTitle => 'XWEz3';

  @override
  String get logInButtonLabel => '05w';

  @override
  String get mustBeSetMessage => 'x^WO2S&';
}

class _LoginPageCubitMock extends mocktail.Mock implements LoginPageCubit {}

class _GoRouterMock extends mocktail.Mock implements GoRouter {}

class LoginPageCubitMock extends MockCubit<LoginPageState>
    implements LoginPageCubit {}
