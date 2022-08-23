import 'package:flutter/material.dart';
import 'package:quiz_lab/core/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/utils/constants.dart';

void main() async {
  setupInjections();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    QuizLabApplication(
      dependencyInjection: dependencyInjection,
    ),
  );
}

void setupInjections() {
  dependencyInjection
      .registerBuilder<BottomNavigationCubit>(BottomNavigationCubit.new);
}
