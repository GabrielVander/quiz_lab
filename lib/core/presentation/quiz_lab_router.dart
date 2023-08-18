import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/core/constants.dart';
import 'package:quiz_lab/core/presentation/bloc/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/widgets/assessments_page.dart';
import 'package:quiz_lab/core/presentation/widgets/home_page.dart';
import 'package:quiz_lab/core/presentation/widgets/results_page.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/auth/presentation/widgets/login_page.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_creation_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_display_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/questions_overview_page.dart';

abstract interface class QuizLabRouter {
  RouteInformationProvider get routeInformationProvider;

  RouteInformationParser<Object> get routeInformationParser;

  RouterDelegate<Object> get routerDelegate;
}

class QuizLabRouterImpl with EquatableMixin implements QuizLabRouter {
  QuizLabRouterImpl({
    required this.networkCubit,
    required this.bottomNavigationCubit,
    required this.questionCreationCubit,
    required this.questionsOverviewCubit,
    required this.loginPageCubit,
    required this.checkIfUserIsLoggedInUseCase,
  });

  final NetworkCubit networkCubit;
  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionCreationCubit questionCreationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;
  final LoginPageCubit loginPageCubit;
  final CheckIfUserIsLoggedInUseCase checkIfUserIsLoggedInUseCase;

  static final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  late final GoRouter _goRouter = GoRouter(
    initialLocation: Routes.questionsOverview.path,
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
            pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(
              child: AssessmentsPage(
                assessmentsOverviewCubit: AssessmentsOverviewCubit(),
              ),
            ),
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: Routes.questionsOverview.name,
            path: Routes.questionsOverview.path,
            redirect: (buildContext, routerState) async => (await checkIfUserIsLoggedInUseCase()).mapOrElse(
              errMap: (_) => null,
              okMap: (isLoggedIn) => isLoggedIn ? null : Routes.login.path,
            ),
            pageBuilder: (BuildContext context, GoRouterState state) => NoTransitionPage(
              child: QuestionsOverviewPage(
                questionsOverviewCubit: questionsOverviewCubit,
              ),
            ),
            routes: [
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
                    dependencyInjection: dependencyInjection,
                    questionId: state.pathParameters['id'],
                  );
                },
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: Routes.resultsOverview.name,
            path: Routes.resultsOverview.path,
            pageBuilder: (BuildContext context, GoRouterState state) => const NoTransitionPage(
              child: ResultsPage(),
            ),
          ),
        ],
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

  @override
  RouteInformationParser<Object> get routeInformationParser => _goRouter.routeInformationParser;

  @override
  RouteInformationProvider get routeInformationProvider => _goRouter.routeInformationProvider;

  @override
  RouterDelegate<Object> get routerDelegate => _goRouter.routerDelegate;

  @override
  List<Object?> get props => [
        networkCubit,
        bottomNavigationCubit,
        questionCreationCubit,
        questionsOverviewCubit,
        loginPageCubit,
      ];
}
