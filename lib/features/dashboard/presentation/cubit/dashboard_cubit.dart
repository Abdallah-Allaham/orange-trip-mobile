import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/dashboard_data_entity.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;
  final DashboardRepository repository;
  Timer? _countdownTimer;

  // The official trip launch departure: 2 Nov 2026, 09:30 AM (AMM -> CAI RJ 501)
  static final DateTime tripDepartureDateTime = DateTime(2026, 11, 2, 9, 30);

  DashboardCubit({
    required this.getDashboardDataUseCase,
    required this.repository,
  }) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final data = await getDashboardDataUseCase();
      _startCountdownTimer(data);
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> acknowledgeAnnouncement(int id) async {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      final updatedAnnouncements = current.data.announcements.map((a) {
        if (a.id == id) {
          return a.copyWith(isAcknowledged: true);
        }
        return a;
      }).toList();

      emit(current.copyWith(
        data: current.data.copyWith(announcements: updatedAnnouncements),
      ));

      try {
        await repository.acknowledgeAnnouncement(id);
      } catch (_) {
        // Optimistic UI state retained for responsiveness
      }
    }
  }

  Future<void> toggleBiometrics(bool enabled) async {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      emit(current.copyWith(
        data: current.data.copyWith(isBiometricsEnabled: enabled),
      ));

      try {
        await repository.setBiometricsEnabled(enabled);
      } catch (_) {}
    }
  }

  Future<void> refreshDashboard() async {
    try {
      final data = await getDashboardDataUseCase();
      if (state is DashboardLoaded) {
        final current = state as DashboardLoaded;
        emit(current.copyWith(data: data));
      } else {
        _startCountdownTimer(data);
      }
    } catch (e) {
      if (state is! DashboardLoaded) {
        emit(DashboardError(e.toString()));
      }
    }
  }

  void _startCountdownTimer(DashboardDataEntity data) {
    _countdownTimer?.cancel();

    emit(DashboardLoaded(
      data: data,
      tripCountdown: _calculateTripCountdown(),
      nextActivityCountdown: _calculateNextHourCountdown(),
    ));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is DashboardLoaded) {
        final current = state as DashboardLoaded;
        emit(current.copyWith(
          tripCountdown: _calculateTripCountdown(),
          nextActivityCountdown: _calculateNextHourCountdown(),
        ));
      }
    });
  }

  Duration _calculateTripCountdown() {
    final now = DateTime.now();
    final diff = tripDepartureDateTime.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  Duration _calculateNextHourCountdown() {
    // Dynamic countdown for upcoming activity window ("شو في عنا كمان ساعة")
    final now = DateTime.now();
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0);
    final diff = nextHour.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
