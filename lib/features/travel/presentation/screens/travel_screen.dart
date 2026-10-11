import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../../../dashboard/presentation/widgets/flight_brief_card.dart';
import '../../../dashboard/presentation/widgets/hotel_brief_card.dart';
import '../widgets/buses_section.dart';
import '../widgets/return_flight_card.dart';

class TravelScreen extends StatefulWidget {
  final UserEntity user;

  const TravelScreen({super.key, required this.user});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  int _travelSubTabIndex = 0; // 0 = Flights, 1 = VIP Buses, 2 = Hotel & Wi-Fi

  String _resolveDestination(dynamic flight, dynamic summary, dynamic hotel, dynamic tripSettings, bool isAr) {
    if (tripSettings != null) {
      final city = isAr ? tripSettings.destinationCityAr : tripSettings.destinationCityEn;
      if (city != null && city.toString().trim().isNotEmpty) return city.toString();
    }
    if (summary?.weatherCity != null && summary.weatherCity.toString().trim().isNotEmpty) {
      return summary.weatherCity.toString();
    }
    if (flight?.outboundRoute != null && flight.outboundRoute.toString().trim().isNotEmpty) {
      final route = flight.outboundRoute.toString();
      if (route.contains('→') || route.contains('->')) {
        final dest = route.contains('→') ? route.split('→').last : route.split('->').last;
        final cleaned = dest.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
        if (cleaned.isNotEmpty) return cleaned;
      }
    }
    return isAr ? 'وجهة الرحلة الرسمية' : 'Official Destination';
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final flight = data?.flight;
        final hotel = data?.hotel;
        final buses = data?.buses ?? [];
        final assignedBus = data?.assignedBus.isNotEmpty == true ? data!.assignedBus : widget.user.assignedBus;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'travel_and_logistics'.tr(),
                style: AppTypography.font(fontSize: 18.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
              ),
              SizedBox(height: 14.h),

              // Sub-Tabs Segmented Bar (Flights, VIP Buses, Hotel & Wi-Fi)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: OrangeColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: OrangeColors.lightBorder),
                ),
                child: Row(
                  children: [
                    _buildSubTabButton(
                      index: 0,
                      label: 'flight_tickets'.tr(),
                    ),
                    _buildSubTabButton(
                      index: 1,
                      label: 'vip_buses'.tr(),
                    ),
                    _buildSubTabButton(
                      index: 2,
                      label: 'hotel_wifi'.tr(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // SUB-TAB 0: FLIGHTS
              if (_travelSubTabIndex == 0) ...[
                if (flight != null) ...[
                  FlightBriefCard(flight: flight, isArabic: isAr, tripSettings: data?.tripSettings),
                  SizedBox(height: 14.h),
                ],
                ReturnFlightCard(
                  flight: flight,
                  tripSettings: data?.tripSettings,
                  isArabic: isAr,
                ),
              ],

              // SUB-TAB 1: VIP BUSES FLEET
              if (_travelSubTabIndex == 1) ...[
                BusesSection(
                  buses: buses,
                  assignedBus: assignedBus,
                  isArabic: isAr,
                ),
              ],

              // SUB-TAB 2: HOTEL & WI-FI
              if (_travelSubTabIndex == 2) ...[
                if (hotel != null) ...[
                  HotelBriefCard(
                    hotel: hotel,
                    isArabic: isAr,
                    destinationCity: _resolveDestination(flight, null, hotel, data?.tripSettings, isAr),
                    tripSettings: data?.tripSettings,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubTabButton({
    required int index,
    required String label,
  }) {
    final isSelected = _travelSubTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _travelSubTabIndex = index),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? OrangeColors.primaryOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.font(
                fontSize: 11.5.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? OrangeColors.white : OrangeColors.darkSecondaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
