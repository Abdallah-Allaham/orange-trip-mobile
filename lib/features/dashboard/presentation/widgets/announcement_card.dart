import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/announcement_entity.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementEntity announcement;
  final bool isArabic;
  final VoidCallback onAcknowledge;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.isArabic,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? announcement.titleAr : announcement.titleEn;
    final content = isArabic ? announcement.contentAr : announcement.contentEn;
    final isCritical = announcement.type == 'CriticalAlert';

    final accentBar = Container(
      width: 4.w,
      color: isCritical ? OrangeColors.brandOrange : OrangeColors.darkGrey,
    );

    final cardContent = Expanded(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Tag & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5EB),
                    borderRadius: BorderRadius.circular(2.r),
                    border: Border.all(color: OrangeColors.brandOrange.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 11.sp, color: OrangeColors.brandOrange),
                      SizedBox(width: 4.w),
                      Text(
                        isArabic ? 'تنبيه إداري عاجل' : 'Important Notice',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: OrangeColors.accessibleOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  isArabic ? 'اليوم' : 'Today',
                  style: TextStyle(fontSize: 10.sp, color: OrangeColors.mediumGrey),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: OrangeColors.coreBlack,
              ),
            ),
            SizedBox(height: 4.h),

            // Description
            Text(
              content,
              style: TextStyle(
                fontSize: 11.sp,
                color: OrangeColors.darkGrey,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),

            // Acknowledge Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!announcement.isAcknowledged)
                  InkWell(
                    onTap: onAcknowledge,
                    borderRadius: BorderRadius.circular(3.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: OrangeColors.brandOrange,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, size: 13.sp, color: OrangeColors.coreWhite),
                          SizedBox(width: 4.w),
                          Text(
                            isArabic ? 'تم الاطلاع' : 'Got it',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: OrangeColors.coreWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 14.sp, color: OrangeColors.success),
                      SizedBox(width: 4.w),
                      Text(
                        isArabic ? 'تم تأكيد الاطلاع' : 'Acknowledged',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.success,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        decoration: BoxDecoration(
          color: OrangeColors.coreWhite,
          border: Border.all(color: OrangeColors.borderGrey),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: isArabic ? [cardContent, accentBar] : [accentBar, cardContent],
          ),
        ),
      ),
    );
  }
}
