import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/manager/factories/core_cubit_factory.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/core/presentation/widgets/home_page.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/question_management_cubit_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_creation_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_display_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({
    super.key,
    required CoreCubitFactory coreCubitFactory,
    required QuestionManagementCubitFactory questionManagementCubitFactory,
  })  : _coreCubitFactory = coreCubitFactory,
        _questionManagementCubitFactory = questionManagementCubitFactory;

  final CoreCubitFactory _coreCubitFactory;
  final QuestionManagementCubitFactory _questionManagementCubitFactory;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          name: Routes.home.name,
          path: Routes.home.path,
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(
              questionManagementCubitFactory: _questionManagementCubitFactory,
              coreCubitFactory: _coreCubitFactory,
            );
          },
        ),
        GoRoute(
          name: Routes.createQuestion.name,
          path: Routes.createQuestion.path,
          builder: (BuildContext context, GoRouterState state) {
            return QuestionCreationPage(
              cubit:
                  _questionManagementCubitFactory.makeQuestionCreationCubit(),
            );
          },
        ),
        GoRoute(
          name: Routes.displayQuestion.name,
          path: Routes.displayQuestion.path,
          builder: (BuildContext context, GoRouterState state) {
            return QuestionDisplayPage(
              cubit: _questionManagementCubitFactory.makeQuestionDisplayCubit(),
              questionId: state.params['id'],
            );
          },
        ),
      ],
    );

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
}
