import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/flight_entity.dart';

class FlightBriefCard extends StatelessWidget {
  final FlightEntity flight;
  final bool isArabic;

  const FlightBriefCard({
    super.key,
    required this.flight,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: OrangeColors.coreWhite,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: OrangeColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Airline & Outbound Flight Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${flight.airline} · ${flight.flightNumberOutbound}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: OrangeColors.coreBlack,
                ),
              ),
              Text(
                '2 Nov 2026',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: OrangeColors.mediumGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Route Details: AMM -> CAI
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: OrangeColors.lightGrey,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Origin
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AMM',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: OrangeColors.coreBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '09:30 AM',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.brandOrange,
                      ),
                    ),
                    Text(
                      'Amman',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: OrangeColors.mediumGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Flight Direction & Duration
                Column(
                  children: [
                    Icon(
                      isArabic ? Icons.arrow_back : Icons.arrow_forward,
                      color: OrangeColors.brandOrange,
                      size: 16.sp,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isArabic ? '1 س 25 د' : '1h 25m',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: OrangeColors.mediumGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                // Destination
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'CAI',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: OrangeColors.coreBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '10:55 AM',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.brandOrange,
                      ),
                    ),
                    Text(
                      'Cairo',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: OrangeColors.mediumGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
