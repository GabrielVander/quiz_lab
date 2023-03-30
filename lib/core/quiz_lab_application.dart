import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/core/presentation/widgets/home_page.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/widgets/login_page.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_creation_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_display_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({
    required this.networkCubit,
    required this.bottomNavigationCubit,
    required this.questionCreationCubit,
    required this.questionsOverviewCubit,
    required this.questionDisplayCubit,
    required this.loginPageCubit,
    super.key,
  });

  final NetworkCubit networkCubit;
  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionCreationCubit questionCreationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;
  final QuestionDisplayCubit questionDisplayCubit;
  final LoginPageCubit loginPageCubit;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: Routes.login.path,
      routes: <GoRoute>[
        GoRoute(
          name: Routes.home.name,
          path: Routes.home.path,
          builder: (BuildContext context, GoRouterState state) {
            return HomePage(
              networkCubit: networkCubit,
              bottomNavigationCubit: bottomNavigationCubit,
              questionsOverviewCubit: questionsOverviewCubit,
            );
          },
        ),
        GoRoute(
          name: Routes.createQuestion.name,
          path: Routes.createQuestion.path,
          builder: (BuildContext context, GoRouterState state) {
            return QuestionCreationPage(
              cubit: questionCreationCubit,
            );
          },
        ),
        GoRoute(
          name: Routes.displayQuestion.name,
          path: Routes.displayQuestion.path,
          builder: (BuildContext context, GoRouterState state) {
            return QuestionDisplayPage(
              cubit: questionDisplayCubit,
              questionId: state.params['id'],
            );
          },
        ),
        GoRoute(
          name: Routes.login.name,
          path: Routes.login.path,
          builder: (BuildContext context, GoRouterState state) {
            return LoginPage(
              loginPageCubit: loginPageCubit,
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
