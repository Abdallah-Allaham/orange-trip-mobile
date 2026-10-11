import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/phone_launcher.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../dashboard/domain/entities/bus_entity.dart';

class BusesSection extends StatelessWidget {
  final List<BusEntity> buses;
  final String assignedBus;
  final bool isArabic;

  const BusesSection({
    super.key,
    required this.buses,
    required this.assignedBus,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = isArabic;

    if (buses.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Column(
            children: [
              Icon(Icons.directions_bus_outlined, size: 40.sp, color: OrangeColors.secondaryText),
              SizedBox(height: 12.h),
              Text(
                'no_buses_registered'.tr(),
                style: AppTypography.font(color: OrangeColors.secondaryText, fontSize: 13.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buses.map((bus) {
        final isMyBus = assignedBus.isNotEmpty && 
            (assignedBus.toLowerCase() == bus.busNumber.toLowerCase() || 
             assignedBus.toLowerCase() == bus.busNameEn.toLowerCase());

        final busName = (isAr && bus.busNameAr.isNotEmpty) ? bus.busNameAr : bus.busNameEn;
        final gatheringPoint = (isAr && bus.gatheringPointAr.isNotEmpty) ? bus.gatheringPointAr : bus.gatheringPointEn;

        return Container(
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isMyBus ? OrangeColors.primaryOrange.withValues(alpha: 0.12) : OrangeColors.warmCream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_bus_outlined,
                          size: 18.sp,
                          color: OrangeColors.primaryOrange,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          busName,
                          style: AppTypography.font(fontSize: 14.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        ),
                        if (isMyBus) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: OrangeColors.primaryOrange,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              'my_bus'.tr(),
                              style: AppTypography.font(fontSize: 10.sp, color: OrangeColors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      bus.busNumber,
                      style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.primaryOrange, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${'gathering_point'.tr()}: ',
                          style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            gatheringPoint,
                            style: AppTypography.font(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          '${'gathering_time'.tr()}: ',
                          style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          forceEnglishTime(bus.gatheringTime),
                          style: AppTypography.font(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          '${'departure_time'.tr()}: ',
                          style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          forceEnglishTime(bus.departureTime),
                          style: AppTypography.font(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.primaryOrange),
                        ),
                      ],
                    ),
                    Divider(height: 24.h, color: OrangeColors.lightBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${'coordinator'.tr()}: ${bus.coordinatorName}',
                                style: AppTypography.font(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4.h),
                              InkWell(
                                onTap: () => launchPhoneCall(bus.coordinatorPhone),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone_in_talk, size: 14.sp, color: OrangeColors.primaryOrange),
                                    SizedBox(width: 6.w),
                                    Text(
                                      bus.coordinatorPhone,
                                      style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.primaryOrange, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${'driver'.tr()}: ${bus.driverName}',
                                style: AppTypography.font(fontSize: 11.5.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 4.h),
                              InkWell(
                                onTap: () => launchPhoneCall(bus.driverPhone),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone_in_talk, size: 14.sp, color: OrangeColors.secondaryText),
                                    SizedBox(width: 6.w),
                                    Text(
                                      bus.driverPhone,
                                      style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      }).toList(),
    );
  }
}
