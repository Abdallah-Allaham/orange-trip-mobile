import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

void showChangePasswordDialog(BuildContext context, [bool? isArabic]) {
  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmPwController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
      title: Text(
        'change_password'.tr(),
        style: AppTypography.font(fontSize: 16.sp, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'current_password'.tr(),
                labelStyle: AppTypography.font(fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: newPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'new_password'.tr(),
                labelStyle: AppTypography.font(fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: confirmPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'confirm_password'.tr(),
                labelStyle: AppTypography.font(fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            'cancel'.tr(),
            style: AppTypography.font(color: OrangeColors.secondaryText, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: OrangeColors.primaryOrange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
          onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'password_updated_success'.tr(),
                  style: AppTypography.font(fontWeight: FontWeight.w600, color: OrangeColors.white),
                ),
                backgroundColor: OrangeColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
            );
          },
          child: Text(
            'update'.tr(),
            style: AppTypography.font(color: OrangeColors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
