import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  final bool canUseBiometrics;
  final String? lastEmail;

  const Unauthenticated({this.canUseBiometrics = false, this.lastEmail});

  @override
  List<Object?> get props => [canUseBiometrics, lastEmail];
}

class EligibilityCheckedState extends AuthState {
  final EligibilityEntity eligibility;

  const EligibilityCheckedState(this.eligibility);

  @override
  List<Object?> get props => [eligibility];
}

class PasswordSetSuccessState extends AuthState {
  final UserEntity user;
  final String message;

  const PasswordSetSuccessState(this.user, this.message);

  @override
  List<Object?> get props => [user, message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
