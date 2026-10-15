import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

class PrivacyConsentCard extends StatelessWidget {
  final bool dataNoticeAccepted;
  final bool mediaConsentGranted;
  final ValueChanged<bool> onMediaConsentChanged;
  final bool isArabic;

  const PrivacyConsentCard({
    super.key,
    required this.dataNoticeAccepted,
    required this.mediaConsentGranted,
    required this.onMediaConsentChanged,
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
            isArabic ? 'الخصوصية والموافقات الرسمية' : 'Privacy & Consents',
            style: AppTypography.font(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.black,
            ),
          ),
          SizedBox(height: 12.h),

          // Data Notice Consent Tile
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: OrangeColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.verified_user_outlined, color: OrangeColors.success, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'إشعار الخصوصية ومعالجة البيانات' : 'Privacy & Data Processing Notice',
                      style: AppTypography.font(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isArabic ? 'معتمد وفقاً لمعايير أمن المعلومات وحماية البيانات' : 'Approved per Orange enterprise privacy standards',
                      style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: OrangeColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  dataNoticeAccepted ? (isArabic ? 'معتمد' : 'Accepted') : (isArabic ? 'معلق' : 'Pending'),
                  style: AppTypography.font(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: dataNoticeAccepted ? OrangeColors.success : OrangeColors.darkSecondaryText,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: OrangeColors.lightBorder),

          // Media Coverage Consent Tile
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: OrangeColors.primaryOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.camera_alt_outlined, color: OrangeColors.primaryOrange, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'الموافقة على التغطية الإعلامية' : 'Media Coverage & Photos',
                      style: AppTypography.font(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isArabic
                          ? 'الظهور في الصور والتغطية المرئية الرسمية للرحلة'
                          : 'Appear in official trip photography and highlights',
                      style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Switch(
                value: mediaConsentGranted,
                activeThumbColor: OrangeColors.primaryOrange,
                onChanged: onMediaConsentChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
