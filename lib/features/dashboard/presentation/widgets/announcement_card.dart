import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../domain/entities/announcement_entity.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementEntity announcement;
  final bool isArabic;
  final VoidCallback? onAcknowledge;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.isArabic,
    this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? announcement.titleAr : announcement.titleEn;
    final content = isArabic ? announcement.contentAr : announcement.contentEn;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: AppCards.secondary(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Notice Badge & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: OrangeColors.warmCream,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.campaign_outlined, size: 14.sp, color: OrangeColors.primaryOrange),
                    SizedBox(width: 5.w),
                    Text(
                      isArabic ? 'تنبيه إداري' : 'Official Notice',
                      style: GoogleFonts.cairo(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Title
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.black,
            ),
          ),
          SizedBox(height: 4.h),

          // Description
          Text(
            content,
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              color: OrangeColors.darkSecondaryText,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),

          // Bottom Action Row: Acknowledge Button or Acknowledged Status
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (announcement.isAcknowledged)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline, size: 13.sp, color: const Color(0xFF16A34A)),
                      SizedBox(width: 4.w),
                      Text(
                        isArabic ? '✓ تم الاطلاع' : '✓ Acknowledged',
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: onAcknowledge,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: OrangeColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14.sp, color: OrangeColors.white),
                        SizedBox(width: 5.w),
                        Text(
                          isArabic ? 'تم الاطلاع' : 'Got it',
                          style: GoogleFonts.cairo(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: OrangeColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
