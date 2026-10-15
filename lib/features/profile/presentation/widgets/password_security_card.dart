import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import 'change_password_dialog.dart';

class PasswordSecurityCard extends StatelessWidget {
  const PasswordSecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'password_security'.tr(),
            style: AppTypography.font(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.darkSecondaryText,
            ),
          ),
          TextButton(
            onPressed: () => showChangePasswordDialog(context),
            child: Text(
              'change_password'.tr(),
              style: AppTypography.font(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
                color: OrangeColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
