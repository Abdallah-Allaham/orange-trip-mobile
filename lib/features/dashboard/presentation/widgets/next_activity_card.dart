import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../domain/entities/itinerary_summary_entity.dart';

class NextActivityCard extends StatelessWidget {
  final ItinerarySummaryEntity summary;
  final Duration countdownDuration;
  final bool isArabic;
  final VoidCallback? onDetailsTap;

  const NextActivityCard({
    super.key,
    required this.summary,
    required this.countdownDuration,
    required this.isArabic,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final activityTitle = isArabic ? summary.nextActivityAr : summary.nextActivity;
    final gatheringPoint = isArabic ? summary.gatheringPointAr : summary.gatheringPoint;
    final dressCode = isArabic ? summary.dressCodeAr : summary.dressCode;

    return Container(
      padding: AppSpacing.cardPaddingCompact,
      decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Tag and Live interactive countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: OrangeColors.warmCream,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule, size: 14.sp, color: OrangeColors.primaryOrange),
                          SizedBox(width: 5.w),
                          Text(
                            isArabic ? 'النشاط القادم' : 'Upcoming Activity',
                            style: GoogleFonts.cairo(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: OrangeColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Activity Title
          Text(
            activityTitle,
            style: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.black,
            ),
          ),
          SizedBox(height: 10.h),

          // Gathering Point & Dress Code Info Box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: OrangeColors.background,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 15.sp, color: OrangeColors.primaryOrange),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        '${isArabic ? "نقطة التجمع:" : "Gathering:"} $gatheringPoint',
                        style: GoogleFonts.cairo(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: OrangeColors.darkSecondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                if (dressCode.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.checkroom_outlined, size: 15.sp, color: OrangeColors.secondaryText),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${isArabic ? "الزي المطلوب:" : "Dress Code:"} $dressCode',
                          style: GoogleFonts.cairo(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                            color: OrangeColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (onDetailsTap != null) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: onDetailsTap,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? 'عرض تفاصيل الفعالية' : 'View Full Agenda',
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.primaryOrange,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        isArabic ? Icons.chevron_left : Icons.chevron_right,
                        size: 16.sp,
                        color: OrangeColors.primaryOrange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
