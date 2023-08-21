part of 'shift_bloc.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();

  @override
  List<Object> get props => [];
}

class FetchShiftsEvent extends ShiftEvent {
  final User currentUser;
  final Status? status;

  const FetchShiftsEvent({required this.currentUser, this.status});
  @override
  List<Object> get props => [currentUser];
}

class AddShiftEvent extends ShiftEvent {
  final Shift shift;
  final User currentUser;

  const AddShiftEvent({required this.shift, required this.currentUser});
  @override
  List<Object> get props => [shift, currentUser];
}

class UpdateShiftEvent extends ShiftEvent {
  final Shift shift;
  final User currentUser;

  const UpdateShiftEvent({required this.shift, required this.currentUser});
  @override
  List<Object> get props => [shift, currentUser];
}

class DeleteShiftEvent extends ShiftEvent {
  final String shiftId;
  final User currentUser;

  const DeleteShiftEvent({required this.shiftId, required this.currentUser});
  @override
  List<Object> get props => [shiftId, currentUser];
}

class ErrorShiftEvent extends ShiftEvent {
  final String errorMessage;

  const ErrorShiftEvent({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
