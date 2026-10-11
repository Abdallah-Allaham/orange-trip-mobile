import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../dashboard/domain/entities/itinerary_item_entity.dart';

class ItineraryCard extends StatelessWidget {
  final ItineraryItemEntity item;
  final bool isArabic;

  const ItineraryCard({
    super.key,
    required this.item,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = isArabic;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(22.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: OrangeColors.warmCream,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${item.date.split("-").sublist(1).reversed.join("/")} · ${forceEnglishTime(item.startTime)} - ${forceEnglishTime(item.endTime)}',
                  style: AppTypography.font(
                    color: OrangeColors.primaryOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            isAr ? item.titleAr : item.titleEn,
            style: AppTypography.font(fontWeight: FontWeight.w700, fontSize: 14.sp, color: OrangeColors.black),
          ),
          SizedBox(height: 4.h),
          Text(
            isAr ? item.descriptionAr : item.descriptionEn,
            style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, height: 1.4),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 15.sp, color: OrangeColors.primaryOrange),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  isAr ? item.locationAr : item.locationEn,
                  style: AppTypography.font(fontSize: 11.5.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          if (item.gatheringPointEn.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.group_outlined, size: 15.sp, color: OrangeColors.darkOrange),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${isAr ? "نقطة التجمع:" : "Gathering:"} ${isAr ? item.gatheringPointAr : item.gatheringPointEn}',
                    style: AppTypography.font(fontSize: 11.5.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
