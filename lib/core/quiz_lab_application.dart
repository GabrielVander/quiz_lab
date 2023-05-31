import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/core/presentation/widgets/assessments_page.dart';
import 'package:quiz_lab/core/presentation/widgets/home_page.dart';
import 'package:quiz_lab/core/presentation/widgets/results_page.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/widgets/login_page.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_creation_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_display_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/questions_overview_page.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuizLabApplication extends StatelessWidget {
  QuizLabApplication({
    required this.networkCubit,
    required this.bottomNavigationCubit,
    required this.questionCreationCubit,
    required this.questionsOverviewCubit,
    required this.questionDisplayCubit,
    required this.loginPageCubit,
    super.key,
  }) {
    router = GoRouter(
      initialLocation: Routes.login.path,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, child) {
            return HomePage(
              networkCubit: networkCubit,
              bottomNavigationCubit: bottomNavigationCubit,
              questionsOverviewCubit: questionsOverviewCubit,
              child: child,
            );
          },
          routes: [
            GoRoute(
              name: Routes.assessments.name,
              path: Routes.assessments.path,
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  NoTransitionPage(
                child: AssessmentsPage(
                  assessmentsOverviewCubit: AssessmentsOverviewCubit(),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              name: Routes.questionsOverview.name,
              path: Routes.questionsOverview.path,
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  NoTransitionPage(
                child: QuestionsOverviewPage(
                  questionsOverviewCubit: questionsOverviewCubit,
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              name: Routes.resultsOverview.name,
              path: Routes.resultsOverview.path,
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  const NoTransitionPage(
                child: ResultsPage(),
              ),
            )
          ],
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: Routes.createQuestion.name,
          path: Routes.createQuestion.path,
          builder: (BuildContext context, GoRouterState state) {
            return QuestionCreationPage(
              cubit: questionCreationCubit,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: Routes.displayQuestion.name,
          path: Routes.displayQuestion.path,
          builder: (BuildContext context, GoRouterState state) {
            return QuestionDisplayPage(
              cubit: questionDisplayCubit,
              questionId: state.pathParameters['id'],
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
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
  }

  final NetworkCubit networkCubit;
  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionCreationCubit questionCreationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;
  final QuestionDisplayCubit questionDisplayCubit;
  final LoginPageCubit loginPageCubit;

  static final _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  late final GoRouter router;

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
