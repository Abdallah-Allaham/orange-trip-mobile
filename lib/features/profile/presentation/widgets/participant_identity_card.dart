import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

class ParticipantIdentityCard extends StatelessWidget {
  final String employeeId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isArabic;

  const ParticipantIdentityCard({
    super.key,
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'البيانات الرسمية للمشارك' : 'Official Participant Identity',
            style: AppTypography.font(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.black,
            ),
          ),
          SizedBox(height: 14.h),
          _buildInfoTile(
            icon: Icons.badge_outlined,
            label: isArabic ? 'الرقم الوظيفي' : 'Employee ID',
            value: employeeId,
          ),
          Divider(height: 16.h, color: OrangeColors.lightBorder),
          _buildInfoTile(
            icon: Icons.person_outline,
            label: isArabic ? 'الاسم الكامل' : 'Full Name',
            value: fullName,
          ),
          Divider(height: 16.h, color: OrangeColors.lightBorder),
          _buildInfoTile(
            icon: Icons.email_outlined,
            label: isArabic ? 'البريد المؤسسي' : 'Company Email',
            value: email,
          ),
          Divider(height: 16.h, color: OrangeColors.lightBorder),
          _buildInfoTile(
            icon: Icons.phone_android_outlined,
            label: isArabic ? 'رقم الهاتف' : 'Phone Number',
            value: phoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: OrangeColors.primaryOrange),
        SizedBox(width: 12.w),
        Text(
          label,
          style: AppTypography.font(
            fontSize: 12.sp,
            color: OrangeColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.font(
            fontSize: 12.5.sp,
            color: OrangeColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
