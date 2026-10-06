import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../domain/entities/hotel_entity.dart';

class HotelBriefCard extends StatelessWidget {
  final HotelEntity hotel;
  final bool isArabic;
  final String? destinationCity;

  const HotelBriefCard({
    super.key,
    required this.hotel,
    required this.isArabic,
    this.destinationCity,
  });

  String _extractWifiPassword() {
    final instructions = hotel.wifiInstructions.trim();
    if (instructions.isEmpty) return 'Available in Lobby';
    if (instructions.contains('Pass:')) {
      final part = instructions.split('Pass:').last.trim();
      return part.split(' ').first;
    }
    if (instructions.contains('Password:')) {
      final part = instructions.split('Password:').last.trim();
      return part.split(' ').first;
    }
    return instructions;
  }

  String _extractCity() {
    if (destinationCity != null && destinationCity!.trim().isNotEmpty) {
      return destinationCity!.trim();
    }
    final addr = isArabic ? hotel.hotelAddressAr : hotel.hotelAddressEn;
    if (addr.isNotEmpty) {
      final parts = addr.split(',');
      if (parts.length >= 2) {
        return parts[parts.length - 2].trim();
      }
      return parts.last.trim();
    }
    return isArabic ? 'مقر الإقامة' : 'Stay';
  }

  void _copyWifi(BuildContext context, String pass) {
    Clipboard.setData(ClipboardData(text: pass));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'تم نسخ كلمة مرور الواي فاي ($pass)' : 'Wi-Fi password copied ($pass)',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: OrangeColors.white),
        ),
        backgroundColor: OrangeColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wifiPass = _extractWifiPassword();
    final cityBadge = _extractCity();
    final checkIn = hotel.checkInDate.isNotEmpty ? hotel.checkInDate : 'Check-In upon arrival';
    final checkOut = hotel.checkOutDate.isNotEmpty ? hotel.checkOutDate : 'Check-Out upon departure';

    return Container(
      padding: AppSpacing.cardPaddingCompact,
      decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Hotel Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.hotel_outlined, color: OrangeColors.primaryOrange, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        hotel.hotelName,
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: OrangeColors.lightGray,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  cityBadge,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: OrangeColors.darkSecondaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Check-in and Check-out Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: OrangeColors.background,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'تسجيل الوصول' : 'Check-In',
                        style: GoogleFonts.cairo(fontSize: 11.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        checkIn,
                        style: GoogleFonts.cairo(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isArabic ? 'تسجيل المغادرة' : 'Check-Out',
                        style: GoogleFonts.cairo(fontSize: 11.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        checkOut,
                        style: GoogleFonts.cairo(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Wi-Fi Password Box (Warm Cream)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: OrangeColors.warmCream,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.wifi, size: 16.sp, color: OrangeColors.primaryOrange),
                      SizedBox(width: 8.w),
                      Text(
                        isArabic ? 'الواي فاي: ' : 'Wi-Fi: ',
                        style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                      ),
                      Flexible(
                        child: Text(
                          wifiPass,
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: OrangeColors.primaryOrange,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _copyWifi(context, wifiPass),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArabic ? 'نسخ' : 'Copy',
                          style: GoogleFonts.cairo(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: OrangeColors.primaryOrange,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.copy, size: 13.sp, color: OrangeColors.primaryOrange),
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
