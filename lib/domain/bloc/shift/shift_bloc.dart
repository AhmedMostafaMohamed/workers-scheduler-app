import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/shift.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/shift/shift_repository.dart';

part 'shift_event.dart';
part 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final ShiftRepository _shiftRepository;
  ShiftBloc({required ShiftRepository shiftRepository})
      : _shiftRepository = shiftRepository,
        super(ShiftInitial()) {
    on<FetchShiftsEvent>(_onFetchShiftsEvent);
    on<AddShiftEvent>(_onAddShiftEvent);
    on<DeleteShiftEvent>(_onDeleteShiftEvent);
    on<UpdateShiftEvent>(_onUpdateShiftEvent);
    on<ErrorShiftEvent>(_onErrorShiftEvent);
  }

  FutureOr<void> _onFetchShiftsEvent(
      FetchShiftsEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoadingState());
    try {
      final response = await _shiftRepository.getAllShifts(
          currentUserId: event.currentUser.role == Role.user
              ? event.currentUser.id
              : null);
      response.fold(
          (errorMessage) => emit(ShiftErrorState(errorMessage: errorMessage)),
          (shifts) => emit(ShiftsLoadedState(
              shifts: event.status == null
                  ? shifts
                  : getStatusShifts(shifts: shifts, status: event.status!))));
    } catch (e) {
      emit(ShiftErrorState(errorMessage: 'Error fetching shifts: $e'));
    }
  }

  FutureOr<void> _onAddShiftEvent(
      AddShiftEvent event, Emitter<ShiftState> emit) async {
    try {
      emit(ShiftLoadingState());
      final response = await _shiftRepository.addShift(event.shift);
      response.fold(
          (errorMessage) => emit(ShiftErrorState(errorMessage: errorMessage)),
          (addedInvoice) {
        emit(ShiftAddedState());
        add(FetchShiftsEvent(currentUser: event.currentUser));
      });
    } catch (e) {
      emit(ShiftErrorState(errorMessage: 'Error fetching shifts: $e'));
    }
  }

  FutureOr<void> _onDeleteShiftEvent(
      DeleteShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoadingState());
    try {
      final response = await _shiftRepository.deleteShift(event.shiftId);
      response.fold(
          (errorMessage) => emit(ShiftErrorState(errorMessage: errorMessage)),
          (deletedInvoiceId) {
        emit(ShiftDeletedState());
        add(FetchShiftsEvent(currentUser: event.currentUser));
      });
    } catch (e) {
      emit(ShiftErrorState(errorMessage: 'Error fetching shifts: $e'));
    }
  }

  FutureOr<void> _onUpdateShiftEvent(
      UpdateShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoadingState());
    try {
      final response = await _shiftRepository.updateShift(event.shift);
      response.fold(
          (errorMessage) => emit(ShiftErrorState(errorMessage: errorMessage)),
          (deletedInvoiceId) {
        emit(ShiftUpdatedState());
        add(FetchShiftsEvent(currentUser: event.currentUser));
      });
    } catch (e) {
      emit(ShiftErrorState(errorMessage: 'Error fetching shifts: $e'));
    }
  }

  FutureOr<void> _onErrorShiftEvent(
      ErrorShiftEvent event, Emitter<ShiftState> emit) {
    emit(ShiftErrorState(errorMessage: event.errorMessage));
  }

  List<Shift> getStatusShifts(
          {required Status status, required List<Shift> shifts}) =>
      shifts.where((shift) => shift.status == status).toList();
}
