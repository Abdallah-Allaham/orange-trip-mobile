import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

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
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: OrangeColors.darkGrey,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 8.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 2.3,
          children: [
            _buildServiceItem(
              icon: Icons.calendar_month,
              title: isArabic ? 'جدول الفعاليات' : 'Full Itinerary',
              subtitle: isArabic ? 'الأجندة الكاملة' : 'Summit Agenda',
              onTap: () => onTabSelect(2), // Tab 2 = Itinerary
            ),
            _buildServiceItem(
              icon: Icons.hotel,
              title: isArabic ? 'الفندق والواي فاي' : 'Hotel & Wi-Fi',
              subtitle: 'The St. Regis Cairo',
              onTap: () => onTabSelect(1), // Tab 1 = Travel
            ),
            _buildServiceItem(
              icon: Icons.directions_bus,
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
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: OrangeColors.coreWhite,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: OrangeColors.borderGrey),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: OrangeColors.lightGrey,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Icon(icon, color: OrangeColors.brandOrange, size: 16.sp),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: OrangeColors.coreBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: OrangeColors.mediumGrey,
                      fontWeight: FontWeight.w600,
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
