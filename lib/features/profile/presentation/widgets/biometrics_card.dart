import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

class BiometricsCard extends StatelessWidget {
  final bool isBiometricsEnabled;
  final ValueChanged<bool> onToggle;

  const BiometricsCard({
    super.key,
    required this.isBiometricsEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
      child: SwitchListTile(
        value: isBiometricsEnabled,
        title: Text(
          'biometric_unlock_title'.tr(),
          style: AppTypography.font(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'biometric_unlock_subtitle'.tr(),
          style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText),
        ),
        secondary: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: OrangeColors.warmCream,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(Icons.fingerprint, color: OrangeColors.primaryOrange, size: 22.sp),
        ),
        onChanged: onToggle,
      ),
    );
  }
}
