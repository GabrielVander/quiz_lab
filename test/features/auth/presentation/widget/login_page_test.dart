import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/features/auth/presentation/widget/login_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

void main() {
  late _SMock localizationsMock;
  late _LocalizationsDelegateMock localizationsDelegateMock;

  setUp(() {
    localizationsMock = _SMock();
    localizationsDelegateMock =
        _LocalizationsDelegateMock(localizations: localizationsMock);
  });

  tearDown(mocktail.resetMocktailState);

  testWidgets('should have expected structure',
      (WidgetTester widgetTester) async {
    mocktail
        .when(() => localizationsMock.loginPageDisplayTitle)
        .thenReturn('7S3M&0V');
    mocktail.when(() => localizationsMock.emailLabel).thenReturn('&&1G^');
    mocktail.when(() => localizationsMock.passwordLabel).thenReturn('6zd%');
    mocktail.when(() => localizationsMock.logInButtonLabel).thenReturn('KVkMu');
    mocktail
        .when(() => localizationsMock.enterAnonymouslyButtonLabel)
        .thenReturn(r'$t8PZG');
    mocktail
        .when(() => localizationsMock.dontHaveAnAccountPhrase)
        .thenReturn('8JW%!GWl');
    mocktail
        .when(() => localizationsMock.loginPageSignUpButtonLabel)
        .thenReturn('!Mq1');

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
          child: const MediaQuery(
            data: MediaQueryData(),
            child: LoginPage(),
          ),
        ),
      ),
    );

    expect(
      find.byType(Container),
      findsOneWidget,
      reason: 'Missing loginPage',
    );

    expect(
      find.byKey(const ValueKey('loginForm'), skipOffstage: false),
      findsOneWidget,
      reason: 'Missing loginForm',
    );
    expect(
      find.byKey(const ValueKey('emailFormField')),
      findsOneWidget,
      reason: 'Missing emailFormField',
    );
    expect(
      find.byKey(const ValueKey('passwordFormField')),
      findsOneWidget,
      reason: 'Missing passwordFormField',
    );
    expect(
      find.byKey(const ValueKey('loginButton')),
      findsOneWidget,
      reason: 'Missing loginButton',
    );
    expect(
      find.byKey(const ValueKey('enterAnonymouslyButton')),
      findsOneWidget,
      reason: 'Missing enterAnonymouslyButton',
    );
    expect(
      find.byKey(const ValueKey('signUpButton')),
      findsOneWidget,
      reason: 'Missing signUpButton',
    );
  });
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

class _SMock extends mocktail.Mock implements S {}
