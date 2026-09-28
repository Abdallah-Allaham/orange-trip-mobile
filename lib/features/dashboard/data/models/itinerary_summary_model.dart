import '../../domain/entities/itinerary_summary_entity.dart';

class ItinerarySummaryModel extends ItinerarySummaryEntity {
  const ItinerarySummaryModel({
    super.nextActivity,
    super.nextActivityAr,
    super.nextActivityTime,
    super.gatheringPoint,
    super.gatheringPointAr,
    super.gatheringTime,
    super.dressCode,
    super.dressCodeAr,
    super.weatherCity,
    super.weatherTemp,
    super.weatherCondition,
    super.tripStatus,
    super.countdownDays,
  });

  factory ItinerarySummaryModel.fromJson(Map<String, dynamic> json) {
    return ItinerarySummaryModel(
      nextActivity: json['nextActivity'] ?? json['NextActivity'] ?? 'Welcome Dinner',
      nextActivityAr: json['nextActivityAr'] ?? json['NextActivityAr'] ?? 'عشاء الترحيب الافتتاحي',
      nextActivityTime: json['nextActivityTime'] ?? json['NextActivityTime'] ?? '8:00 PM',
      gatheringPoint: json['gatheringPoint'] ?? json['GatheringPoint'] ?? 'Hotel Lobby',
      gatheringPointAr: json['gatheringPointAr'] ?? json['GatheringPointAr'] ?? 'بهو الفندق (اللوبي)',
      gatheringTime: json['gatheringTime'] ?? json['GatheringTime'] ?? '7:30 PM',
      dressCode: json['dressCode'] ?? json['DressCode'] ?? 'Smart Casual',
      dressCodeAr: json['dressCodeAr'] ?? json['DressCodeAr'] ?? 'رسمي أنيق',
      weatherCity: json['weatherCity'] ?? json['WeatherCity'] ?? 'Cairo',
      weatherTemp: json['weatherTemp'] ?? json['WeatherTemp'] ?? '27°C',
      weatherCondition: json['weatherCondition'] ?? json['WeatherCondition'] ?? 'Warm / Sunny',
      tripStatus: json['tripStatus'] ?? json['TripStatus'] ?? 'Ready',
      countdownDays: json['countdownDays'] ?? json['CountdownDays'] ?? 36,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nextActivity': nextActivity,
      'nextActivityAr': nextActivityAr,
      'nextActivityTime': nextActivityTime,
      'gatheringPoint': gatheringPoint,
      'gatheringPointAr': gatheringPointAr,
      'gatheringTime': gatheringTime,
      'dressCode': dressCode,
      'dressCodeAr': dressCodeAr,
      'weatherCity': weatherCity,
      'weatherTemp': weatherTemp,
      'weatherCondition': weatherCondition,
      'tripStatus': tripStatus,
      'countdownDays': countdownDays,
    };
  }
}
