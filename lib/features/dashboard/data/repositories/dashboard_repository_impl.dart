import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/entities/bus_entity.dart';
import '../../domain/entities/dashboard_data_entity.dart';
import '../../domain/entities/emergency_contact_entity.dart';
import '../../domain/entities/flight_entity.dart';
import '../../domain/entities/hotel_entity.dart';
import '../../domain/entities/itinerary_item_entity.dart';
import '../../domain/entities/itinerary_summary_entity.dart';
import '../../domain/entities/trip_settings_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/announcement_model.dart';
import '../models/bus_model.dart';
import '../models/emergency_contact_model.dart';
import '../models/flight_model.dart';
import '../models/hotel_model.dart';
import '../models/itinerary_item_model.dart';
import '../models/itinerary_summary_model.dart';
import '../models/trip_settings_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<TripSettingsEntity> getActiveTrip() async {
    try {
      final trip = await remoteDataSource.getActiveTrip();
      await storageService.saveCachedJson('active_trip', trip.toJson());
      return trip;
    } catch (_) {
      final cached = await storageService.getCachedJson('active_trip');
      if (cached is Map<String, dynamic>) {
        return TripSettingsModel.fromJson(cached);
      }
      return TripSettingsModel.defaultSettings;
    }
  }

  @override
  Future<FlightEntity> getFlightDetails() async {
    try {
      final flight = await remoteDataSource.getFlight();
      await storageService.saveCachedJson('flight', flight.toJson());
      return flight;
    } catch (_) {
      final cached = await storageService.getCachedJson('flight');
      if (cached is Map<String, dynamic>) {
        return FlightModel.fromJson(cached);
      }
      return const FlightModel(
        airline: 'Royal Jordanian',
        flightNumberOutbound: '',
        outboundRoute: 'Amman (AMM) → Cairo (CAI)',
        outboundDepartureTime: '2026-11-02 09:30',
        outboundArrivalTime: '2026-11-02 10:55',
        outboundAirport: 'Queen Alia International Airport',
        flightNumberReturn: 'RJ 506',
        returnRoute: 'Cairo (CAI) → Amman (AMM)',
        returnDepartureTime: '2026-11-05 19:00',
        returnArrivalTime: '2026-11-05 21:15',
        returnAirport: 'Cairo International Airport',
      );
    }
  }

  @override
  Future<HotelEntity> getHotelDetails() async {
    try {
      final hotel = await remoteDataSource.getHotel();
      await storageService.saveCachedJson('hotel', hotel.toJson());
      return hotel;
    } catch (_) {
      final cached = await storageService.getCachedJson('hotel');
      if (cached is Map<String, dynamic>) {
        return HotelModel.fromJson(cached);
      }
      return const HotelModel(
        hotelName: '',
        hotelPhone: '+20 2 2597 9000',
        hotelReceptionContact: 'Dial 0 from room',
        emergencyContact: '+20 100 000 9999',
        checkInDate: '2 Nov 2026, 14:00',
        checkOutDate: '5 Nov 2026, 12:00',
        roomNumber: 'Assigned upon arrival',
        roomCategory: 'Deluxe King Room',
        wifiNetwork: 'StRegis_Guest',
        wifiPassword: '',
        wifiInstructions: 'Network: StRegis_Guest',
        operationalNotes: 'Keycards available at Orange Welcome Desk in lobby.',
      );
    }
  }

  @override
  Future<ItinerarySummaryEntity> getItinerarySummary() async {
    try {
      final summary = await remoteDataSource.getItinerarySummary();
      await storageService.saveCachedJson('itinerary_summary', summary.toJson());
      return summary;
    } catch (_) {
      final cached = await storageService.getCachedJson('itinerary_summary');
      if (cached is Map<String, dynamic>) {
        return ItinerarySummaryModel.fromJson(cached);
      }
      return const ItinerarySummaryModel(
        nextActivity: '',
        nextActivityAr: '',
        nextActivityTime: '',
        gatheringPoint: '',
        gatheringPointAr: '',
        gatheringTime: '',
        dressCode: '',
        dressCodeAr: '',
        weatherCity: 'Cairo',
        weatherTemp: '27°C',
        weatherCondition: 'Warm / Sunny',
        tripStatus: 'Upcoming',
        countdownDays: 0,
      );
    }
  }

  @override
  Future<List<ItineraryItemEntity>> getItineraryItems() async {
    try {
      final items = await remoteDataSource.getItineraryItems();
      if (items.isNotEmpty) {
        await storageService.saveCachedJson(
          'itinerary_items',
          items.map((i) => i.toJson()).toList(),
        );
        return items;
      }
    } catch (_) {}

    final cached = await storageService.getCachedJson('itinerary_items');
    if (cached is List && cached.isNotEmpty) {
      try {
        return cached
            .map((i) => ItineraryItemModel.fromJson(i as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async {
    try {
      final list = await remoteDataSource.getAnnouncements();
      if (list.isNotEmpty) {
        await storageService.saveCachedJson(
          'announcements',
          list.map((a) => a.toJson()).toList(),
        );
        return list;
      }
    } catch (_) {}

    final cached = await storageService.getCachedJson('announcements');
    if (cached is List && cached.isNotEmpty) {
      try {
        return cached
            .map((a) => AnnouncementModel.fromJson(a as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<List<BusEntity>> getBuses() async {
    try {
      final list = await remoteDataSource.getBuses();
      if (list.isNotEmpty) {
        await storageService.saveCachedJson(
          'buses',
          list.map((b) => b.toJson()).toList(),
        );
        return list;
      }
    } catch (_) {}

    final cached = await storageService.getCachedJson('buses');
    if (cached is List && cached.isNotEmpty) {
      try {
        return cached
            .map((b) => BusModel.fromJson(b as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<List<EmergencyContactEntity>> getEmergencyContacts() async {
    try {
      final list = await remoteDataSource.getEmergencyContacts();
      if (list.isNotEmpty) {
        await storageService.saveCachedJson(
          'emergency_contacts',
          list.map((e) => e.toJson()).toList(),
        );
        return list;
      }
    } catch (_) {}

    final cached = await storageService.getCachedJson('emergency_contacts');
    if (cached is List && cached.isNotEmpty) {
      try {
        return cached
            .map((e) => EmergencyContactModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    return [];
  }

  @override
  Future<bool> updateConsent({required bool dataNoticeAccepted, required bool mediaConsentGranted}) async {
    final success = await remoteDataSource.updateConsent(
      dataNoticeAccepted: dataNoticeAccepted,
      mediaConsentGranted: mediaConsentGranted,
    );
    if (success) {
      final user = await storageService.getUserData();
      if (user != null) {
        user['dataNoticeAccepted'] = dataNoticeAccepted;
        user['mediaConsentGranted'] = mediaConsentGranted;
        await storageService.saveUserData(user);
      }
    }
    return success;
  }

  @override
  Future<bool> acknowledgeAnnouncement(int id) async {
    return await remoteDataSource.acknowledgeAnnouncement(id);
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await storageService.setBiometricsEnabled(enabled);
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    return await storageService.isBiometricsEnabled();
  }

  @override
  Future<DashboardDataEntity> getDashboardData() async {
    final results = await Future.wait([
      getActiveTrip(),
      getFlightDetails(),
      getHotelDetails(),
      getItinerarySummary(),
      getItineraryItems(),
      getAnnouncements(),
      remoteDataSource.getProfile(),
      storageService.getUserData(),
      isBiometricsEnabled(),
      getBuses(),
      getEmergencyContacts(),
    ]);

    final tripSettings = results[0] as TripSettingsEntity;
    final flight = results[1] as FlightEntity;
    final hotel = results[2] as HotelEntity;
    final summary = results[3] as ItinerarySummaryEntity;
    final allItems = results[4] as List<ItineraryItemEntity>;
    final announcements = results[5] as List<AnnouncementEntity>;
    final profileMap = results[6] as Map<String, dynamic>?;
    final cachedUserMap = results[7] as Map<String, dynamic>?;
    final biometricsEnabled = results[8] as bool;
    final buses = results[9] as List<BusEntity>;
    final emergencyContacts = results[10] as List<EmergencyContactEntity>;

    final assignedBus = profileMap?['assignedBus'] ??
        profileMap?['AssignedBus'] ??
        cachedUserMap?['assignedBus'] ??
        'Executive VIP Bus';

    final assignedGroup = profileMap?['assignedGroup'] ??
        profileMap?['AssignedGroup'] ??
        cachedUserMap?['assignedGroup'] ??
        'Orange Executives';

    final fullName = profileMap?['fullName'] ??
        profileMap?['FullName'] ??
        cachedUserMap?['fullName'] ??
        '';

    final role = profileMap?['title'] ??
        profileMap?['role'] ??
        cachedUserMap?['role'] ??
        '';

    final completionScore = profileMap?['completionScore'] ??
        profileMap?['CompletionScore'] ??
        cachedUserMap?['completionScore'] ??
        100;

    final dataNoticeAccepted = profileMap?['dataNoticeAccepted'] ??
        profileMap?['DataNoticeAccepted'] ??
        cachedUserMap?['dataNoticeAccepted'] ??
        false;

    final mediaConsentGranted = profileMap?['mediaConsentGranted'] ??
        profileMap?['MediaConsentGranted'] ??
        cachedUserMap?['mediaConsentGranted'] ??
        false;

    return DashboardDataEntity(
      tripSettings: tripSettings,
      flight: flight,
      hotel: hotel,
      itinerarySummary: summary,
      allItineraryItems: allItems,
      announcements: announcements,
      buses: buses,
      emergencyContacts: emergencyContacts,
      assignedBus: assignedBus.toString(),
      assignedGroup: assignedGroup.toString(),
      fullName: fullName.toString(),
      role: role.toString(),
      completionScore: (completionScore is int) ? completionScore : int.tryParse(completionScore.toString()) ?? 100,
      isBiometricsEnabled: biometricsEnabled,
      dataNoticeAccepted: dataNoticeAccepted == true,
      mediaConsentGranted: mediaConsentGranted == true,
    );
  }
}
