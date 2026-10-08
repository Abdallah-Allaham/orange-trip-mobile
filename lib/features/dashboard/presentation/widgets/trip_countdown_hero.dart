import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/name_formatter.dart';

class TripCountdownHero extends StatelessWidget {
  final String fullName;
  final String role;
  final String? assignedBus;
  final String? assignedGroup;
  final Duration countdownDuration;
  final bool isArabic;
  final String? destination;
  final String? tripDates;
  final String? weatherTemp;

  const TripCountdownHero({
    super.key,
    required this.fullName,
    required this.role,
    this.assignedBus,
    this.assignedGroup,
    required this.countdownDuration,
    required this.isArabic,
    this.destination,
    this.tripDates,
    this.weatherTemp,
  });

  @override
  Widget build(BuildContext context) {
    final days = countdownDuration.inDays;
    final hours = countdownDuration.inHours.remainder(24);
    final minutes = countdownDuration.inMinutes.remainder(60);
    final seconds = countdownDuration.inSeconds.remainder(60);

    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: AppCards.primary(
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Top Row (Welcome Greeting on Left, Delegation Badge on Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: OrangeColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isArabic ? 'مرحباً،' : 'Welcome,',
                    style: AppTypography.font(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: OrangeColors.secondaryText,
                    ),
                  ),
                ],
              ),
              // Executive Delegation Badge
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: OrangeColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: OrangeColors.lightBorder),
                  ),
                  child: Text(
                    isArabic ? 'عضو الوفد الرسمي' : 'Official Delegation Member',
                    style: AppTypography.font(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: OrangeColors.primaryOrange,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Dedicated Full-Width Participant Name
          Text(
            NameFormatter.formatWithTitle(fullName, isArabic: isArabic),
            style: AppTypography.font(
              fontSize: 18.5.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.black,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),

          // Destination & Dates Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: OrangeColors.primaryOrange,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        (destination != null && destination!.isNotEmpty)
                            ? destination!
                            : (isArabic ? 'وجهة الرحلة الرسمية' : 'Official Destination'),
                        style: AppTypography.font(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (weatherTemp != null && weatherTemp!.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: OrangeColors.warmCream,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny_outlined, size: 13.sp, color: OrangeColors.primaryOrange),
                          SizedBox(width: 4.w),
                          Text(
                            weatherTemp!,
                            style: AppTypography.font(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: OrangeColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  if (tripDates != null && tripDates!.isNotEmpty)
                    Text(
                      tripDates!,
                      style: AppTypography.font(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: OrangeColors.secondaryText,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // 4-Block Countdown Timer (Minimal Soft Rounded Blocks)
          Row(
            children: [
              _buildTimeBlock(days.toString(), isArabic ? 'يوم' : 'Days', false),
              SizedBox(width: 8.w),
              _buildTimeBlock(hours.toString().padLeft(2, '0'), isArabic ? 'ساعة' : 'Hours', false),
              SizedBox(width: 8.w),
              _buildTimeBlock(minutes.toString().padLeft(2, '0'), isArabic ? 'دقيقة' : 'Min', false),
              SizedBox(width: 8.w),
              _buildTimeBlock(seconds.toString().padLeft(2, '0'), isArabic ? 'ثانية' : 'Sec', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(String value, String label, bool isAccent) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: OrangeColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isAccent ? OrangeColors.primaryOrange.withValues(alpha: 0.35) : OrangeColors.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.font(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: isAccent ? OrangeColors.primaryOrange : OrangeColors.black,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTypography.font(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isAccent ? OrangeColors.primaryOrange : OrangeColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
