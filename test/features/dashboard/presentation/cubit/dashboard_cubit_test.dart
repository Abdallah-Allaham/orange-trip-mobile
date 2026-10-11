import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/announcement_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/bus_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/dashboard_data_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/flight_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/hotel_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/itinerary_item_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/itinerary_summary_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/trip_settings_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:orange_trip_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:orange_trip_mobile/features/dashboard/presentation/cubit/dashboard_state.dart';

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<TripSettingsEntity> getActiveTrip() async {
    return const TripSettingsEntity(
      id: 1,
      tripCode: 'O-TRIP-2026',
      titleEn: 'O Trip Executive Portal',
      titleAr: 'بوابة تنظيم الرحلات التنفيذية',
      destinationCityEn: 'Cairo',
      destinationCityAr: 'القاهرة',
      destinationCountryEn: 'Egypt',
      destinationCountryAr: 'مصر',
      airportCode: 'CAI',
      startDate: '2026-11-02',
      endDate: '2026-11-05',
      hotelName: 'The St. Regis Cairo',
      hotelPhone: '+20 2 2597 9000',
      wifiPassword: 'OrangeCairo2026',
      flightCode: 'RJ 501',
      weatherTemp: '27°C',
      weatherConditionEn: 'Sunny & Pleasant',
      weatherConditionAr: 'مشمس ومعتدل',
      tripVersion: 1,
      isActive: true,
    );
  }

  @override
  Future<DashboardDataEntity> getDashboardData() async {
    return const DashboardDataEntity(
      flight: FlightEntity(flightNumberOutbound: 'RJ 501', flightNumberReturn: 'RJ 506'),
      hotel: HotelEntity(hotelName: 'The St. Regis Cairo'),
      itinerarySummary: ItinerarySummaryEntity(nextActivity: 'Welcome Dinner'),
      assignedBus: 'Bus 1 (Executive VIP)',
      assignedGroup: 'Group Alpha (VIP)',
      fullName: 'Ahmad Al-Momani',
      role: 'Director of Digital Transformation',
    );
  }

  @override
  Future<FlightEntity> getFlightDetails() async {
    return const FlightEntity(flightNumberOutbound: 'RJ 501');
  }

  @override
  Future<HotelEntity> getHotelDetails() async {
    return const HotelEntity(hotelName: 'The St. Regis Cairo');
  }

  @override
  Future<ItinerarySummaryEntity> getItinerarySummary() async {
    return const ItinerarySummaryEntity(nextActivity: 'Welcome Dinner');
  }

  @override
  Future<List<ItineraryItemEntity>> getItineraryItems() async => [];

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async => [];

  @override
  Future<List<BusEntity>> getBuses() async => [];

  @override
  Future<bool> acknowledgeAnnouncement(int id) async => true;

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {}

  @override
  Future<bool> isBiometricsEnabled() async => false;
}

void main() {
  late DashboardCubit cubit;
  late GetDashboardDataUseCase useCase;
  late MockDashboardRepository repository;

  setUp(() {
    repository = MockDashboardRepository();
    useCase = GetDashboardDataUseCase(repository);
    cubit = DashboardCubit(getDashboardDataUseCase: useCase, repository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be DashboardInitial', () {
    expect(cubit.state, isA<DashboardInitial>());
  });

  test('loadDashboard emits DashboardLoading then DashboardLoaded with data', () async {
    final expectedOrder = [
      isA<DashboardLoading>(),
      isA<DashboardLoaded>(),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedOrder));

    await cubit.loadDashboard();

    expect(cubit.state, isA<DashboardLoaded>());
    final loadedState = cubit.state as DashboardLoaded;
    expect(loadedState.data.flight.flightNumberOutbound, 'RJ 501');
    expect(loadedState.data.hotel.hotelName, 'The St. Regis Cairo');
    expect(loadedState.data.assignedBus, 'Bus 1 (Executive VIP)');
    expect(loadedState.data.assignedGroup, 'Group Alpha (VIP)');
    expect(loadedState.tripCountdown, isNotNull);
    expect(loadedState.nextActivityCountdown, isNotNull);
  });

  test('toggleBiometrics updates isBiometricsEnabled in state', () async {
    await cubit.loadDashboard();
    expect((cubit.state as DashboardLoaded).data.isBiometricsEnabled, false);

    await cubit.toggleBiometrics(true);
    expect((cubit.state as DashboardLoaded).data.isBiometricsEnabled, true);

    await cubit.toggleBiometrics(false);
    expect((cubit.state as DashboardLoaded).data.isBiometricsEnabled, false);
  });
}
