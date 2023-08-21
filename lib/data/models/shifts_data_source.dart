import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workers_scheduler/data/models/shift.dart';

class ShiftsDataSource extends CalendarDataSource {
  ShiftsDataSource({required List<Shift> shifts}) {
    appointments = shifts;
  }
  Shift getShift(int index) => appointments![index] as Shift;
  @override
  DateTime getStartTime(int index) => getShift(index).startHour;
  @override
  DateTime getEndTime(int index) => getShift(index).endHour;
  @override
  bool isAllDay(int index) => getShift(index).isAllDay;
  @override
  String getSubject(int index) => 'User ID : ${getShift(index).userId}';
  @override
  Color getColor(int index) => Colors.deepPurple;
}
