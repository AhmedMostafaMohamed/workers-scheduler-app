part of 'side_navigation_bloc.dart';

enum NavigationItem {
  upcomingShifts,
  availablity,
  compeletedShifts,
}

class SideNavigationState extends Equatable {
  final NavigationItem currentItemDestination;
  const SideNavigationState({required this.currentItemDestination});
  factory SideNavigationState.initial() {
    return const SideNavigationState(
      currentItemDestination: NavigationItem.availablity,
    );
  }

  @override
  List<Object> get props => [currentItemDestination];
  SideNavigationState copyWith({
    NavigationItem? currentItemDestination,
  }) {
    return SideNavigationState(
      currentItemDestination:
          currentItemDestination ?? this.currentItemDestination,
    );
  }
}

class NavigationItemSelected extends SideNavigationState {
  final NavigationItem selectedItem;

  const NavigationItemSelected(this.selectedItem)
      : super(currentItemDestination: selectedItem);

  @override
  List<Object> get props => [selectedItem];
}
