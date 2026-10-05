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
  final String wifiPassword;
  final String flightCode;
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
    required this.wifiPassword,
    required this.flightCode,
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
        wifiPassword,
        flightCode,
        weatherTemp,
        weatherConditionEn,
        weatherConditionAr,
        tripVersion,
        isActive,
      ];
}
