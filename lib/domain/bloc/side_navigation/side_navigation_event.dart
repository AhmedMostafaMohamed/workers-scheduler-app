part of 'side_navigation_bloc.dart';

abstract class SideNavigationEvent extends Equatable {
  const SideNavigationEvent();

  @override
  List<Object> get props => [];
}

class SelectNavigationItem extends SideNavigationEvent {
  final NavigationItem navigationItem;

  const SelectNavigationItem({required this.navigationItem});
  @override
  List<Object> get props => [navigationItem];
}
