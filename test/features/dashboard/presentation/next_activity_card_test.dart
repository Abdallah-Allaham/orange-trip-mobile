import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/itinerary_summary_entity.dart';
import 'package:orange_trip_mobile/features/dashboard/presentation/widgets/next_activity_card.dart';

void main() {
  testWidgets('NextActivityCard renders activity title and countdown', (tester) async {
    const summary = ItinerarySummaryEntity(
      nextActivity: 'Official Welcome Dinner — Nile Cruise',
      nextActivityAr: 'عشاء الترحيب الافتتاحي بنيل القاهرة',
      gatheringPoint: 'St. Regis Lobby',
      gatheringPointAr: 'بهو فندق The St. Regis',
      gatheringTime: '07:30 PM',
      dressCode: 'Smart Casual',
      dressCodeAr: 'رسمي أنيق',
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const MaterialApp(
          home: Scaffold(
            body: NextActivityCard(
              summary: summary,
              countdownDuration: Duration(minutes: 45, seconds: 12),
              isArabic: false,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Official Welcome Dinner — Nile Cruise'), findsOneWidget);
    expect(find.text('Gathering: St. Regis Lobby'), findsOneWidget);
  });
}
