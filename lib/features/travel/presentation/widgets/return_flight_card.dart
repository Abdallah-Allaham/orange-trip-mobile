import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../dashboard/domain/entities/flight_entity.dart';
import '../../../dashboard/domain/entities/trip_settings_entity.dart';

class ReturnFlightCard extends StatelessWidget {
  final FlightEntity? flight;
  final TripSettingsEntity? tripSettings;
  final bool isArabic;

  const ReturnFlightCard({
    super.key,
    required this.flight,
    required this.tripSettings,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = isArabic;
    final airline = flight?.airline ?? 'Royal Jordanian';
    final flightNum = flight?.flightNumberReturn ?? 'RJ 506';
    final dynCity = tripSettings != null
        ? (isAr ? tripSettings!.destinationCityAr : tripSettings!.destinationCityEn)
        : 'Cairo';
    final dynCode = tripSettings?.airportCode ?? 'CAI';
    final defaultRoute = '$dynCity ($dynCode) → Amman (AMM)';
    final returnRoute = flight?.returnRoute ?? defaultRoute;
    final depRaw = flight?.returnDepartureTime ?? '';
    final arrRaw = flight?.returnArrivalTime ?? '';

    String originCity = dynCity.isNotEmpty ? dynCity : 'Cairo';
    String originCode = dynCode.isNotEmpty ? dynCode : 'CAI';
    String destCity = 'Amman';
    String destCode = 'AMM';

    if (returnRoute.contains('→') || returnRoute.contains('->')) {
      final parts = returnRoute.contains('→') ? returnRoute.split('→') : returnRoute.split('->');
      if (parts.length == 2) {
        final origPart = parts[0].trim();
        final dstPart = parts[1].trim();

        final oMatch = RegExp(r'\(([^)]+)\)').firstMatch(origPart);
        if (oMatch != null) {
          originCode = oMatch.group(1) ?? 'CAI';
          originCity = origPart.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
        } else {
          originCity = origPart;
          originCode = origPart.length <= 4 ? origPart.toUpperCase() : origPart.substring(0, 3).toUpperCase();
        }

        final dMatch = RegExp(r'\(([^)]+)\)').firstMatch(dstPart);
        if (dMatch != null) {
          destCode = dMatch.group(1) ?? 'AMM';
          destCity = dstPart.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
        } else {
          destCity = dstPart;
          destCode = dstPart.length <= 4 ? dstPart.toUpperCase() : dstPart.substring(0, 3).toUpperCase();
        }
      }
    }

    String returnDate = 'TBD';
    String depTime = 'TBD';
    String arrTime = 'TBD';

    if (depRaw.isNotEmpty) {
      try {
        final dt = DateTime.parse(depRaw.replaceAll(' ', 'T'));
        returnDate = DateFormat('d MMM', 'en_US').format(dt);
        depTime = forceEnglishTime(DateFormat('hh:mm a', 'en_US').format(dt));
      } catch (_) {
        if (depRaw.contains('·') || depRaw.contains('•')) {
          returnDate = depRaw.split(RegExp(r'[·•]')).first.trim();
          depTime = forceEnglishTime(depRaw.split(RegExp(r'[·•]')).last.trim());
        } else {
          final parts = depRaw.split(' ');
          if (parts.length >= 2 && !parts[1].contains(':')) {
            returnDate = '${parts[0]} ${parts[1]}';
            depTime = forceEnglishTime(parts.last);
          } else {
            returnDate = parts.first;
            depTime = forceEnglishTime(parts.last);
          }
        }
      }
    } else if (tripSettings != null && tripSettings!.endDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(tripSettings!.endDate);
        returnDate = DateFormat('d MMM', 'en_US').format(dt);
      } catch (_) {
        returnDate = tripSettings!.endDate;
      }
    }

    if (arrRaw.isNotEmpty) {
      try {
        final dt = DateTime.parse(arrRaw.replaceAll(' ', 'T'));
        arrTime = forceEnglishTime(DateFormat('hh:mm a', 'en_US').format(dt));
      } catch (_) {
        if (arrRaw.contains('·') || arrRaw.contains('•')) {
          arrTime = forceEnglishTime(arrRaw.split(RegExp(r'[·•]')).last.trim());
        } else if (arrRaw.contains(' ')) {
          arrTime = forceEnglishTime(arrRaw.split(' ').last.trim());
        } else {
          arrTime = forceEnglishTime(arrRaw);
        }
      }
    }

    String duration = 'direct'.tr();
    if (depRaw.isNotEmpty && arrRaw.isNotEmpty) {
      try {
        final dep = DateTime.parse(depRaw.replaceAll(' ', 'T'));
        final arr = DateTime.parse(arrRaw.replaceAll(' ', 'T'));
        final diff = arr.difference(dep);
        if (!diff.isNegative) {
          final h = diff.inHours;
          final m = diff.inMinutes.remainder(60);
          duration = isAr ? '${h > 0 ? "$h س " : ""}$m د' : '${h > 0 ? "${h}h " : ""}${m}m';
        }
      } catch (_) {}
    }

    return Container(
      padding: AppSpacing.cardPaddingCompact,
      decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.flight_land, color: OrangeColors.primaryOrange, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '$airline · $flightNum',
                        style: AppTypography.font(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: OrangeColors.warmCream,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'return_flight'.tr(),
                      style: AppTypography.font(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    returnDate,
                    style: AppTypography.font(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: OrangeColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: OrangeColors.background,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      originCode,
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
                      originCity,
                      style: AppTypography.font(
                        fontSize: 11.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      isAr ? Icons.arrow_back : Icons.arrow_forward,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      destCode,
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
                      destCity,
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
