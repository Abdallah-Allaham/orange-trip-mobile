import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../domain/entities/hotel_entity.dart';
import '../../domain/entities/trip_settings_entity.dart';

class HotelBriefCard extends StatelessWidget {
  final HotelEntity hotel;
  final bool isArabic;
  final String? destinationCity;
  final TripSettingsEntity? tripSettings;

  const HotelBriefCard({
    super.key,
    required this.hotel,
    required this.isArabic,
    this.destinationCity,
    this.tripSettings,
  });

  String _extractWifiPassword() {
    if (tripSettings != null && tripSettings!.wifiPassword.isNotEmpty) {
      return tripSettings!.wifiPassword;
    }
    if (hotel.wifiPassword.isNotEmpty) {
      return hotel.wifiPassword;
    }
    final instructions = hotel.wifiInstructions.trim();
    if (instructions.isEmpty) return 'OrangeCairo2026';
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

  String _extractWifiNetwork() {
    if (tripSettings != null && tripSettings!.wifiNetwork.isNotEmpty) {
      return tripSettings!.wifiNetwork;
    }
    if (hotel.wifiNetwork.isNotEmpty) {
      return hotel.wifiNetwork;
    }
    final instructions = hotel.wifiInstructions.trim();
    if (instructions.contains('Network:')) {
      final part = instructions.split('Network:').last.split('|').first.trim();
      if (part.isNotEmpty) return part;
    }
    return 'StRegis_Guest';
  }

  String _extractCity() {
    if (tripSettings != null && tripSettings!.destinationCityEn.isNotEmpty) {
      return isArabic && tripSettings!.destinationCityAr.isNotEmpty
          ? tripSettings!.destinationCityAr
          : tripSettings!.destinationCityEn;
    }
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

  void _copyWifi(BuildContext context, String val, String label) {
    Clipboard.setData(ClipboardData(text: val));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'تم نسخ $label ($val)' : '$label copied ($val)',
          style: AppTypography.font(fontWeight: FontWeight.w600, color: OrangeColors.white),
        ),
        backgroundColor: OrangeColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openMap(BuildContext context, String url) async {
    final clean = url.trim();
    if (clean.isEmpty) return;
    try {
      final uri = Uri.parse(clean);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic ? 'تعذر فتح الرابط' : 'Could not open map link',
              style: AppTypography.font(fontWeight: FontWeight.w600, color: OrangeColors.white),
            ),
            backgroundColor: OrangeColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wifiNetwork = _extractWifiNetwork();
    final wifiPass = _extractWifiPassword();
    final cityBadge = _extractCity();
    final displayHotelName = (tripSettings != null && tripSettings!.hotelName.isNotEmpty)
        ? tripSettings!.hotelName
        : hotel.hotelName;
    final checkIn = (tripSettings != null && tripSettings!.startDate.isNotEmpty)
        ? '${tripSettings!.startDate}, 14:00'
        : (hotel.checkInDate.isNotEmpty ? hotel.checkInDate : 'Check-In upon arrival');
    final checkOut = (tripSettings != null && tripSettings!.endDate.isNotEmpty)
        ? '${tripSettings!.endDate}, 12:00'
        : (hotel.checkOutDate.isNotEmpty ? hotel.checkOutDate : 'Check-Out upon departure');

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
                        displayHotelName,
                        style: AppTypography.font(
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
                  style: AppTypography.font(
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
                        style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        checkIn,
                        style: AppTypography.font(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
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
                        style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        checkOut,
                        style: AppTypography.font(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Wi-Fi Box (Network & Password)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: OrangeColors.warmCream,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: [
                // Wi-Fi Network Name (SSID)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.wifi, size: 16.sp, color: OrangeColors.primaryOrange),
                          SizedBox(width: 8.w),
                          Text(
                            isArabic ? 'الشبكة: ' : 'Network: ',
                            style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                          ),
                          Flexible(
                            child: Text(
                              wifiNetwork,
                              style: AppTypography.font(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: OrangeColors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _copyWifi(context, wifiNetwork, isArabic ? 'اسم الشبكة' : 'Wi-Fi Network'),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isArabic ? 'نسخ' : 'Copy',
                              style: AppTypography.font(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: OrangeColors.primaryOrange,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.copy, size: 12.sp, color: OrangeColors.primaryOrange),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 14.h, thickness: 0.8, color: OrangeColors.lightBorder),
                // Wi-Fi Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, size: 16.sp, color: OrangeColors.primaryOrange),
                          SizedBox(width: 8.w),
                          Text(
                            isArabic ? 'كلمة السر: ' : 'Password: ',
                            style: AppTypography.font(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                          ),
                          Flexible(
                            child: Text(
                              wifiPass,
                              style: AppTypography.font(
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
                      onTap: () => _copyWifi(context, wifiPass, isArabic ? 'كلمة المرور' : 'Wi-Fi Password'),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isArabic ? 'نسخ' : 'Copy',
                              style: AppTypography.font(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: OrangeColors.primaryOrange,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.copy, size: 12.sp, color: OrangeColors.primaryOrange),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Google Maps Action Button (Conditional: only shown when mapUrl is provided by admin)
          if (hotel.mapUrl.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            InkWell(
              onTap: () => _openMap(context, hotel.mapUrl),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: OrangeColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: OrangeColors.lightBorder, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: OrangeColors.primaryOrange),
                    SizedBox(width: 8.w),
                    Text(
                      isArabic ? 'فتح موقع الفندق على الخريطة' : 'Open Hotel Location in Maps',
                      style: AppTypography.font(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.black,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.open_in_new, size: 13.sp, color: OrangeColors.secondaryText),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
