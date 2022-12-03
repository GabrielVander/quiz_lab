import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import '../generated/l10n.dart';
import 'common/manager_factory.dart';
import 'dependency_injection/dependency_injection.dart';
import 'presentation/widgets/main_scaffold.dart';
import 'presentation/widgets/question_view.dart';
import 'themes/light_theme.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    final router = _getGoRouter();

    return HookedBlocConfigProvider(
      child: MaterialApp.router(
        title: 'Quiz Lab',
        theme: lightTheme,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
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

  GoRouter _getGoRouter() {
    final managerFactory = dependencyInjection.get<ManagerFactory>().unwrap();

    return GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return MainScaffold(
              managerFactory: managerFactory,
            );
          },
        ),
        GoRoute(
          path: '/question',
          builder: (BuildContext context, GoRouterState state) {
            return QuestionView(
              managerFactory: managerFactory,
            );
          },
        ),
      ],
    );
  }
}
