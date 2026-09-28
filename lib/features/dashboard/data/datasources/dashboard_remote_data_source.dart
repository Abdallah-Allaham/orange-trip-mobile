import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/announcement_model.dart';
import '../models/flight_model.dart';
import '../models/hotel_model.dart';
import '../models/itinerary_item_model.dart';
import '../models/itinerary_summary_model.dart';

abstract class DashboardRemoteDataSource {
  Future<FlightModel> getFlight();
  Future<HotelModel> getHotel();
  Future<ItinerarySummaryModel> getItinerarySummary();
  Future<List<ItineraryItemModel>> getItineraryItems();
  Future<List<AnnouncementModel>> getAnnouncements();
  Future<bool> acknowledgeAnnouncement(int id);
  Future<Map<String, dynamic>?> getProfile();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<FlightModel> getFlight() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.flight);
      if (response.statusCode == 200 && response.data != null) {
        return FlightModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to retrieve flight logistics.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : 'Unable to connect to flight logistics service.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<HotelModel> getHotel() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.hotel);
      if (response.statusCode == 200 && response.data != null) {
        return HotelModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to retrieve hotel logistics.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : 'Unable to connect to hotel logistics service.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ItinerarySummaryModel> getItinerarySummary() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.itinerarySummary);
      if (response.statusCode == 200 && response.data != null) {
        return ItinerarySummaryModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to retrieve itinerary summary.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : 'Unable to connect to itinerary service.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<ItineraryItemModel>> getItineraryItems() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.itinerary);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => ItineraryItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : 'Unable to connect to itinerary timeline service.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.announcements);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => AnnouncementModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> acknowledgeAnnouncement(int id) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.acknowledgeAnnouncement(id));
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.profile);
      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
