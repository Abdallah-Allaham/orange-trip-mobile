import '../../domain/entities/bus_entity.dart';

class BusModel extends BusEntity {
  const BusModel({
    required super.id,
    required super.busNumber,
    required super.busNameEn,
    required super.busNameAr,
    required super.driverName,
    required super.driverPhone,
    required super.coordinatorName,
    required super.coordinatorPhone,
    required super.gatheringPointEn,
    required super.gatheringPointAr,
    required super.gatheringTime,
    required super.departureTime,
    super.capacity = 35,
    super.assignedGroup = '',
    super.status = 'On Schedule',
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      busNumber: json['busNumber']?.toString() ?? json['BusNumber']?.toString() ?? '',
      busNameEn: json['busNameEn']?.toString() ?? json['BusNameEn']?.toString() ?? '',
      busNameAr: json['busNameAr']?.toString() ?? json['BusNameAr']?.toString() ?? '',
      driverName: json['driverName']?.toString() ?? json['DriverName']?.toString() ?? '',
      driverPhone: json['driverPhone']?.toString() ?? json['DriverPhone']?.toString() ?? '',
      coordinatorName: json['coordinatorName']?.toString() ?? json['CoordinatorName']?.toString() ?? '',
      coordinatorPhone: json['coordinatorPhone']?.toString() ?? json['CoordinatorPhone']?.toString() ?? '',
      gatheringPointEn: json['gatheringPointEn']?.toString() ?? json['GatheringPointEn']?.toString() ?? '',
      gatheringPointAr: json['gatheringPointAr']?.toString() ?? json['GatheringPointAr']?.toString() ?? '',
      gatheringTime: json['gatheringTime']?.toString() ?? json['GatheringTime']?.toString() ?? '',
      departureTime: json['departureTime']?.toString() ?? json['DepartureTime']?.toString() ?? '',
      capacity: json['capacity'] is int ? json['capacity'] : int.tryParse(json['capacity']?.toString() ?? '35') ?? 35,
      assignedGroup: json['assignedGroup']?.toString() ?? json['AssignedGroup']?.toString() ?? '',
      status: json['status']?.toString() ?? json['Status']?.toString() ?? 'On Schedule',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busNumber': busNumber,
      'busNameEn': busNameEn,
      'busNameAr': busNameAr,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'coordinatorName': coordinatorName,
      'coordinatorPhone': coordinatorPhone,
      'gatheringPointEn': gatheringPointEn,
      'gatheringPointAr': gatheringPointAr,
      'gatheringTime': gatheringTime,
      'departureTime': departureTime,
      'capacity': capacity,
      'assignedGroup': assignedGroup,
      'status': status,
    };
  }
}
