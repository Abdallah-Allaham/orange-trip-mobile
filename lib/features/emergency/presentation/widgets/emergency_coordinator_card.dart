import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/phone_launcher.dart';
import '../../../dashboard/domain/entities/emergency_contact_entity.dart';

class EmergencyCoordinatorCard extends StatelessWidget {
  final EmergencyContactEntity contact;
  final bool isArabic;

  const EmergencyCoordinatorCard({
    super.key,
    required this.contact,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final role = isArabic && contact.roleAr.isNotEmpty ? contact.roleAr : contact.roleEn;
    final description = isArabic && contact.descriptionAr != null && contact.descriptionAr!.isNotEmpty
        ? contact.descriptionAr!
        : (contact.descriptionEn ?? '');
    final whatsapp = contact.whatsapp?.isNotEmpty == true ? contact.whatsapp! : contact.phone;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(18.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: OrangeColors.primaryOrange.withValues(alpha: 0.12),
                child: Icon(Icons.person, color: OrangeColors.primaryOrange, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: AppTypography.font(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.black,
                      ),
                    ),
                    if (role.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        role,
                        style: AppTypography.font(
                          fontSize: 11.5.sp,
                          color: OrangeColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              description,
              style: AppTypography.font(
                fontSize: 11.sp,
                color: OrangeColors.secondaryText,
                height: 1.35,
              ),
            ),
          ],
          Divider(height: 20.h, color: OrangeColors.lightBorder),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => launchPhoneCall(contact.phone),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: OrangeColors.warmCream,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_outlined, size: 14.sp, color: OrangeColors.primaryOrange),
                        SizedBox(width: 6.w),
                        Text(
                          isArabic ? 'اتصال' : 'Call',
                          style: AppTypography.font(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: OrangeColors.primaryOrange,
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
                    whatsapp,
                    message: isArabic
                        ? 'مرحباً، أتواصل معك بخصوص رحلة مدراء أورنج.'
                        : 'Hello, contacting you regarding Orange Directors Trip.',
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 14.sp, color: const Color(0xFF1EBE5D)),
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
