part of 'bottom_navigation_cubit.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();
}

class BottomNavigationInitial extends BottomNavigationState {
  @override
  List<Object> get props => [];
}

class BottomNavigationIndexChangedState extends BottomNavigationState {
  const BottomNavigationIndexChangedState({
    this.previousIndex,
    required this.newIndex,
  });

  final int? previousIndex;
  final int newIndex;

  @override
  List<Object> get props {
    if (previousIndex != null) {
      return [newIndex, previousIndex!];
    }

    return [newIndex];
  }
}
