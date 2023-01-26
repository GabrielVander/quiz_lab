import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';
import 'package:quiz_lab/features/auth/presentation/widgets/login_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

void main() {
  late S localizationsMock;
  late AppLocalizationDelegate localizationsDelegateMock;
  late LoginPageCubit loginPageCubit;

  setUp(() {
    localizationsMock = _SMock();
    localizationsDelegateMock =
        _LocalizationsDelegateMock(localizations: localizationsMock);
    loginPageCubit = _LoginPageCubitMock();
  });

  tearDown(mocktail.resetMocktailState);

  testWidgets('should have expected structure',
      (WidgetTester widgetTester) async {
    mocktail.when(() => loginPageCubit.state).thenReturn(
          LoginPageState.viewModelUpdated(
            const LoginPageViewModel(
              email: EmailViewModel(value: ''),
              password: PasswordViewModel(value: ''),
            ),
          ),
        );

    await _pumpTarget(
      widgetTester,
      localizationsDelegateMock,
      loginPageCubit,
    );

    expect(find.text(localizationsMock.loginPageDisplayTitle), findsOneWidget);

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
      find.byKey(const ValueKey('enterAnonymouslyButton'), skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text(
        localizationsMock.enterAnonymouslyButtonLabel,
        skipOffstage: false,
      ),
      findsOneWidget,
    );

    expect(
      find.text(localizationsMock.dontHaveAnAccountPhrase, skipOffstage: false),
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
  });

  group(
    'should display form errors when a form error view model is emitted',
    () {
      testWidgets(
        'empty email error',
        (WidgetTester widgetTester) async {
          mocktail.when(() => loginPageCubit.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  const LoginPageViewModel(
                    email: EmailViewModel(
                      value: '',
                      showError: true,
                    ),
                    password: PasswordViewModel(
                      value: '',
                    ),
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubit,
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
          mocktail.when(() => loginPageCubit.state).thenReturn(
                LoginPageState.viewModelUpdated(
                  const LoginPageViewModel(
                    email: EmailViewModel(
                      value: '',
                    ),
                    password: PasswordViewModel(
                      value: '',
                      showError: true,
                    ),
                  ),
                ),
              );

          await _pumpTarget(
            widgetTester,
            localizationsDelegateMock,
            loginPageCubit,
          );

          expect(
            find.text(localizationsMock.mustBeSetMessage),
            findsOneWidget,
          );
        },
      );
    },
  );
}

Future<void> _pumpTarget(
  WidgetTester widgetTester,
  AppLocalizationDelegate localizationsDelegateMock,
  LoginPageCubit loginPageCubit,
) async {
  await widgetTester.pumpWidget(
    Localizations(
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
          child: LoginPage(
            loginPageCubit: loginPageCubit,
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

class _LoginPageCubitMock extends mocktail.Mock implements LoginPageCubit {
  @override
  Stream<LoginPageState> get stream => const Stream.empty();
}
