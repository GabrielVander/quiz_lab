import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/presentation/manager/manager.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState>
    implements Manager {
  BottomNavigationCubit()
      : super(
          BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.assessments.indexNumber,
          ),
        );

  NavigationIndex? previousIndex;

  void transitionTo({required int newIndex}) {
    emit(
      BottomNavigationIndexChangedState(
        previousIndex: previousIndex?.indexNumber,
        newIndex: newIndex,
      ),
    );

    previousIndex = _intAsNavIndex(newIndex);
  }

  NavigationIndex _intAsNavIndex(int numberIndex) {
    switch (numberIndex) {
      case 0:
        return NavigationIndex.assessments;
      case 1:
        return NavigationIndex.questions;
      case 2:
        return NavigationIndex.results;
      default:
        return NavigationIndex.assessments;
    }
  }
}

enum NavigationIndex {
  assessments(indexNumber: 0),
  questions(indexNumber: 1),
  results(indexNumber: 2);

  const NavigationIndex({required this.indexNumber});

  final int indexNumber;
}
