import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'side_navigation_event.dart';
part 'side_navigation_state.dart';

class SideNavigationBloc
    extends Bloc<SideNavigationEvent, SideNavigationState> {
  SideNavigationBloc() : super(SideNavigationState.initial()) {
    on<SelectNavigationItem>(_onSelectNavigationItem);
  }

  FutureOr<void> _onSelectNavigationItem(
      SelectNavigationItem event, Emitter<SideNavigationState> emit) {
    emit(NavigationItemSelected(event.navigationItem));
  }
}
