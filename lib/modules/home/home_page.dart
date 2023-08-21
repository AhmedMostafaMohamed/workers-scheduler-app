import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workers_scheduler/data/models/shift.dart';
import 'package:workers_scheduler/domain/bloc/side_navigation/side_navigation_bloc.dart';
import '../../data/models/shift_page_arguments.dart';
import '../../shared/components/side_navigation_bar.dart';
import '../../shared/components/status_shifts_schedule.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: BlocBuilder<SideNavigationBloc, SideNavigationState>(
        builder: (context, state) {
          switch (state.currentItemDestination) {
            case NavigationItem.availablity:
              return const Text('Available times');
            case NavigationItem.compeletedShifts:
              return const Text('Completed shifts');
            case NavigationItem.upcomingShifts:
              return const Text('My upcoming shifts');
          }
        },
      )),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : SizedBox(
              width: 200,
              child: SideNavigationBar(
                  navigationBloc: BlocProvider.of<SideNavigationBloc>(context)),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/shift-details',
                arguments: ShiftPageArgumets(date: DateTime.now()));
          },
          child: const Icon(Icons.add)),
      body: Row(
        children: [
          MediaQuery.of(context).size.width > 600
              ? SizedBox(
                  width: 200,
                  child: SideNavigationBar(
                      navigationBloc:
                          BlocProvider.of<SideNavigationBloc>(context)),
                )
              : Container(),
          BlocBuilder<SideNavigationBloc, SideNavigationState>(
            bloc: BlocProvider.of(context)
              ..add(const SelectNavigationItem(
                  navigationItem: NavigationItem.availablity)),
            builder: (context, state) {
              return Flexible(child: _buildScreen(context));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(BuildContext context) {
    final currentItem = BlocProvider.of<SideNavigationBloc>(context)
        .state
        .currentItemDestination;
    switch (currentItem) {
      case NavigationItem.availablity:
        return const StatusShiftsSchedule(
          calendarView: CalendarView.week,
        );
      case NavigationItem.compeletedShifts:
        return const StatusShiftsSchedule(
          requiredStatus: Status.completed,
          calendarView: CalendarView.schedule,
        );
      case NavigationItem.upcomingShifts:
        return const StatusShiftsSchedule(
          requiredStatus: Status.assigned,
          calendarView: CalendarView.schedule,
        );
    }
  }
}
