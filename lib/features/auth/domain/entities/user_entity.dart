import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String fullName;
  final String email;
  final String employeeId;
  final String role;
  final String assignedGroup;
  final String assignedBus;
  final int completionScore;
  final String token;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.employeeId,
    required this.role,
    required this.assignedGroup,
    required this.assignedBus,
    required this.completionScore,
    required this.token,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        employeeId,
        role,
        assignedGroup,
        assignedBus,
        completionScore,
        token,
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
