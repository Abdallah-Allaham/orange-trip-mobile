import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/phone_launcher.dart';
import '../../../emergency/presentation/screens/emergency_contacts_screen.dart';

class EmergencyHotlinesCard extends StatelessWidget {
  final String medicalPhone;
  final String operationsPhone;
  final bool isArabic;

  const EmergencyHotlinesCard({
    super.key,
    required this.medicalPhone,
    required this.operationsPhone,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'الطوارئ والعمليات 24/7' : '24/7 Emergency & Operations',
                style: AppTypography.font(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EmergencyContactsScreen(),
                    ),
                  );
                },
                child: Text(
                  isArabic ? 'عرض الكل' : 'View All',
                  style: AppTypography.font(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: OrangeColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Medical Hotline Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.emergency_outlined, color: Colors.red, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    isArabic ? 'طوارئ السلامة والصحة' : 'Medical & Safety',
                    style: AppTypography.font(color: OrangeColors.black, fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              InkWell(
                onTap: () => launchPhoneCall(medicalPhone),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, size: 13.sp, color: Colors.red),
                      SizedBox(width: 5.w),
                      Text(
                        medicalPhone,
                        style: AppTypography.font(color: Colors.red, fontSize: 11.5.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 18.h, color: OrangeColors.lightBorder),

          // Operations Hotline Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.headset_mic_outlined, color: OrangeColors.primaryOrange, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    isArabic ? 'إدارة العمليات والتنقلات' : 'Operations Desk',
                    style: AppTypography.font(color: OrangeColors.black, fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              InkWell(
                onTap: () => launchPhoneCall(operationsPhone),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: OrangeColors.warmCream,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, size: 13.sp, color: OrangeColors.primaryOrange),
                      SizedBox(width: 5.w),
                      Text(
                        operationsPhone,
                        style: AppTypography.font(color: OrangeColors.primaryOrange, fontSize: 11.5.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
