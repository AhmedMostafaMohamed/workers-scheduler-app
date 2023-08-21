import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../data/models/shift.dart';
import '../../data/models/shift_page_arguments.dart';
import '../../data/models/shifts_data_source.dart';
import '../../domain/bloc/shift/shift_bloc.dart';
import '../../domain/bloc/user/user_bloc.dart';
import 'appoinment_widget.dart';

class StatusShiftsSchedule extends StatelessWidget {
  final Status? requiredStatus;
  final CalendarView calendarView;

  const StatusShiftsSchedule(
      {super.key, this.requiredStatus, required this.calendarView});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftBloc, ShiftState>(
      bloc: BlocProvider.of(context)
        ..add(FetchShiftsEvent(
            currentUser: BlocProvider.of<UserBloc>(context).state.currentUser,
            status: requiredStatus)),
      listener: (context, state) {
        if (state is ShiftDeletedState) {
          debugPrint('shift deleted!!');

          var snackBar = const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text('Shift is deleted successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
        } else if (state is ShiftAddedState) {
          debugPrint('Shift is added!!');
          var snackBar2 = const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text('Shift is added successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
          Navigator.of(context).pop();
        } else if (state is ShiftUpdatedState) {
          debugPrint('updated!!');
          var snackBar2 = const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text('Shift is updated successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
          Navigator.of(context).pop();
        } else if (state is ShiftErrorState) {
          BlocProvider.of<ShiftBloc>(context).add(FetchShiftsEvent(
              currentUser:
                  BlocProvider.of<UserBloc>(context).state.currentUser));
          var snackBar2 = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            content: Text(state.errorMessage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        }
      },
      builder: (context, state) {
        if (state is ShiftLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ShiftsLoadedState) {
          return SfCalendar(
            dataSource: ShiftsDataSource(shifts: state.shifts),
            appointmentBuilder: calendarView != CalendarView.schedule
                ? (context, calendarAppointmentDetails) {
                    final List<dynamic> appointments =
                        calendarAppointmentDetails.appointments.toList();
                    final String appointmentTitle = appointments[0].userId;

                    return AppointmentWidget(
                      appointmentTitle: appointmentTitle,
                    );
                  }
                : null,
            view: calendarView,
            initialSelectedDate: DateTime.now(),
            onTap: (calendarTapDetails) {
              if (calendarTapDetails.targetElement ==
                  CalendarElement.appointment) {
                final Shift shift = calendarTapDetails.appointments!.first;
                Navigator.of(context).pushNamed('/shift-details',
                    arguments:
                        ShiftPageArgumets(shift: shift, date: shift.startHour));
              } else if (calendarTapDetails.targetElement ==
                      CalendarElement.calendarCell &&
                  calendarView != CalendarView.schedule) {
                Navigator.of(context).pushNamed('/shift-details',
                    arguments:
                        ShiftPageArgumets(date: calendarTapDetails.date!));
              }
            },
          );
        }
        return const Center(
          child: Text('unknown state'),
        );
      },
    );
  }
}
