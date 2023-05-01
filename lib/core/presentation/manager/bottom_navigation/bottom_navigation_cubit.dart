import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/utils/routes.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationInitial());

  NavigationIndex? previousIndex;

  void transitionTo({required int newIndex}) {
    emit(
      BottomNavigationIndexChangedState(
        previousIndex: previousIndex?.indexNumber,
        newIndex: newIndex,
      ),
    );

    emit(BottomNavigationNavigateToRoute(route: _getRouteForIndex(newIndex)));

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

  Routes _getRouteForIndex(int newIndex) {
    switch (newIndex) {
      case 0:
        return Routes.assessments;
      case 1:
        return Routes.questionsOverview;
      case 2:
        return Routes.resultsOverview;
      default:
        return Routes.assessments;
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
