import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/themes/light_theme.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/pages/question_view.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/main_scaffold.dart';

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
      injector: dependencyInjection.get,
      child: MaterialApp.router(
        title: 'Quiz Lab',
        theme: lightTheme,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );
  }

  GoRouter _getGoRouter() {
    return GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return MainScaffold(
              bottomNavigationCubit: BottomNavigationCubit(),
              networkCubit: NetworkCubit(),
            );
          },
        ),
        GoRoute(
          path: '/question',
          builder: (BuildContext context, GoRouterState state) {
            return QuestionView(
              dependencyInjection: dependencyInjection,
            );
          },
        ),
      ],
    );
  }
}
