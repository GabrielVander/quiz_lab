import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/ui/themes/light_theme.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/view_models/login_page_view_model.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/login_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

import '../../../../test_utils/helper_functions.dart' show safeTapByKey;

void main() {
  late S localizationsMock;
  late AppLocalizationDelegate localizationsDelegateMock;
  late GoRouter goRouterMock;
  late LoginPageCubit loginPageCubitMock;

  setUp(() {
    localizationsMock = _SMock();
    localizationsDelegateMock = _LocalizationsDelegateMock(localizations: localizationsMock);
    goRouterMock = _GoRouterMock();
    loginPageCubitMock = _LoginPageCubitMock();
  });

  tearDown(resetMocktailState);

  testWidgets('should always call hydrate()', (widgetTester) async {
    when(() => loginPageCubitMock.stream).thenAnswer((_) => const Stream.empty());
    when(() => loginPageCubitMock.state).thenReturn(const LoginPageInitial());

    await _pumpTarget(
      widgetTester,
      localizationsDelegateMock,
      loginPageCubitMock,
      goRouterMock,
    );

    verify(() => loginPageCubitMock.hydrate()).called(1);
  });

  testWidgets('should display a circular progress indicator if cubit state is [LoginPageInitial]',
      (widgetTester) async {
    when(() => loginPageCubitMock.stream).thenAnswer((_) => Stream.value(const LoginPageInitial()));
    when(() => loginPageCubitMock.state).thenReturn(const LoginPageInitial());

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
  });

  testWidgets('should display a circular progress indicator if cubit state is [LoginPageLoading]',
      (widgetTester) async {
    when(() => loginPageCubitMock.stream).thenAnswer((_) => const Stream.empty());
    when(() => loginPageCubitMock.state).thenReturn(const LoginPageLoading());

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
  });

  for (final route in Routes.values) {
    testWidgets('should redirect to ${route.name} if cubit state is [LoginPagePushRouteReplacing]',
        (widgetTester) async {
      when(() => loginPageCubitMock.stream).thenAnswer(
        (_) => Stream<LoginPageState>.value(
          LoginPagePushRouteReplacing(route: route),
        ),
      );

      when(() => loginPageCubitMock.state).thenReturn(LoginPagePushRouteReplacing(route: route));

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      widgetTester.binding.scheduleWarmUpFrame();

      verify(() => goRouterMock.goNamed(route.name)).called(1);
    });
  }

  testWidgets('should have expected structure', (WidgetTester widgetTester) async {
    when(() => loginPageCubitMock.stream).thenAnswer((_) => const Stream.empty());
    when(() => loginPageCubitMock.state).thenReturn(
      const LoginPageViewModelUpdated(
        viewModel: LoginPageViewModel(
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

    expect(find.text(localizationsMock.loginPageDisplayTitle), findsOneWidget);

    expect(
      find.byKey(const ValueKey('loginForm'), skipOffstage: false),
      findsOneWidget,
    );

    expect(find.byKey(const ValueKey('emailFormField')), findsOneWidget);
    expect(
      find.text(localizationsMock.emailLabel, skipOffstage: false),
      findsOneWidget,
    );

    expect(find.byKey(const ValueKey('passwordFormField')), findsOneWidget);
    expect(find.text(localizationsMock.passwordLabel), findsOneWidget);

    expect(find.byKey(const ValueKey('loginButton')), findsOneWidget);
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

    expect(
      find.byKey(const ValueKey('applicationVersion'), skipOffstage: false),
      findsOneWidget,
    );
  });

  group('should display application version', () {
    for (final version in ['GAN4gzF0', 'fxAIW2']) {
      testWidgets(version, (WidgetTester widgetTester) async {
        final state = LoginPageViewModelUpdated(
          viewModel: LoginPageViewModel(
            email: const EmailViewModel(value: ''),
            password: const PasswordViewModel(value: ''),
            applicationVersion: version,
          ),
        );

        when(() => loginPageCubitMock.stream).thenAnswer((_) => Stream.value(state));
        when(() => loginPageCubitMock.state).thenReturn(state);

        await _pumpTarget(
          widgetTester,
          localizationsDelegateMock,
          loginPageCubitMock,
          goRouterMock,
        );

        expect(find.text(version, skipOffstage: false), findsOneWidget);
      });
    }
  });

  group('should replace with given route when cubit state is [LoginPagePushRouteReplacing]', () {
    for (final route in Routes.values) {
      testWidgets(
        route.toString(),
        (widgetTester) async {
          when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => Stream.value(LoginPagePushRouteReplacing(route: route)),
          );
          when(() => loginPageCubitMock.state).thenReturn(LoginPagePushRouteReplacing(route: route));

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubitMock,
            goRouterMock,
          );

          widgetTester.binding.scheduleWarmUpFrame();

          verify(() => goRouterMock.goNamed(route.name)).called(1);
        },
      );
    }
  });

  group('should display form errors when a form error view model is emitted', () {
    testWidgets(
      'empty password error',
      (WidgetTester widgetTester) async {
        when(() => loginPageCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );

        when(() => loginPageCubitMock.state).thenReturn(
          const LoginPageViewModelUpdated(
            viewModel: LoginPageViewModel(
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

        expect(find.text(localizationsMock.mustBeSetMessage), findsOneWidget);
      },
    );

    testWidgets(
      'empty password error',
      (WidgetTester widgetTester) async {
        when(() => loginPageCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => loginPageCubitMock.state).thenReturn(
          const LoginPageViewModelUpdated(
            viewModel: LoginPageViewModel(
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

        expect(find.text(localizationsMock.mustBeSetMessage), findsOneWidget);
      },
    );
  });

  group('should display email from view model', () {
    for (final email in ['#LU7@', 'Aqhv&Wf']) {
      testWidgets(email, (WidgetTester widgetTester) async {
        when(() => loginPageCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => loginPageCubitMock.state).thenReturn(
          LoginPageViewModelUpdated(
            viewModel: LoginPageViewModel(
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

        expect(find.text(email), findsOneWidget);
      });
    }
  });

  group('should display password from view model', () {
    for (final password in [
      'd8t7&',
      '^P22!t',
    ]) {
      testWidgets(password, (WidgetTester widgetTester) async {
        when(() => loginPageCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => loginPageCubitMock.state).thenReturn(
          LoginPageViewModelUpdated(
            viewModel: LoginPageViewModel(
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

        expect(find.text(password), findsOneWidget);
      });
    }
  });

  group('should call cubit with given email on email input', () {
    for (final email in ['a', 'aB', 'aBwNUcz']) {
      testWidgets(email, (WidgetTester widgetTester) async {
        when(() => loginPageCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => loginPageCubitMock.state).thenReturn(
          const LoginPageViewModelUpdated(
            viewModel: LoginPageViewModel(
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

        verify(() => loginPageCubitMock.updateEmail(email)).called(1);
      });
    }
  });

  group('should call cubit with given password on password input', () {
    for (final password in ['W', r'4bv1Bn$&']) {
      testWidgets(password, (WidgetTester widgetTester) async {
        when(() => loginPageCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => loginPageCubitMock.state).thenReturn(
          const LoginPageViewModelUpdated(
            viewModel: LoginPageViewModel(
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

        verify(() => loginPageCubitMock.updatePassword(password)).called(1);
      });
    }
  });

  group('should display correct message when cubit emits [LoginPageError]', () {
    for (final string in ['53Av8', '2*2l9vT']) {
      testWidgets(
        string,
        (WidgetTester widgetTester) async {
          when(() => localizationsMock.genericErrorMessage).thenReturn(string);
          when(() => loginPageCubitMock.stream).thenAnswer((_) => Stream.value(const LoginPageError()));
          when(() => loginPageCubitMock.state).thenReturn(const LoginPageError());

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
  });

  group('should display correct message when cubit emits [LoginPageUnableToLogin]', () {
    for (final string in ['8Xwng', '2g0jg1th']) {
      testWidgets(
        string,
        (WidgetTester widgetTester) async {
          when(() => localizationsMock.unableToLogin).thenReturn(string);
          when(() => loginPageCubitMock.stream).thenAnswer((_) => Stream.value(const LoginPageUnableToLogin()));
          when(() => loginPageCubitMock.state).thenReturn(const LoginPageUnableToLogin());

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
  });

  testWidgets('should call cubit when login button is pressed', (WidgetTester widgetTester) async {
    when(() => loginPageCubitMock.stream).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => loginPageCubitMock.state).thenReturn(
      const LoginPageViewModelUpdated(
        viewModel: LoginPageViewModel(
          email: EmailViewModel(value: ''),
          password: PasswordViewModel(value: ''),
          applicationVersion: '',
        ),
      ),
    );

    when(() => loginPageCubitMock.login()).thenAnswer((_) async {});

    await _pumpTarget(
      widgetTester,
      localizationsDelegateMock,
      loginPageCubitMock,
      goRouterMock,
    );

    await widgetTester.tap(find.byKey(const ValueKey('loginButton')));

    await widgetTester.pump();

    verify(() => loginPageCubitMock.login()).called(1);
  });

  testWidgets('should call cubit when sign up button is pressed', (WidgetTester widgetTester) async {
    when(() => loginPageCubitMock.stream).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => loginPageCubitMock.state).thenReturn(
      const LoginPageViewModelUpdated(
        viewModel: LoginPageViewModel(
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

    verify(() => loginPageCubitMock.signUp()).called(1);
  });

  group('should display not yet implemented message when cubit emits [LoginPageDisplayNotYetImplementedMessage]', () {
    for (final text in ['*mgS', 'DyDM']) {
      testWidgets(
        text,
        (widgetTester) async {
          when(() => localizationsMock.notYetImplemented).thenReturn(text);

          when(() => loginPageCubitMock.state).thenReturn(const LoginPageNotYetImplemented());

          when(() => loginPageCubitMock.stream).thenAnswer(
            (_) => Stream.value(const LoginPageNotYetImplemented()),
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
  });

  group('anonymous login', () {
    testWidgets('should call cubit when enter anonymously section is pressed', (WidgetTester widgetTester) async {
      when(() => loginPageCubitMock.stream).thenAnswer((_) => const Stream.empty());
      when(() => loginPageCubitMock.state).thenReturn(
        const LoginPageViewModelUpdated(
          viewModel: LoginPageViewModel(
            email: EmailViewModel(value: ''),
            password: PasswordViewModel(value: ''),
            applicationVersion: '',
          ),
        ),
      );
      when(loginPageCubitMock.enterAnonymously).thenAnswer((_) async {});

      await _pumpTarget(
        widgetTester,
        localizationsDelegateMock,
        loginPageCubitMock,
        goRouterMock,
      );

      await safeTapByKey(
        widgetTester,
        const ValueKey('enterAnonymouslyButton'),
      );

      verify(loginPageCubitMock.enterAnonymously).called(1);
    });
  });
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

class _LocalizationsDelegateMock extends Mock implements AppLocalizationDelegate {
  _LocalizationsDelegateMock({required S localizations}) : s = localizations;

  final S s;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<S> load(Locale locale) => SynchronousFuture(s);

  @override
  Type get type => S;
}

class _SMock extends Mock implements S {
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

class _LoginPageCubitMock extends Mock implements LoginPageCubit {}

class _GoRouterMock extends Mock implements GoRouter {}

class LoginPageCubitMock extends MockCubit<LoginPageState> implements LoginPageCubit {}
