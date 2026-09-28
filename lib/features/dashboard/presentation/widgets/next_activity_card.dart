import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final activityTitle = isArabic ? summary.nextActivityAr : summary.nextActivity;
    final gatheringPoint = isArabic ? summary.gatheringPointAr : summary.gatheringPoint;
    final dressCode = isArabic ? summary.dressCodeAr : summary.dressCode;

    final accentBar = Container(
      width: 4.w,
      color: OrangeColors.brandOrange,
    );

    final content = Expanded(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with colloquial tagline and live interactive countdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: OrangeColors.brandOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Icon(
                          Icons.alarm,
                          color: OrangeColors.accessibleOrange,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'شو في عنا كمان ساعة؟' : 'Upcoming in Next Hour',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                color: OrangeColors.accessibleOrange,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isArabic ? 'النشاط القادم لوفد أورنج' : 'Next Delegation Activity',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: OrangeColors.mediumGrey,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Live Interactive Countdown Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: OrangeColors.coreBlack,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 12.sp,
                        color: OrangeColors.brandOrange,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDuration(countdownDuration),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: OrangeColors.coreWhite,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Activity Title
            Text(
              activityTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: OrangeColors.coreBlack,
                height: 1.25,
              ),
            ),
            SizedBox(height: 10.h),

            // Gathering Point & Time
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: OrangeColors.lightGrey,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: OrangeColors.borderGrey),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 15.sp,
                        color: OrangeColors.brandOrange,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${isArabic ? 'نقطة التجمع:' : 'Gathering Point:'} $gatheringPoint',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: OrangeColors.coreBlack,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: OrangeColors.coreBlack,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Text(
                          summary.gatheringTime,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: OrangeColors.brandOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.checkroom,
                        size: 15.sp,
                        color: OrangeColors.mediumGrey,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${isArabic ? 'اللباس المعتمد:' : 'Dress Code:'} $dressCode',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: OrangeColors.darkGrey,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: OrangeColors.brandOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Text(
                          isArabic ? 'رسمي' : 'Official',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: OrangeColors.accessibleOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            children: isArabic ? [content, accentBar] : [accentBar, content],
          ),
        ),
      ),
    );
  }
}
