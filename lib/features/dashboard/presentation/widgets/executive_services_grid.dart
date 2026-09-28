import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

class ExecutiveServicesGrid extends StatelessWidget {
  final bool isArabic;
  final Function(int) onTabSelect;
  final String assignedBus;

  const ExecutiveServicesGrid({
    super.key,
    required this.isArabic,
    required this.onTabSelect,
    required this.assignedBus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الخدمات اللوجستية السريعة' : 'Executive Quick Logistics',
          style: GoogleFonts.cairo(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: OrangeColors.darkSecondaryText,
          ),
        ),
        SizedBox(height: 10.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 2.1,
          children: [
            _buildServiceItem(
              icon: Icons.calendar_month_outlined,
              title: isArabic ? 'جدول الفعاليات' : 'Full Itinerary',
              subtitle: isArabic ? 'الأجندة الكاملة' : 'Summit Agenda',
              onTap: () => onTabSelect(2), // Tab 2 = Itinerary
            ),
            _buildServiceItem(
              icon: Icons.hotel_outlined,
              title: isArabic ? 'الفندق والواي فاي' : 'Hotel & Wi-Fi',
              subtitle: 'The St. Regis Cairo',
              onTap: () => onTabSelect(1), // Tab 1 = Travel
            ),
            _buildServiceItem(
              icon: Icons.directions_bus_outlined,
              title: isArabic ? 'حافلات النقل' : 'VIP Buses',
              subtitle: isArabic ? 'مواعيد الرحلات' : 'Buses & Shuttles',
              onTap: () => onTabSelect(1), // Tab 1 = Travel
            ),
            _buildServiceItem(
              icon: Icons.person_outline,
              title: isArabic ? 'الملف الشخصي' : 'My Profile',
              subtitle: isArabic ? 'إعدادات الحساب' : 'Account & Security',
              onTap: () => onTabSelect(3), // Tab 3 = Profile
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: OrangeColors.warmCream,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: OrangeColors.primaryOrange, size: 18.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: OrangeColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 10.sp,
                      color: OrangeColors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
