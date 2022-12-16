import 'package:okay/okay.dart';
import 'package:quiz_lab/core/common/manager.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

class ManagerFactory extends Manager {
  ManagerFactory({
    required DependencyInjection dependencyInjection,
  }) : _dependencyInjection = dependencyInjection;

  final DependencyInjection _dependencyInjection;

  Result<Manager, ManagerFactoryFailure> make({
    required AvailableManagers desiredManager,
  }) {
    switch (desiredManager) {
      case AvailableManagers.networkCubit:
        return _dependencyInjection.get<NetworkCubit>().mapOrElse(
              errMap: (_) =>
                  Result<Manager, ManagerFactoryFailure>.ok(DummyManager()),
              okMap: Result<Manager, ManagerFactoryFailure>.ok,
            );
      case AvailableManagers.bottomNavigationCubit:
        return _dependencyInjection.get<BottomNavigationCubit>().mapOrElse(
              errMap: (_) =>
                  Result<Manager, ManagerFactoryFailure>.ok(DummyManager()),
              okMap: Result<Manager, ManagerFactoryFailure>.ok,
            );
      case AvailableManagers.assessmentsOverviewCubit:
        return _dependencyInjection.get<AssessmentsOverviewCubit>().mapOrElse(
              errMap: (_) =>
                  Result<Manager, ManagerFactoryFailure>.ok(DummyManager()),
              okMap: Result<Manager, ManagerFactoryFailure>.ok,
            );
      case AvailableManagers.questionsOverviewCubit:
        return _dependencyInjection.get<QuestionsOverviewCubit>().mapOrElse(
              errMap: (_) =>
                  Result<Manager, ManagerFactoryFailure>.ok(DummyManager()),
              okMap: Result<Manager, ManagerFactoryFailure>.ok,
            );
      case AvailableManagers.questionCreationCubit:
        return _dependencyInjection.get<QuestionCreationCubit>().mapOrElse(
              errMap: (_) =>
                  Result<Manager, ManagerFactoryFailure>.ok(DummyManager()),
              okMap: Result<Manager, ManagerFactoryFailure>.ok,
            );
    }
  }
}

class DummyManager implements Manager {}

enum AvailableManagers {
  networkCubit,
  bottomNavigationCubit,
  assessmentsOverviewCubit,
  questionsOverviewCubit,
  questionCreationCubit,
}

abstract class ManagerFactoryFailure {}
