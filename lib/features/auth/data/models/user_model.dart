import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.fullName,
    required super.email,
    required super.employeeId,
    super.phoneNumber = '',
    required super.role,
    super.assignedGroup = 'Orange Executives',
    super.assignedBus = 'Executive VIP Bus',
    super.completionScore = 100,
    required super.token,
    super.dataNoticeAccepted = false,
    super.mediaConsentGranted = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId']?.toString() ?? json['id']?.toString() ?? '0') ?? 0,
      fullName: json['fullName'] as String? ?? json['FullName'] as String? ?? '',
      email: json['email'] as String? ?? json['Email'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? json['EmployeeId'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? json['PhoneNumber'] as String? ?? '',
      role: json['role'] as String? ?? json['Role'] as String? ?? 'Participant',
      assignedGroup: json['assignedGroup'] as String? ?? json['AssignedGroup'] as String? ?? 'Orange Executives',
      assignedBus: json['assignedBus'] as String? ?? json['AssignedBus'] as String? ?? 'Executive VIP Bus',
      completionScore: json['completionScore'] is int
          ? json['completionScore']
          : int.tryParse(json['completionScore']?.toString() ?? '100') ?? 100,
      token: json['token'] as String? ?? json['Token'] as String? ?? '',
      dataNoticeAccepted: json['dataNoticeAccepted'] as bool? ?? json['DataNoticeAccepted'] as bool? ?? false,
      mediaConsentGranted: json['mediaConsentGranted'] as bool? ?? json['MediaConsentGranted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'employeeId': employeeId,
      'phoneNumber': phoneNumber,
      'role': role,
      'assignedGroup': assignedGroup,
      'assignedBus': assignedBus,
      'completionScore': completionScore,
      'token': token,
      'dataNoticeAccepted': dataNoticeAccepted,
      'mediaConsentGranted': mediaConsentGranted,
    };
  }
}

class EligibilityModel extends EligibilityEntity {
  const EligibilityModel({
    required super.eligible,
    required super.fullName,
    required super.email,
    required super.hasPassword,
  });

  factory EligibilityModel.fromJson(Map<String, dynamic> json) {
    return EligibilityModel(
      eligible: json['eligible'] as bool? ?? false,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      hasPassword: json['hasPassword'] as bool? ?? false,
    );
  }
}
