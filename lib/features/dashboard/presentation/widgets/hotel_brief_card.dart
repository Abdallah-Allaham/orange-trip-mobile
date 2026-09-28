import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/hotel_entity.dart';

class HotelBriefCard extends StatelessWidget {
  final HotelEntity hotel;
  final bool isArabic;

  const HotelBriefCard({
    super.key,
    required this.hotel,
    required this.isArabic,
  });

  void _copyWifi(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: 'OrangeCairo2026'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'تم نسخ كلمة مرور الواي فاي (OrangeCairo2026)' : 'Wi-Fi password copied (OrangeCairo2026)',
        ),
        backgroundColor: OrangeColors.coreBlack,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Hotel Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hotel.hotelName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: OrangeColors.coreBlack,
                ),
              ),
              Text(
                'Cairo',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: OrangeColors.mediumGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Check-in and Check-out Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: OrangeColors.lightGrey,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'تسجيل الوصول' : 'Check-In',
                      style: TextStyle(fontSize: 10.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '2 Nov 2026, 14:00',
                      style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w800, color: OrangeColors.coreBlack),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isArabic ? 'تسجيل المغادرة' : 'Check-Out',
                      style: TextStyle(fontSize: 10.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '5 Nov 2026, 12:00',
                      style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w800, color: OrangeColors.coreBlack),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Wi-Fi Password with Copy button (no SSID, just Password and Copy)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EB),
              borderRadius: BorderRadius.circular(3.r),
              border: Border.all(color: OrangeColors.brandOrange.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      isArabic ? 'كلمة مرور الواي فاي: ' : 'Wi-Fi Password: ',
                      style: TextStyle(fontSize: 11.sp, color: OrangeColors.darkGrey, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'OrangeCairo2026',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: OrangeColors.brandOrange,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => _copyWifi(context),
                  borderRadius: BorderRadius.circular(2.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArabic ? 'نسخ' : 'Copy',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: OrangeColors.brandOrange,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.copy, size: 13.sp, color: OrangeColors.brandOrange),
                      ],
                    ),
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
