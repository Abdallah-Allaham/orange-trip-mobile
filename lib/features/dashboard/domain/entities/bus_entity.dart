import 'package:equatable/equatable.dart';

class BusEntity extends Equatable {
  final int id;
  final String busNumber;
  final String busNameEn;
  final String busNameAr;
  final String driverName;
  final String driverPhone;
  final String coordinatorName;
  final String coordinatorPhone;
  final String gatheringPointEn;
  final String gatheringPointAr;
  final String gatheringTime;
  final String departureTime;
  final int capacity;
  final String assignedGroup;
  final String status;

  const BusEntity({
    required this.id,
    required this.busNumber,
    required this.busNameEn,
    required this.busNameAr,
    required this.driverName,
    required this.driverPhone,
    required this.coordinatorName,
    required this.coordinatorPhone,
    required this.gatheringPointEn,
    required this.gatheringPointAr,
    required this.gatheringTime,
    required this.departureTime,
    this.capacity = 35,
    required this.assignedGroup,
    this.status = 'On Schedule',
  });

  @override
  List<Object?> get props => [
        id,
        busNumber,
        busNameEn,
        busNameAr,
        driverName,
        driverPhone,
        coordinatorName,
        coordinatorPhone,
        gatheringPointEn,
        gatheringPointAr,
        gatheringTime,
        departureTime,
        capacity,
        assignedGroup,
        status,
      ];
}
