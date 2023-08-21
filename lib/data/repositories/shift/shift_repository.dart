import 'package:dartz/dartz.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/foundation.dart';
import 'package:workers_scheduler/data/models/shift.dart';
import 'package:workers_scheduler/data/repositories/shift/base_shift_repository.dart';

class ShiftRepository extends BaseShiftRepository {
  final CollectionReference _firebaseFirestore;
  ShiftRepository({CollectionReference? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ??
            Firestore('workersscheduler').collection('shifts');
  @override
  EitherShift<Shift> addShift(Shift shift) async {
    try {
      await _firebaseFirestore.add({'shift': shift.toMap()});
      return right(shift);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherShift<String> deleteShift(String shiftId) async {
    try {
      await _firebaseFirestore.document(shiftId).delete();
      return right(shiftId);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherShift<List<Shift>> getAllShifts({String? currentUserId}) async {
    List<Shift> shifts = [];
    List<Shift> userShifts = [];
    try {
      var snapshot = await _firebaseFirestore.get();
      shifts = snapshot.map((doc) => Shift.fromSnapshot(doc)).toList();
      if (currentUserId != null) {
        for (var shift in shifts) {
          if (shift.userId == currentUserId) {
            userShifts.add(shift);
          }
        }
        return right(userShifts);
      }

      return right(shifts);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherShift<Shift> updateShift(Shift shift) async {
    try {
      await _firebaseFirestore
          .document(shift.id)
          .update({'shift': shift.toMap()});
      return right(shift);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }
}
