import '../entities/announcement_entity.dart';
import '../entities/dashboard_data_entity.dart';
import '../entities/flight_entity.dart';
import '../entities/hotel_entity.dart';
import '../entities/itinerary_item_entity.dart';
import '../entities/itinerary_summary_entity.dart';

abstract class DashboardRepository {
  Future<FlightEntity> getFlightDetails();
  Future<HotelEntity> getHotelDetails();
  Future<ItinerarySummaryEntity> getItinerarySummary();
  Future<List<ItineraryItemEntity>> getItineraryItems();
  Future<List<AnnouncementEntity>> getAnnouncements();
  Future<bool> acknowledgeAnnouncement(int id);
  Future<void> setBiometricsEnabled(bool enabled);
  Future<bool> isBiometricsEnabled();
  Future<DashboardDataEntity> getDashboardData();
}
