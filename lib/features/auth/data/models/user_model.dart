import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.fullName,
    required super.email,
    required super.employeeId,
    required super.role,
    required super.assignedGroup,
    required super.assignedBus,
    required super.completionScore,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] is int ? json['userId'] : int.tryParse(json['userId']?.toString() ?? '1') ?? 1,
      fullName: json['fullName'] as String? ?? 'VIP Director',
      email: json['email'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? 'DIR-001',
      role: json['role'] as String? ?? 'Participant',
      assignedGroup: json['assignedGroup'] as String? ?? 'Group A',
      assignedBus: json['assignedBus'] as String? ?? 'Bus 1',
      completionScore: json['completionScore'] is int
          ? json['completionScore']
          : int.tryParse(json['completionScore']?.toString() ?? '40') ?? 40,
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'employeeId': employeeId,
      'role': role,
      'assignedGroup': assignedGroup,
      'assignedBus': assignedBus,
      'completionScore': completionScore,
      'token': token,
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
      fullName: json['fullName'] as String? ?? 'VIP Director',
      email: json['email'] as String? ?? '',
      hasPassword: json['hasPassword'] as bool? ?? false,
    );
  }
}
