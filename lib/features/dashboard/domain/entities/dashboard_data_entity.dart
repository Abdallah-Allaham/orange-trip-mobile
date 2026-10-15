import 'package:equatable/equatable.dart';
import 'announcement_entity.dart';
import 'bus_entity.dart';
import 'emergency_contact_entity.dart';
import 'flight_entity.dart';
import 'hotel_entity.dart';
import 'itinerary_item_entity.dart';
import 'itinerary_summary_entity.dart';
import 'trip_settings_entity.dart';

class DashboardDataEntity extends Equatable {
  final TripSettingsEntity? tripSettings;
  final FlightEntity flight;
  final HotelEntity hotel;
  final ItinerarySummaryEntity itinerarySummary;
  final List<ItineraryItemEntity> allItineraryItems;
  final List<AnnouncementEntity> announcements;
  final List<BusEntity> buses;
  final List<EmergencyContactEntity> emergencyContacts;
  final String assignedBus;
  final String assignedGroup;
  final String fullName;
  final String role;
  final int completionScore;
  final bool isBiometricsEnabled;
  final bool dataNoticeAccepted;
  final bool mediaConsentGranted;

  const DashboardDataEntity({
    this.tripSettings,
    required this.flight,
    required this.hotel,
    required this.itinerarySummary,
    this.allItineraryItems = const [],
    this.announcements = const [],
    this.buses = const [],
    this.emergencyContacts = const [],
    required this.assignedBus,
    required this.assignedGroup,
    required this.fullName,
    required this.role,
    this.completionScore = 80,
    this.isBiometricsEnabled = false,
    this.dataNoticeAccepted = false,
    this.mediaConsentGranted = false,
  });

  DashboardDataEntity copyWith({
    TripSettingsEntity? tripSettings,
    FlightEntity? flight,
    HotelEntity? hotel,
    ItinerarySummaryEntity? itinerarySummary,
    List<ItineraryItemEntity>? allItineraryItems,
    List<AnnouncementEntity>? announcements,
    List<BusEntity>? buses,
    List<EmergencyContactEntity>? emergencyContacts,
    String? assignedBus,
    String? assignedGroup,
    String? fullName,
    String? role,
    int? completionScore,
    bool? isBiometricsEnabled,
    bool? dataNoticeAccepted,
    bool? mediaConsentGranted,
  }) {
    return DashboardDataEntity(
      tripSettings: tripSettings ?? this.tripSettings,
      flight: flight ?? this.flight,
      hotel: hotel ?? this.hotel,
      itinerarySummary: itinerarySummary ?? this.itinerarySummary,
      allItineraryItems: allItineraryItems ?? this.allItineraryItems,
      announcements: announcements ?? this.announcements,
      buses: buses ?? this.buses,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      assignedBus: assignedBus ?? this.assignedBus,
      assignedGroup: assignedGroup ?? this.assignedGroup,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      completionScore: completionScore ?? this.completionScore,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      dataNoticeAccepted: dataNoticeAccepted ?? this.dataNoticeAccepted,
      mediaConsentGranted: mediaConsentGranted ?? this.mediaConsentGranted,
    );
  }

  @override
  List<Object?> get props => [
        tripSettings,
        flight,
        hotel,
        itinerarySummary,
        allItineraryItems,
        announcements,
        buses,
        emergencyContacts,
        assignedBus,
        assignedGroup,
        fullName,
        role,
        completionScore,
        isBiometricsEnabled,
        dataNoticeAccepted,
        mediaConsentGranted,
      ];
}
