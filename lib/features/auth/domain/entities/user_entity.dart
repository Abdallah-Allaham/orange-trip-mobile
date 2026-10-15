import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String fullName;
  final String email;
  final String employeeId;
  final String phoneNumber;
  final String role;
  final String assignedGroup;
  final String assignedBus;
  final int completionScore;
  final String token;
  final bool dataNoticeAccepted;
  final bool mediaConsentGranted;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.employeeId,
    this.phoneNumber = '',
    required this.role,
    this.assignedGroup = 'Orange Executives',
    this.assignedBus = 'Executive VIP Bus',
    this.completionScore = 100,
    required this.token,
    this.dataNoticeAccepted = false,
    this.mediaConsentGranted = false,
  });

  UserEntity copyWith({
    int? userId,
    String? fullName,
    String? email,
    String? employeeId,
    String? phoneNumber,
    String? role,
    String? assignedGroup,
    String? assignedBus,
    int? completionScore,
    String? token,
    bool? dataNoticeAccepted,
    bool? mediaConsentGranted,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      employeeId: employeeId ?? this.employeeId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      assignedGroup: assignedGroup ?? this.assignedGroup,
      assignedBus: assignedBus ?? this.assignedBus,
      completionScore: completionScore ?? this.completionScore,
      token: token ?? this.token,
      dataNoticeAccepted: dataNoticeAccepted ?? this.dataNoticeAccepted,
      mediaConsentGranted: mediaConsentGranted ?? this.mediaConsentGranted,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        employeeId,
        phoneNumber,
        role,
        assignedGroup,
        assignedBus,
        completionScore,
        token,
        dataNoticeAccepted,
        mediaConsentGranted,
      ];
}

class EligibilityEntity extends Equatable {
  final bool eligible;
  final String fullName;
  final String email;
  final bool hasPassword;

  const EligibilityEntity({
    required this.eligible,
    required this.fullName,
    required this.email,
    required this.hasPassword,
  });

  @override
  List<Object?> get props => [eligible, fullName, email, hasPassword];
}
