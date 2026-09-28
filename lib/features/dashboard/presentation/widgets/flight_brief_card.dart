import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
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
      padding: AppSpacing.cardPaddingCompact,
      decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Airline & Flight Outbound Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.flight_takeoff, color: OrangeColors.primaryOrange, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    '${flight.airline} · ${flight.flightNumberOutbound}',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: OrangeColors.black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: OrangeColors.lightGray,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '2 Nov 2026',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: OrangeColors.darkSecondaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Route Details: AMM -> CAI
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: OrangeColors.background,
              borderRadius: BorderRadius.circular(18.r),
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
                      style: GoogleFonts.cairo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.black,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '09:30 AM',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                    Text(
                      'Amman',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Flight Direction & Duration
                Column(
                  children: [
                    Icon(
                      isArabic ? Icons.arrow_back : Icons.arrow_forward,
                      color: OrangeColors.primaryOrange,
                      size: 18.sp,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isArabic ? '1 س 25 د' : '1h 25m',
                      style: GoogleFonts.cairo(
                        fontSize: 10.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w600,
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
                      style: GoogleFonts.cairo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.black,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '10:55 AM',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                    Text(
                      'Cairo',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w500,
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
