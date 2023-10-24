import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/ui/quiz_lab_router.dart';
import 'package:quiz_lab/core/ui/themes/light_theme.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({
    required this.router,
    super.key,
  });

  final QuizLabRouter router;

  @override
  Widget build(BuildContext context) {
    return HookedBlocConfigProvider(
      child: MaterialApp.router(
        title: 'Quiz Lab',
        theme: lightTheme,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          if (supportedLocales.contains(locale)) {
            return locale;
          }

          if (locale?.languageCode == 'pt') {
            return const Locale('pt', 'BR');
          }

          return const Locale('en', 'US');
        },
      ),
    );
  }
}
