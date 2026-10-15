import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/name_formatter.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String fullName;
  final String email;
  final bool isArabic;

  const ProfileHeaderCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: AppCards.primary(
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: OrangeColors.primaryOrange,
            child: Text(
              NameFormatter.getInitial(fullName),
              style: AppTypography.font(
                color: OrangeColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NameFormatter.formatWithTitle(fullName, isArabic: isArabic),
                  style: AppTypography.font(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: OrangeColors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  email,
                  style: AppTypography.font(
                    fontSize: 12.5.sp,
                    color: OrangeColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
