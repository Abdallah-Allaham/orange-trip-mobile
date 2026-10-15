import 'package:equatable/equatable.dart';

class TripSettingsEntity extends Equatable {
  final int id;
  final String tripCode;
  final String titleEn;
  final String titleAr;
  final String destinationCityEn;
  final String destinationCityAr;
  final String destinationCountryEn;
  final String destinationCountryAr;
  final String airportCode;
  final String startDate;
  final String endDate;
  final String hotelName;
  final String hotelPhone;
  final String wifiNetwork;
  final String wifiPassword;
  final String flightCode;
  final String emergencyMedicalPhone;
  final String operationsDeskPhone;
  final String weatherTemp;
  final String weatherConditionEn;
  final String weatherConditionAr;
  final int tripVersion;
  final bool isActive;

  const TripSettingsEntity({
    required this.id,
    required this.tripCode,
    required this.titleEn,
    required this.titleAr,
    required this.destinationCityEn,
    required this.destinationCityAr,
    required this.destinationCountryEn,
    required this.destinationCountryAr,
    required this.airportCode,
    required this.startDate,
    required this.endDate,
    required this.hotelName,
    required this.hotelPhone,
    this.wifiNetwork = 'StRegis_Guest',
    required this.wifiPassword,
    required this.flightCode,
    this.emergencyMedicalPhone = '+20 100 000 9999',
    this.operationsDeskPhone = '+962 7 7700 0001',
    required this.weatherTemp,
    required this.weatherConditionEn,
    required this.weatherConditionAr,
    required this.tripVersion,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        tripCode,
        titleEn,
        titleAr,
        destinationCityEn,
        destinationCityAr,
        destinationCountryEn,
        destinationCountryAr,
        airportCode,
        startDate,
        endDate,
        hotelName,
        hotelPhone,
        wifiNetwork,
        wifiPassword,
        flightCode,
        emergencyMedicalPhone,
        operationsDeskPhone,
        weatherTemp,
        weatherConditionEn,
        weatherConditionAr,
        tripVersion,
        isActive,
      ];
}
