import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_data_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardDataEntity data;
  final Duration tripCountdown;
  final Duration nextActivityCountdown;

  const DashboardLoaded({
    required this.data,
    required this.tripCountdown,
    required this.nextActivityCountdown,
  });

  DashboardLoaded copyWith({
    DashboardDataEntity? data,
    Duration? tripCountdown,
    Duration? nextActivityCountdown,
  }) {
    return DashboardLoaded(
      data: data ?? this.data,
      tripCountdown: tripCountdown ?? this.tripCountdown,
      nextActivityCountdown: nextActivityCountdown ?? this.nextActivityCountdown,
    );
  }

  @override
  List<Object?> get props => [data, tripCountdown, nextActivityCountdown];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
