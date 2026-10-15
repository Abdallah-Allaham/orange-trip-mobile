import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/phone_launcher.dart';

class HotlineCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String phoneNumber;
  final String whatsappNumber;
  final bool isArabic;
  final bool isEmergency;

  const HotlineCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.isArabic,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: OrangeColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isEmergency ? Colors.red.withValues(alpha: 0.25) : OrangeColors.lightBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.font(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTypography.font(
                        fontSize: 11.sp,
                        color: OrangeColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: OrangeColors.lightBorder),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => launchPhoneCall(phoneNumber),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                      color: isEmergency ? Colors.red.withValues(alpha: 0.1) : OrangeColors.warmCream,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 15.sp,
                          color: isEmergency ? Colors.red : OrangeColors.primaryOrange,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          isArabic ? 'اتصال مباشر' : 'Direct Call',
                          style: AppTypography.font(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: isEmergency ? Colors.red : OrangeColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: InkWell(
                  onTap: () => launchWhatsApp(
                    whatsappNumber,
                    message: isArabic
                        ? 'مرحباً، أتواصل معكم بخصوص رحلة مدراء أورنج.'
                        : 'Hello, contacting regarding Orange Directors Trip.',
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 15.sp,
                          color: const Color(0xFF1EBE5D),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'WhatsApp',
                          style: AppTypography.font(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1EBE5D),
                          ),
                        ),
                      ],
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
