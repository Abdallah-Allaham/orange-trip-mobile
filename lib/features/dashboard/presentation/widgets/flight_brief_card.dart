import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../domain/entities/flight_entity.dart';
import '../../domain/entities/trip_settings_entity.dart';

class FlightBriefCard extends StatelessWidget {
  final FlightEntity flight;
  final bool isArabic;
  final TripSettingsEntity? tripSettings;

  const FlightBriefCard({
    super.key,
    required this.flight,
    required this.isArabic,
    this.tripSettings,
  });

  String _extractDate(String dtStr) {
    if (dtStr.isEmpty) {
      if (tripSettings != null && tripSettings!.startDate.isNotEmpty) {
        try {
          final dt = DateTime.parse(tripSettings!.startDate);
          return DateFormat('d MMM', isArabic ? 'ar' : 'en').format(dt);
        } catch (_) {
          return tripSettings!.startDate;
        }
      }
      return 'TBD';
    }
    try {
      final dt = DateTime.parse(dtStr.replaceAll(' ', 'T'));
      return DateFormat('d MMM', isArabic ? 'ar' : 'en').format(dt);
    } catch (_) {
      if (dtStr.contains('·') || dtStr.contains('•')) {
        return dtStr.split(RegExp(r'[·•]')).first.trim();
      }
      final parts = dtStr.split(' ');
      if (parts.length >= 2 && !parts[1].contains(':')) {
        return '${parts[0]} ${parts[1]}';
      }
      return dtStr;
    }
  }

  String _extractTime(String dtStr, String fallback) {
    if (dtStr.isEmpty) return fallback;
    String raw = fallback;
    try {
      final dt = DateTime.parse(dtStr.replaceAll(' ', 'T'));
      raw = DateFormat('hh:mm a', 'en_US').format(dt);
    } catch (_) {
      if (dtStr.contains('·') || dtStr.contains('•')) {
        raw = dtStr.split(RegExp(r'[·•]')).last.trim();
      } else if (dtStr.contains(' ')) {
        raw = dtStr.split(' ').last.trim();
      } else {
        raw = dtStr;
      }
    }
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      raw = raw.replaceAll(arabicDigits[i], englishDigits[i]);
    }
    return raw.replaceAll('ص', 'AM').replaceAll('م', 'PM');
  }

  Map<String, String> _parseRoute(String route) {
    String originCity = 'Amman';
    String originCode = 'AMM';
    String destCity = (tripSettings != null && tripSettings!.destinationCityEn.isNotEmpty)
        ? (isArabic && tripSettings!.destinationCityAr.isNotEmpty ? tripSettings!.destinationCityAr : tripSettings!.destinationCityEn)
        : 'Destination';
    String destCode = (tripSettings != null && tripSettings!.airportCode.isNotEmpty)
        ? tripSettings!.airportCode
        : 'DST';

    if (route.contains('→') || route.contains('->')) {
      final parts = route.contains('→') ? route.split('→') : route.split('->');
      if (parts.length == 2) {
        final originPart = parts[0].trim();
        final destPart = parts[1].trim();

        final originCodeMatch = RegExp(r'\(([^)]+)\)').firstMatch(originPart);
        if (originCodeMatch != null) {
          originCode = originCodeMatch.group(1) ?? 'AMM';
          originCity = originPart.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
        } else {
          originCity = originPart;
          originCode = originPart.length <= 4 ? originPart.toUpperCase() : originPart.substring(0, 3).toUpperCase();
        }

        if (tripSettings != null && tripSettings!.destinationCityEn.isNotEmpty) {
          destCity = isArabic && tripSettings!.destinationCityAr.isNotEmpty ? tripSettings!.destinationCityAr : tripSettings!.destinationCityEn;
          destCode = tripSettings!.airportCode.isNotEmpty ? tripSettings!.airportCode : 'DST';
        } else {
          final destCodeMatch = RegExp(r'\(([^)]+)\)').firstMatch(destPart);
          if (destCodeMatch != null) {
            destCode = destCodeMatch.group(1) ?? 'DST';
            destCity = destPart.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
          } else {
            destCity = destPart;
            destCode = destPart.length <= 4 ? destPart.toUpperCase() : destPart.substring(0, 3).toUpperCase();
          }
        }
      }
    } else if (route.isNotEmpty && (tripSettings == null || tripSettings!.destinationCityEn.isEmpty)) {
      destCity = route;
      destCode = route.length <= 4 ? route.toUpperCase() : route.substring(0, 3).toUpperCase();
    }
    return {
      'originCity': originCity,
      'originCode': originCode,
      'destCity': destCity,
      'destCode': destCode,
    };
  }

  String _calculateDuration(String depStr, String arrStr) {
    try {
      final dep = DateTime.parse(depStr.replaceAll(' ', 'T'));
      final arr = DateTime.parse(arrStr.replaceAll(' ', 'T'));
      final diff = arr.difference(dep);
      if (diff.isNegative) return isArabic ? 'مباشر' : 'Direct';
      final h = diff.inHours;
      final m = diff.inMinutes.remainder(60);
      return isArabic ? '${h > 0 ? "$h س " : ""}$m د' : '${h > 0 ? "${h}h " : ""}${m}m';
    } catch (_) {
      return isArabic ? 'مباشر' : 'Direct';
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeInfo = _parseRoute(flight.outboundRoute);
    final depDate = _extractDate(flight.outboundDepartureTime);
    final depTime = _extractTime(flight.outboundDepartureTime, '09:30 AM');
    final arrTime = _extractTime(flight.outboundArrivalTime, '10:55 AM');
    final duration = _calculateDuration(flight.outboundDepartureTime, flight.outboundArrivalTime);
    final displayFlightNum = (tripSettings != null && tripSettings!.flightCode.isNotEmpty)
        ? tripSettings!.flightCode
        : flight.flightNumberOutbound;

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
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.flight_takeoff, color: OrangeColors.primaryOrange, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '${flight.airline} · $displayFlightNum',
                        style: AppTypography.font(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (depDate.isNotEmpty && depDate != 'TBD')
                Text(
                  depDate,
                  style: AppTypography.font(
                    fontSize: 11.5.sp,
                    color: OrangeColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),

          // Route Details: Origin -> Destination
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
                      routeInfo['originCode']!,
                      style: AppTypography.font(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.black,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      depTime,
                      style: AppTypography.font(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                    Text(
                      routeInfo['originCity']!,
                      style: AppTypography.font(
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
                      duration,
                      style: AppTypography.font(
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
                      routeInfo['destCode']!,
                      style: AppTypography.font(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.black,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      arrTime,
                      style: AppTypography.font(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                    Text(
                      routeInfo['destCity']!,
                      style: AppTypography.font(
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
