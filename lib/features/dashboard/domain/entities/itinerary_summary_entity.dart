import 'package:equatable/equatable.dart';

class ItinerarySummaryEntity extends Equatable {
  final String nextActivity;
  final String nextActivityAr;
  final String nextActivityTime;
  final String gatheringPoint;
  final String gatheringPointAr;
  final String gatheringTime;
  final String dressCode;
  final String dressCodeAr;
  final String weatherCity;
  final String weatherTemp;
  final String weatherCondition;
  final String tripStatus;
  final int countdownDays;

  const ItinerarySummaryEntity({
    this.nextActivity = 'Official Welcome Dinner — Nile Cruise',
    this.nextActivityAr = 'عشاء الترحيب الرسمي بنيل القاهرة',
    this.nextActivityTime = '07:30 PM',
    this.gatheringPoint = 'St. Regis Lobby',
    this.gatheringPointAr = 'بهو فندق The St. Regis',
    this.gatheringTime = '07:00 PM',
    this.dressCode = 'Smart Casual',
    this.dressCodeAr = 'رسمي أنيق',
    this.weatherCity = 'Cairo',
    this.weatherTemp = '27°C',
    this.weatherCondition = 'Sunny & Pleasant',
    this.tripStatus = 'Ready',
    this.countdownDays = 36,
  });

  @override
  List<Object?> get props => [
        nextActivity,
        nextActivityAr,
        nextActivityTime,
        gatheringPoint,
        gatheringPointAr,
        gatheringTime,
        dressCode,
        dressCodeAr,
        weatherCity,
        weatherTemp,
        weatherCondition,
        tripStatus,
        countdownDays,
      ];
}
