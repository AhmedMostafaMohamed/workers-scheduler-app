import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workers_scheduler/data/models/shift.dart';
import 'package:workers_scheduler/data/models/user.dart';
import 'package:workers_scheduler/domain/bloc/shift/shift_bloc.dart';
import 'package:workers_scheduler/domain/bloc/user/user_bloc.dart';

import '../../shared/components/confirm_dialog.dart';
import 'components/save_button.dart';
import 'components/status_indicator.dart';

class ShiftEditingPage extends StatefulWidget {
  final DateTime date;
  final Shift? shift;

  const ShiftEditingPage({super.key, required this.date, this.shift});

  @override
  _ShiftEditingPageState createState() => _ShiftEditingPageState();
}

class _ShiftEditingPageState extends State<ShiftEditingPage> {
  late TextEditingController _descriptionController;
  late bool _isAllDay;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _descriptionController.text = widget.shift?.description ?? '';
    _isAllDay = widget.shift?.isAllDay ??
        false; // Use the existing shift's isAllDay value if available
    _startTime = TimeOfDay(
        hour: widget.shift?.startHour.hour ?? widget.date.hour,
        minute: widget.shift?.startHour.minute ??
            0); // Use the existing shift's startHour value if available, otherwise use the current date's hour
    _endTime = TimeOfDay(
        hour: widget.shift?.endHour.hour ?? 17,
        minute: widget.shift?.endHour.minute ??
            0); // Use the existing shift's endHour value if available, otherwise use a default value of 17:00
    currentUser = BlocProvider.of<UserBloc>(context).state.currentUser;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _deleteShift() {
    if (widget.shift != null) {
      BlocProvider.of<ShiftBloc>(context).add(DeleteShiftEvent(
          shiftId: widget.shift!.id, currentUser: currentUser));
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message:
              'Are you sure you want to delete this item? This action cannot be undone.',
          onConfirm: () {
            // Confirm button pressed
            // Perform actions here
            _deleteShift();
            Navigator.pop(context); // Close the dialog
          },
          onCancel: () {
            // Cancel button pressed
            Navigator.pop(context); // Close the dialog
          },
        );
      },
    );
  }

  void _saveShift(Status status) {
    DateTime startDateTime;
    DateTime endDateTime;
    Shift shift;

    if (!_isAllDay) {
      startDateTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        _startTime.hour,
        _startTime.minute,
      );
      endDateTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        _endTime.hour,
        _endTime.minute,
      );
    } else {
      startDateTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        9,
        0,
      );
      endDateTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        17,
        0,
      );
    }
    String userId = BlocProvider.of<UserBloc>(context).state.currentUser.id;
    shift = Shift(
      status: status,
      id: widget.shift?.id ?? '0',
      startHour: startDateTime,
      endHour: endDateTime,
      isAllDay: _isAllDay,
      userId: widget.shift == null ? userId : widget.shift!.userId,
      description: _descriptionController.text,
    );

    if (_isAllDay || startDateTime.isBefore(endDateTime)) {
      if (widget.shift == null) {
        BlocProvider.of<ShiftBloc>(context)
            .add(AddShiftEvent(shift: shift, currentUser: currentUser));
      } else {
        BlocProvider.of<ShiftBloc>(context)
            .add(UpdateShiftEvent(shift: shift, currentUser: currentUser));
      }
    } else {
      BlocProvider.of<ShiftBloc>(context).add(const ErrorShiftEvent(
          errorMessage:
              'Please make sure that the start time is before the end time.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Edit Shift'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Start Time',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed:
                        !_isAllDay ? () => _selectStartTime(context) : null,
                    child: Text(
                      _startTime.format(context),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'End Time',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed:
                        !_isAllDay ? () => _selectEndTime(context) : null,
                    child: Text(
                      _endTime.format(context),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'All Day',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Checkbox(
                    value: _isAllDay,
                    onChanged: (value) {
                      setState(() {
                        _isAllDay = value ?? false;
                      });
                    },
                  ),
                  const Text('All Day'),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Description (Optional)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter description...',
                ),
              ),
              const SizedBox(height: 16.0),
              StatusSaveButton(
                title: 'Save',
                icon: Icons.save,
                onPressed: () {
                  _saveShift(Status.unassigned);
                },
              ),
              const SizedBox(height: 16.0),
              StatusSaveButton(
                title: 'Delete',
                icon: Icons.delete,
                onPressed: _showConfirmationDialog,
              ),
              const SizedBox(height: 16.0),
              if (widget.shift != null) buildButton(widget.shift!.status),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(Status status) {
    switch (status) {
      case Status.unassigned:
        return currentUser.role == Role.admin
            ? StatusSaveButton(
                title: 'Assign shift',
                icon: Icons.assignment_add,
                onPressed: () {
                  _saveShift(Status.assigned);
                },
              )
            : Container();
      case Status.assigned:
        return currentUser.id == widget.shift!.userId
            ? StatusSaveButton(
                title: 'mark this shift as done',
                icon: Icons.done_all,
                onPressed: () {
                  _saveShift(Status.pending);
                },
              )
            : Container();
      case Status.pending:
        return currentUser.role == Role.admin
            ? StatusSaveButton(
                icon: Icons.admin_panel_settings,
                title: 'Admin approve',
                onPressed: () {
                  _saveShift(Status.completed);
                },
              )
            : const StatusIndicator(
                color: Colors.yellow,
                icon: Icons.pending,
                title: 'pending',
              );
      case Status.completed:
        return const StatusIndicator(
          color: Colors.green,
          icon: Icons.done_all,
          title: 'completed',
        );
    }
  }
}
