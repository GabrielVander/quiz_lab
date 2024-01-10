import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_lab/common/ui/screens/configurations/configurations_screen.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/question_answering_screen.dart';
import 'package:quiz_lab/features/application_information/ui/bloc/version_display/version_display_cubit.dart';
import 'package:quiz_lab/features/application_information/ui/widgets/version_display.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/assessments_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/home_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/login_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_creation_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/questions_overview_page.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/results_page.dart';

abstract interface class QuizLabRouter {
  RouteInformationProvider get routeInformationProvider;

  RouteInformationParser<Object> get routeInformationParser;

  RouterDelegate<Object> get routerDelegate;
}

class QuizLabRouterImpl with EquatableMixin implements QuizLabRouter {
  QuizLabRouterImpl({
    required this.networkCubit,
    required this.bottomNavigationCubit,
    required this.questionDisplayCubit,
    required this.questionCreationCubit,
    required this.questionsOverviewCubit,
    required this.loginPageCubit,
    required this.checkIfUserIsLoggedInUseCase,
    required VersionDisplayCubit versionDisplayCubit,
  }) : _versionDisplayCubit = versionDisplayCubit;

  final NetworkCubit networkCubit;
  final BottomNavigationCubit bottomNavigationCubit;
  final QuestionAnsweringCubit questionDisplayCubit;
  final QuestionCreationCubit questionCreationCubit;
  final QuestionsOverviewCubit questionsOverviewCubit;
  final LoginCubit loginPageCubit;
  final CheckIfUserIsLoggedInUseCase checkIfUserIsLoggedInUseCase;
  final VersionDisplayCubit _versionDisplayCubit;

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
              (_) => null,
              (isLoggedIn) => isLoggedIn ? null : Routes.login.path,
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
                  return QuestionAnsweringScreen(
                    cubit: questionDisplayCubit,
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
            versionDisplayWidget: VersionDisplay(cubit: _versionDisplayCubit),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: Routes.configuration.name,
        path: Routes.configuration.path,
        builder: (BuildContext context, GoRouterState state) {
          return ConfigurationsScreen(
            options: const [],
            bottomWidget: VersionDisplay(cubit: _versionDisplayCubit),
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
