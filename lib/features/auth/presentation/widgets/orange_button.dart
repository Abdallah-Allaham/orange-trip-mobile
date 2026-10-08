import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isDark;
  final bool isDestructive;
  final IconData? icon;
  final double? height;

  const OrangeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDark = false,
    this.isDestructive = false,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 54.h;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: OrangeColors.primaryOrange, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          backgroundColor: Colors.transparent,
          minimumSize: Size(double.infinity, effectiveHeight),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
        child: _buildChild(context, OrangeColors.primaryOrange),
      );
    }

    Color bgColor = OrangeColors.primaryOrange;
    Color textColor = OrangeColors.white;

    if (isDark) {
      bgColor = OrangeColors.black;
      textColor = OrangeColors.white;
    } else if (isDestructive) {
      bgColor = OrangeColors.error;
      textColor = OrangeColors.white;
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
        elevation: 0,
        minimumSize: Size(double.infinity, effectiveHeight),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      ),
      child: _buildChild(context, textColor),
    );
  }

  Widget _buildChild(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          color: textColor,
        ),
      );
    }

    final textWidget = Text(
      text,
      style: AppTypography.font(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: textColor),
          SizedBox(width: 8.w),
          textWidget,
        ],
      );
    }

    return textWidget;
  }
}
