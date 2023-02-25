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

  BottomNavigationIndexChangedState copyWith({
    int? previousIndex,
    int? newIndex,
  }) {
    return BottomNavigationIndexChangedState(
      previousIndex: previousIndex ?? this.previousIndex,
      newIndex: newIndex ?? this.newIndex,
    );
  }

  @override
  List<Object> get props => [newIndex];
}
