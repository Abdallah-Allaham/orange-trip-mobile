import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_design_system.dart';

class LanguageSelectorCard extends StatelessWidget {
  final bool isArabic;

  const LanguageSelectorCard({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'app_language'.tr(),
            style: AppTypography.font(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: OrangeColors.darkSecondaryText,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (context.locale.languageCode != 'en') {
                      await context.setLocale(const Locale('en'));
                      await sl<SecureStorageService>().setLanguage('en');
                    }
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: !isArabic ? OrangeColors.primaryOrange : OrangeColors.lightGray,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        'English',
                        style: AppTypography.font(
                          fontSize: 12.sp,
                          fontWeight: !isArabic ? FontWeight.w700 : FontWeight.w500,
                          color: !isArabic ? OrangeColors.white : OrangeColors.darkSecondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (context.locale.languageCode != 'ar') {
                      await context.setLocale(const Locale('ar'));
                      await sl<SecureStorageService>().setLanguage('ar');
                    }
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isArabic ? OrangeColors.primaryOrange : OrangeColors.lightGray,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        'العربية',
                        style: AppTypography.font(
                          fontSize: 12.sp,
                          fontWeight: isArabic ? FontWeight.w700 : FontWeight.w500,
                          color: isArabic ? OrangeColors.white : OrangeColors.darkSecondaryText,
                        ),
                      ),
                    ),
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
