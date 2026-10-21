import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_design_system.dart';
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
    final icon = isBus ? Icons.directions_bus_outlined : Icons.groups_outlined;
    final accentColor = isBus ? OrangeColors.primaryOrange : OrangeColors.white;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: OrangeColors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isBus ? OrangeColors.primaryOrange.withValues(alpha: 0.4) : OrangeColors.darkSecondaryText,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: accentColor,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.font(
                  color: OrangeColors.secondaryText,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                value.isNotEmpty ? value : (isArabic ? (isBus ? 'لم يتم التعيين' : 'غير محدد') : (isBus ? 'Unassigned' : 'Pending')),
                style: AppTypography.font(
                  color: accentColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
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
