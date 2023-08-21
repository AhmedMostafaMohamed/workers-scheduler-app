import 'package:equatable/equatable.dart';
import 'package:firedart/firestore/models.dart';

enum Status {
  unassigned,
  assigned,
  pending,
  completed,
}

class Shift extends Equatable {
  final String id;
  final String userId;
  final DateTime startHour;
  final DateTime endHour;
  final String description;
  final bool isAllDay;
  final Status status;

  const Shift({
    required this.startHour,
    required this.endHour,
    required this.userId,
    required this.status,
    this.description = '',
    this.id = '0',
    this.isAllDay = false,
  });

  factory Shift.empty() {
    return Shift(
        startHour: DateTime.now(),
        endHour: DateTime.now(),
        userId: 'empty',
        status: Status.unassigned);
  }

  @override
  List<Object?> get props =>
      [id, startHour, endHour, description, isAllDay, status];
  static Shift fromSnapshot(Document snap) {
    Status currentStatus = Status.unassigned;
    switch (snap['shift']['status']) {
      case 'unassigned':
        currentStatus = Status.unassigned;
        break;
      case 'pending':
        currentStatus = Status.pending;
        break;
      case 'completed':
        currentStatus = Status.completed;
        break;
      case 'assigned':
        currentStatus = Status.assigned;
        break;
      default:
        throw ArgumentError('Invalid status value: ${snap['shift']['status']}');
    }
    Shift shift = Shift(
      userId: snap['shift']['userId'],
      status: currentStatus,
      startHour:
          DateTime.fromMillisecondsSinceEpoch(snap['shift']['startHour']),
      endHour: DateTime.fromMillisecondsSinceEpoch(snap['shift']['endHour']),
      isAllDay: snap['shift']['allDay'],
      id: snap.id,
      description: snap['shift']['description'],
    );
    return shift;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startHour': startHour.millisecondsSinceEpoch,
      'endHour': endHour.millisecondsSinceEpoch,
      'description': description,
      'allDay': isAllDay,
      'userId': userId,
      'status': status.toString().split('.').last
    };
  }
}
