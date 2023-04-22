part of 'bottom_navigation_cubit.dart';

@immutable
abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

@immutable
class BottomNavigationInitial extends BottomNavigationState {}

@immutable
class BottomNavigationIndexChangedState extends BottomNavigationState {
  const BottomNavigationIndexChangedState({
    required this.newIndex,
    this.previousIndex,
  });

  final int? previousIndex;
  final int newIndex;

  @override
  List<Object> get props => [newIndex];
}

@immutable
class BottomNavigationNavigateToRoute extends BottomNavigationState {
  const BottomNavigationNavigateToRoute({
    required this.route,
  });

  final Routes route;

  @override
  List<Object> get props => [route];
}
