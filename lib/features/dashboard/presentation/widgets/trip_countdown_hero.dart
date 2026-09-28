import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

class TripCountdownHero extends StatelessWidget {
  final String fullName;
  final String role;
  final String assignedBus;
  final String assignedGroup;
  final Duration countdownDuration;
  final bool isArabic;

  const TripCountdownHero({
    super.key,
    required this.fullName,
    required this.role,
    required this.assignedBus,
    required this.assignedGroup,
    required this.countdownDuration,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final days = countdownDuration.inDays;
    final hours = countdownDuration.inHours.remainder(24);
    final minutes = countdownDuration.inMinutes.remainder(60);
    final seconds = countdownDuration.inSeconds.remainder(60);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: OrangeColors.coreWhite,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: OrangeColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Welcome & VIP Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: OrangeColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            isArabic ? 'مرحباً، $fullName' : 'Welcome, $fullName',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: OrangeColors.coreBlack,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Trip Title & Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: OrangeColors.brandOrange,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isArabic ? 'رحلة القاهرة 2026' : 'Cairo, Egypt 2026',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: OrangeColors.coreBlack,
                    ),
                  ),
                ],
              ),
              Text(
                '2 Nov – 5 Nov 2026',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: OrangeColors.darkGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // 4-Block Countdown Timer
          Row(
            children: [
              _buildTimeBlock(days.toString(), isArabic ? 'يوم' : 'Days', false),
              SizedBox(width: 6.w),
              _buildTimeBlock(hours.toString().padLeft(2, '0'), isArabic ? 'ساعة' : 'Hours', false),
              SizedBox(width: 6.w),
              _buildTimeBlock(minutes.toString().padLeft(2, '0'), isArabic ? 'دقيقة' : 'Min', false),
              SizedBox(width: 6.w),
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
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isAccent ? const Color(0xFFFFF5EB) : OrangeColors.lightGrey,
          borderRadius: BorderRadius.circular(3.r),
          border: Border.all(
            color: isAccent ? OrangeColors.brandOrange.withValues(alpha: 0.5) : OrangeColors.borderGrey,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: isAccent ? OrangeColors.brandOrange : OrangeColors.coreBlack,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: isAccent ? OrangeColors.accessibleOrange : OrangeColors.mediumGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
