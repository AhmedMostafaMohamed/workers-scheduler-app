import 'package:dartz/dartz.dart';
import 'package:workers_scheduler/data/models/shift.dart';

typedef EitherShift<T> = Future<Either<String, T>>;

abstract class BaseShiftRepository {
  EitherShift<List<Shift>> getAllShifts({String? currentUserId});
  Future<void> addShift(Shift shift);
  Future<void> deleteShift(String shiftId);
  EitherShift<Shift> updateShift(Shift shift);
}
