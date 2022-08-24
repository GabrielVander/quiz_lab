import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/pages/main_scaffold.dart';
import 'package:quiz_lab/core/themes/light_theme.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class QuizLabApplication extends StatelessWidget {
  const QuizLabApplication({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    return HookedBlocConfigProvider(
      injector: dependencyInjection.get,
      child: MaterialApp(
        title: 'Quiz Lab',
        theme: lightTheme,
        home: MainScaffold(
          dependencyInjection: dependencyInjection,
        ),
      ),
    );
  }
}
