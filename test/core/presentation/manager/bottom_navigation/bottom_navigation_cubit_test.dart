import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';

void main() {
  late BottomNavigationCubit cubit;

  setUp(() {
    cubit = BottomNavigationCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state', () {
    expect(cubit.state, BottomNavigationInitial());
  });

  group('transitionTo', () {
    group('emits correct state', () {
      <NavigationIndex, BottomNavigationIndexChangedState>{
        NavigationIndex.assessments: BottomNavigationIndexChangedState(
          newIndex: NavigationIndex.assessments.indexNumber,
        ),
        NavigationIndex.questions: BottomNavigationIndexChangedState(
          newIndex: NavigationIndex.questions.indexNumber,
        ),
        NavigationIndex.results: BottomNavigationIndexChangedState(
          newIndex: NavigationIndex.results.indexNumber,
        ),
      }.forEach((key, value) {
        test('$key -> $value', () {
          expectLater(cubit.stream, emits(value));

          cubit
            ..transitionTo(newIndex: key.indexNumber)
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
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.assessments.indexNumber,
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions.indexNumber,
            newIndex: NavigationIndex.results.indexNumber,
          )
        ],
        [
          NavigationIndex.questions,
          NavigationIndex.assessments,
          NavigationIndex.results
        ]: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions.indexNumber,
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.assessments.indexNumber,
            newIndex: NavigationIndex.results.indexNumber,
          )
        ],
        [
          NavigationIndex.results,
          NavigationIndex.questions,
          NavigationIndex.assessments
        ]: [
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.results.indexNumber,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.results.indexNumber,
            newIndex: NavigationIndex.questions.indexNumber,
          ),
          BottomNavigationIndexChangedState(
            previousIndex: NavigationIndex.questions.indexNumber,
            newIndex: NavigationIndex.assessments.indexNumber,
          )
        ]
      }.forEach((List<NavigationIndex> indexes, value) {
        test('$indexes -> $value', () {
          expectLater(cubit.stream, emitsInOrder(value));

          for (final i in indexes) {
            cubit.transitionTo(newIndex: i.indexNumber);
          }

          cubit.close();
        });
      });
    });
  });
}
