import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/presentation/manager/manager.dart';
import 'package:quiz_lab/core/presentation/manager/manager_factory.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/questions_overview/questions_overview_cubit.dart';

void main() {
  late DummyDependencyInjection dummyDependencyInjection;
  late ManagerFactory factory;

  setUp(() {
    dummyDependencyInjection = DummyDependencyInjection();
    factory = ManagerFactory(dependencyInjection: dummyDependencyInjection);
  });

  tearDown(resetMocktailState);

  group('make', () {
    parameterizedTest(
      'should attempt to fetch from DI',
      ParameterizedSource.values([
        [
          AvailableManagers.networkCubit,
          (DependencyInjection di) => di.get<NetworkCubit>(),
          Result<NetworkCubit, DiFailure>.ok(FakeNetworkManager()),
        ],
        [
          AvailableManagers.bottomNavigationCubit,
          (DependencyInjection di) => di.get<BottomNavigationCubit>(),
          Result<BottomNavigationCubit, DiFailure>.ok(
            FakeBottomNavigationManager(),
          )
        ],
        [
          AvailableManagers.assessmentsOverviewCubit,
          (DependencyInjection di) => di.get<AssessmentsOverviewCubit>(),
          Result<AssessmentsOverviewCubit, DiFailure>.ok(
            FakeAssessmentsOverviewManager(),
          )
        ],
        [
          AvailableManagers.questionsOverviewCubit,
          (DependencyInjection di) => di.get<QuestionsOverviewCubit>(),
          Result<QuestionsOverviewCubit, DiFailure>.ok(
            FakeQuestionsOverviewManager(),
          )
        ],
        [
          AvailableManagers.questionCreationCubit,
          (DependencyInjection di) => di.get<QuestionCreationCubit>(),
          Result<QuestionCreationCubit, DiFailure>.ok(
            FakeQuestionCreationManager(),
          )
        ],
      ]),
      (List<dynamic> values) {
        final manager = values[0] as AvailableManagers;
        final expectedInstance =
            values[1] as dynamic Function(DependencyInjection);
        final diResult = values[2] as Result<Manager, DiFailure>;

        when(() => expectedInstance(dummyDependencyInjection))
            .thenReturn(diResult);

        final result = factory.make(desiredManager: manager);

        expect(result.isOk, true);

        final value = result.mapOr(fallback: null, okMap: (value) => value);
        expect(value, diResult.expect('Should be success'));
      },
    );

    parameterizedTest(
      'should attempt to fetch from DI',
      ParameterizedSource.values([
        [
          AvailableManagers.networkCubit,
          (DependencyInjection di) => di.get<NetworkCubit>(),
          Result<NetworkCubit, DiFailure>.ok(FakeNetworkManager()),
        ],
        [
          AvailableManagers.bottomNavigationCubit,
          (DependencyInjection di) => di.get<BottomNavigationCubit>(),
          Result<BottomNavigationCubit, DiFailure>.ok(
            FakeBottomNavigationManager(),
          )
        ],
        [
          AvailableManagers.assessmentsOverviewCubit,
          (DependencyInjection di) => di.get<AssessmentsOverviewCubit>(),
          Result<AssessmentsOverviewCubit, DiFailure>.ok(
            FakeAssessmentsOverviewManager(),
          )
        ],
        [
          AvailableManagers.questionsOverviewCubit,
          (DependencyInjection di) => di.get<QuestionsOverviewCubit>(),
          Result<QuestionsOverviewCubit, DiFailure>.ok(
            FakeQuestionsOverviewManager(),
          )
        ],
        [
          AvailableManagers.questionCreationCubit,
          (DependencyInjection di) => di.get<QuestionCreationCubit>(),
          Result<QuestionCreationCubit, DiFailure>.ok(
            FakeQuestionCreationManager(),
          )
        ],
      ]),
      (List<dynamic> values) {
        final manager = values[0] as AvailableManagers;
        final expectedInstance =
            values[1] as dynamic Function(DependencyInjection);
        final diResult = values[2] as Result<Manager, DiFailure>;

        when(() => expectedInstance(dummyDependencyInjection))
            .thenReturn(diResult);

        final result = factory.make(desiredManager: manager);

        expect(result.isOk, true);

        final value = result.mapOr(fallback: null, okMap: (value) => value);
        expect(value, diResult.expect('Should be success'));
      },
    );
  });
}

class DummyDependencyInjection extends Mock implements DependencyInjection {}

class FakeNetworkManager extends Fake implements NetworkCubit {}

class FakeBottomNavigationManager extends Fake
    implements BottomNavigationCubit {}

class FakeAssessmentsOverviewManager extends Fake
    implements AssessmentsOverviewCubit {}

class FakeQuestionsOverviewManager extends Fake
    implements QuestionsOverviewCubit {}

class FakeQuestionCreationManager extends Fake
    implements QuestionCreationCubit {}
