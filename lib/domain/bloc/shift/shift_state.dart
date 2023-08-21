part of 'shift_bloc.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object> get props => [];
}

class ShiftInitial extends ShiftState {}

class ShiftLoadingState extends ShiftState {}

class ShiftDeletedState extends ShiftState {}

class ShiftAddedState extends ShiftState {}

class ShiftUpdatedState extends ShiftState {}

class ShiftsLoadedState extends ShiftState {
  final List<Shift> shifts;

  const ShiftsLoadedState({required this.shifts});
  @override
  List<Object> get props => [shifts];
}

class ShiftErrorState extends ShiftState {
  final String errorMessage;

  const ShiftErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
