import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';

void main() {
  late BottomNavigationCubit cubit;

  setUp(() {
    cubit = BottomNavigationCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state', () {
    expect(cubit.state, BottomNavigationInitial());
  });

  group('transitionTo', () {
    group('emits correct state', () {
      <NavigationIndex, List<BottomNavigationState>>{
        NavigationIndex.assessments: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.assessments),
        ],
        NavigationIndex.questions: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(
            route: Routes.questionsOverview,
          ),
        ],
        NavigationIndex.results: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.results.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.resultsOverview),
        ],
      }.forEach((key, value) {
        test('$key -> $value', () async {
          unawaited(expectLater(cubit.stream, emitsInAnyOrder(value)));

          cubit.transitionTo(newIndex: key.indexNumber);
          await cubit.close();
        });
      });
    });

    group('emits in order', () {
      <List<NavigationIndex>, List<BottomNavigationState>>{
        [NavigationIndex.assessments, NavigationIndex.questions, NavigationIndex.results]: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.assessments),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.assessments.indexNumber,
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(
            route: Routes.questionsOverview,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions.indexNumber,
            newIndex: NavigationIndex.results.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.resultsOverview),
        ],
        [NavigationIndex.questions, NavigationIndex.assessments, NavigationIndex.results]: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(
            route: Routes.questionsOverview,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions.indexNumber,
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.assessments),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.assessments.indexNumber,
            newIndex: NavigationIndex.results.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.resultsOverview),
        ],
        [NavigationIndex.results, NavigationIndex.questions, NavigationIndex.assessments]: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.results.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.resultsOverview),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.results.indexNumber,
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(
            route: Routes.questionsOverview,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions.indexNumber,
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
          const BottomNavigationNavigateToRoute(route: Routes.assessments),
        ],
      }.forEach((List<NavigationIndex> indexes, value) {
        test('$indexes -> $value', () async {
          unawaited(expectLater(cubit.stream, emitsInOrder(value)));

          for (final i in indexes) {
            cubit.transitionTo(newIndex: i.indexNumber);
          }

          await cubit.close();
        });
      });
    });
  });
}
