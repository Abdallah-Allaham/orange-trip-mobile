import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

enum BadgeType { bus, group }

class BusGroupBadge extends StatelessWidget {
  final BadgeType type;
  final String value;
  final bool isArabic;

  const BusGroupBadge({
    super.key,
    required this.type,
    required this.value,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    final isBus = type == BadgeType.bus;
    final label = isBus
        ? (isArabic ? 'الحافلة المخصصة' : 'Assigned Bus')
        : (isArabic ? 'المجموعة التنفيذية' : 'Assigned Group');
    final icon = isBus ? Icons.directions_bus : Icons.groups;
    final accentColor = isBus ? OrangeColors.brandOrange : OrangeColors.coreWhite;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: OrangeColors.coreBlack,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isBus ? OrangeColors.brandOrange.withValues(alpha: 0.5) : OrangeColors.darkGrey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15.sp,
            color: accentColor,
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: OrangeColors.mediumGrey,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                value.isNotEmpty ? value : (isBus ? 'Bus 1' : 'Group Alpha'),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
