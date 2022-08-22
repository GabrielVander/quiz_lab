import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/manager/bottom_navigation/bottom_navigation_cubit.dart';

void main() {
  late BottomNavigationCubit cubit;

  setUp(() {
    cubit = BottomNavigationCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state', () {
    expect(
      cubit.state,
      const BottomNavigationIndexChangedState(
        newIndex: NavigationIndex.assessments,
      ),
    );
  });
  group('transitionTo', () {
    group('emits correct state', () {
      <NavigationIndex, BottomNavigationIndexChangedState>{
        NavigationIndex.assessments: const BottomNavigationIndexChangedState(
          newIndex: NavigationIndex.assessments,
        ),
        NavigationIndex.questions: const BottomNavigationIndexChangedState(
          newIndex: NavigationIndex.questions,
        ),
        NavigationIndex.results: const BottomNavigationIndexChangedState(
          newIndex: NavigationIndex.results,
        ),
      }.forEach((key, value) {
        test('$key -> $value', () {
          expectLater(cubit.stream, emits(value));

          cubit
            ..transitionTo(newIndex: key)
            ..close();
        });
      });
    });
    group('emits in order', () {
      <List<NavigationIndex>, List<BottomNavigationIndexChangedState>>{
        [
          NavigationIndex.assessments,
          NavigationIndex.questions,
          NavigationIndex.results
        ]: [
          const BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.assessments,
          ),
          const BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.assessments,
            newIndex: NavigationIndex.questions,
          ),
          const BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions,
            newIndex: NavigationIndex.results,
          )
        ],
        [
          NavigationIndex.questions,
          NavigationIndex.assessments,
          NavigationIndex.results
        ]: [
          const BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.questions,
          ),
          const BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions,
            newIndex: NavigationIndex.assessments,
          ),
          const BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.assessments,
            newIndex: NavigationIndex.results,
          )
        ],
        [
          NavigationIndex.results,
          NavigationIndex.questions,
          NavigationIndex.assessments
        ]: [
          const BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.results,
          ),
          const BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.results,
            newIndex: NavigationIndex.questions,
          ),
          const BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions,
            newIndex: NavigationIndex.assessments,
          )
        ]
      }.forEach((List<NavigationIndex> indexes, value) {
        test('$indexes -> $value', () {
          expectLater(cubit.stream, emitsInOrder(value));

          for (final i in indexes) {
            cubit.transitionTo(newIndex: i);
          }

          cubit.close();
        });
      });
    });
  });
}
