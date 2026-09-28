import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/features/dashboard/data/models/itinerary_summary_model.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/itinerary_summary_entity.dart';

void main() {
  const tItinerarySummaryModel = ItinerarySummaryModel(
    nextActivity: 'Official Welcome Dinner — Nile Cruise',
    nextActivityAr: 'عشاء الترحيب الافتتاحي بنيل القاهرة',
    nextActivityTime: '07:30 PM',
    gatheringPoint: 'St. Regis Lobby',
    gatheringPointAr: 'بهو فندق The St. Regis',
    gatheringTime: '07:00 PM',
    dressCode: 'Smart Casual',
    dressCodeAr: 'رسمي أنيق',
    weatherCity: 'Cairo',
    weatherTemp: '27°C',
    weatherCondition: 'Sunny & Pleasant',
    tripStatus: 'Ready',
    countdownDays: 36,
  );

  test('ItinerarySummaryModel should be a subclass of ItinerarySummaryEntity', () {
    expect(tItinerarySummaryModel, isA<ItinerarySummaryEntity>());
  });

  test('fromJson should parse server response correctly with Arabic and English fields', () {
    final Map<String, dynamic> jsonMap = {
      'nextActivity': 'Welcome Dinner',
      'nextActivityAr': 'عشاء الترحيب الافتتاحي',
      'nextActivityTime': '8:00 PM',
      'gatheringPoint': 'Hotel Lobby',
      'gatheringPointAr': 'بهو الفندق (اللوبي)',
      'gatheringTime': '7:30 PM',
      'weatherCity': 'Cairo',
      'weatherTemp': '27°C',
      'weatherCondition': 'Warm / Sunny',
      'tripStatus': 'Ready',
      'countdownDays': 3,
    };

    final result = ItinerarySummaryModel.fromJson(jsonMap);
    expect(result.nextActivity, 'Welcome Dinner');
    expect(result.nextActivityAr, 'عشاء الترحيب الافتتاحي');
    expect(result.gatheringPointAr, 'بهو الفندق (اللوبي)');
    expect(result.gatheringTime, '7:30 PM');
    expect(result.weatherTemp, '27°C');
  });
}
