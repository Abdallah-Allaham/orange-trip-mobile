import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/announcement_model.dart';
import '../models/flight_model.dart';
import '../models/hotel_model.dart';
import '../models/itinerary_item_model.dart';
import '../models/itinerary_summary_model.dart';
import '../models/trip_settings_model.dart';
import '../models/bus_model.dart';
import '../models/emergency_contact_model.dart';

abstract class DashboardRemoteDataSource {
  Future<TripSettingsModel> getActiveTrip();
  Future<FlightModel> getFlight();
  Future<HotelModel> getHotel();
  Future<ItinerarySummaryModel> getItinerarySummary();
  Future<List<ItineraryItemModel>> getItineraryItems();
  Future<List<AnnouncementModel>> getAnnouncements();
  Future<bool> acknowledgeAnnouncement(int id);
  Future<Map<String, dynamic>?> getProfile();
  Future<List<BusModel>> getBuses();
  Future<List<EmergencyContactModel>> getEmergencyContacts();
  Future<bool> updateConsent({required bool dataNoticeAccepted, required bool mediaConsentGranted});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  Future<Map<String, String>?> _fetchLiveCityWeather(String cityName) async {
    if (cityName.trim().isEmpty) return null;
    try {
      final externalDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(milliseconds: 3500),
          receiveTimeout: const Duration(milliseconds: 3500),
        ),
      );
      final geoRes = await externalDio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': cityName.trim(),
          'count': 1,
          'language': 'en',
          'format': 'json',
        },
      );
      if (geoRes.statusCode == 200 &&
          geoRes.data is Map &&
          geoRes.data['results'] is List &&
          (geoRes.data['results'] as List).isNotEmpty) {
        final first = (geoRes.data['results'] as List).first;
        final lat = first['latitude'];
        final lon = first['longitude'];
        if (lat != null && lon != null) {
          final weatherRes = await externalDio.get(
            'https://api.open-meteo.com/v1/forecast',
            queryParameters: {
              'latitude': lat,
              'longitude': lon,
              'current': 'temperature_2m,weather_code',
            },
          );
          if (weatherRes.statusCode == 200 &&
              weatherRes.data is Map &&
              weatherRes.data['current'] is Map) {
            final current = weatherRes.data['current'] as Map;
            final tempVal = current['temperature_2m'];
            final code = (current['weather_code'] as num?)?.toInt() ?? 0;
            if (tempVal is num) {
              final tempStr = '${tempVal.round()}°C';
              String condEn = 'Clear & Pleasant';
              String condAr = 'مشمس ومعتدل';
              if (code == 0) {
                condEn = 'Sunny & Clear';
                condAr = 'مشمس وصافٍ';
              } else if ([1, 2, 3].contains(code)) {
                condEn = 'Partly Cloudy';
                condAr = 'غائم جزئياً';
              } else if ([45, 48].contains(code)) {
                condEn = 'Misty / Foggy';
                condAr = 'ضبابي خفيف';
              } else if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) {
                condEn = 'Light Showers';
                condAr = 'أمطار خفيفة';
              } else if ([71, 73, 75, 85, 86].contains(code)) {
                condEn = 'Snow / Cold';
                condAr = 'بارد وأجواء ثلجية';
              } else if ([95, 96, 99].contains(code)) {
                condEn = 'Thunderstorms';
                condAr = 'عواصف رعدية';
              }
              return {
                'temp': tempStr,
                'conditionEn': condEn,
                'conditionAr': condAr,
              };
            }
          }
        }
      }
    } catch (_) {
      // Graceful fallback to backend DB cached weather on network error
    }
    return null;
  }

  @override
  Future<TripSettingsModel> getActiveTrip() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.activeTrip);
      if (response.statusCode == 200 && response.data != null) {
        final rawMap = Map<String, dynamic>.from(response.data as Map);
        final cityEn = (rawMap['destinationCityEn'] ?? rawMap['DestinationCityEn'] ?? 'Cairo').toString();
        final liveWeather = await _fetchLiveCityWeather(cityEn);
        if (liveWeather != null) {
          rawMap['weatherTemp'] = liveWeather['temp'];
          rawMap['weatherConditionEn'] = liveWeather['conditionEn'];
          rawMap['weatherConditionAr'] = liveWeather['conditionAr'];
        }
        return TripSettingsModel.fromJson(rawMap);
      }
      throw ServerException(
        message: 'Failed to retrieve active trip settings.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : 'Unable to connect to trip settings service.',
        statusCode: e.response?.statusCode,
      );
    }
  }

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
        final rawMap = Map<String, dynamic>.from(response.data as Map);
        final cityEn = (rawMap['weatherCity'] ?? rawMap['WeatherCity'] ?? 'Cairo').toString();
        final liveWeather = await _fetchLiveCityWeather(cityEn);
        if (liveWeather != null) {
          rawMap['weatherTemp'] = liveWeather['temp'];
          rawMap['weatherCondition'] = liveWeather['conditionEn'];
        }
        return ItinerarySummaryModel.fromJson(rawMap);
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

  @override
  Future<List<BusModel>> getBuses() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.buses);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => BusModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<EmergencyContactModel>> getEmergencyContacts() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.emergencyContacts);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => EmergencyContactModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> updateConsent({required bool dataNoticeAccepted, required bool mediaConsentGranted}) async {
    try {
      final response = await apiClient.dio.put(
        ApiConstants.consent,
        data: {
          'dataNoticeAccepted': dataNoticeAccepted,
          'mediaConsentGranted': mediaConsentGranted,
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
