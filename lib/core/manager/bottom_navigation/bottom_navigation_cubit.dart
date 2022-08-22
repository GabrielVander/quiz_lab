import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(
          const BottomNavigationIndexChangedState(
            newIndex: NavigationIndex.assessments,
          ),
        );

  NavigationIndex? previousIndex;

  void transitionTo({required NavigationIndex newIndex}) {
    emit(
      BottomNavigationIndexChangedState(
        previousIndex: previousIndex,
        newIndex: newIndex,
      ),
    );

    previousIndex = newIndex;
  }
}

enum NavigationIndex {
  assessments(indexNumber: 0),
  questions(indexNumber: 1),
  results(indexNumber: 2);

  const NavigationIndex({required this.indexNumber});

  final int indexNumber;
}
