import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_brand_logo.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/widgets/orange_button.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../../../dashboard/presentation/widgets/announcement_card.dart';
import '../../../dashboard/presentation/widgets/executive_services_grid.dart';
import '../../../dashboard/presentation/widgets/flight_brief_card.dart';
import '../../../dashboard/presentation/widgets/hotel_brief_card.dart';
import '../../../dashboard/presentation/widgets/next_activity_card.dart';
import '../../../dashboard/presentation/widgets/trip_countdown_hero.dart';

class HomeTabScreen extends StatelessWidget {
  final UserEntity user;
  final Function(int) onNavigateToTab;

  const HomeTabScreen({
    super.key,
    required this.user,
    required this.onNavigateToTab,
  });

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

  String _formatTripDates(dynamic flight, dynamic hotel, dynamic tripSettings, List<dynamic> items, bool isAr) {
    if (tripSettings != null && tripSettings.startDate != null && tripSettings.startDate.toString().isNotEmpty) {
      try {
        final sDt = DateTime.parse(tripSettings.startDate.toString().trim());
        if (tripSettings.endDate != null && tripSettings.endDate.toString().isNotEmpty) {
          final eDt = DateTime.parse(tripSettings.endDate.toString().trim());
          final sStr = DateFormat('d MMM', 'en_US').format(sDt);
          final eStr = DateFormat('d MMM yyyy', 'en_US').format(eDt);
          return '$sStr – $eStr';
        }
        return DateFormat('d MMM yyyy', 'en_US').format(sDt);
      } catch (_) {}
    }
    return 'Nov 2026';
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBrandLogo(size: 52.w),
                SizedBox(height: 20.h),
                const CircularProgressIndicator(
                  color: OrangeColors.primaryOrange,
                  strokeWidth: 2.5,
                ),
                SizedBox(height: 14.h),
                Text(
                  'loading_dashboard'.tr(),
                  style: AppTypography.font(
                    fontSize: 13.sp,
                    color: OrangeColors.darkSecondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 48.sp, color: OrangeColors.primaryOrange),
                  SizedBox(height: 14.h),
                  Text(
                    'failed_load_logistics'.tr(),
                    style: AppTypography.font(fontSize: 15.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTypography.font(fontSize: 13.sp, color: OrangeColors.secondaryText),
                  ),
                  SizedBox(height: 20.h),
                  OrangeButton(
                    text: 'retry'.tr(),
                    height: 48.h,
                    onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DashboardLoaded) {
          final data = state.data;

          return RefreshIndicator(
            color: OrangeColors.primaryOrange,
            backgroundColor: OrangeColors.white,
            onRefresh: () async {
              await context.read<DashboardCubit>().refreshDashboard();
            },
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Hero Trip Countdown Card
                  TripCountdownHero(
                    fullName: data.fullName.isNotEmpty ? data.fullName : user.fullName,
                    role: data.role.isNotEmpty ? data.role : user.role,
                    assignedBus: data.assignedBus.isNotEmpty ? data.assignedBus : user.assignedBus,
                    assignedGroup: data.assignedGroup.isNotEmpty ? data.assignedGroup : user.assignedGroup,
                    countdownDuration: state.tripCountdown,
                    isArabic: isAr,
                    destination: _resolveDestination(data.flight, data.itinerarySummary, data.hotel, data.tripSettings, isAr),
                    tripDates: _formatTripDates(data.flight, data.hotel, data.tripSettings, data.allItineraryItems, isAr),
                    weatherTemp: data.tripSettings?.weatherTemp ?? data.itinerarySummary.weatherTemp,
                  ),
                  SizedBox(height: 16.h),

                  // 2. Broadcast Announcements List
                  if (data.announcements.isNotEmpty) ...[
                    for (final ann in data.announcements) ...[
                      AnnouncementCard(
                        announcement: ann,
                        isArabic: isAr,
                        onAcknowledge: () {
                          context.read<DashboardCubit>().acknowledgeAnnouncement(ann.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'announcement_ack_success'.tr(),
                                style: AppTypography.font(fontWeight: FontWeight.w600, color: OrangeColors.white),
                              ),
                              backgroundColor: OrangeColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 14.h),
                    ],
                  ],

                  // 3. Next Activity Interactive Card
                  NextActivityCard(
                    summary: data.itinerarySummary,
                    countdownDuration: state.nextActivityCountdown,
                    isArabic: isAr,
                    onDetailsTap: () => onNavigateToTab(2), // Jump to Itinerary
                  ),
                  SizedBox(height: 16.h),

                  // 4. Flight Logistics Brief Card
                  FlightBriefCard(
                    flight: data.flight,
                    isArabic: isAr,
                    tripSettings: data.tripSettings,
                  ),
                  SizedBox(height: 16.h),

                  // 5. Hotel Logistics Brief Card
                  HotelBriefCard(
                    hotel: data.hotel,
                    isArabic: isAr,
                    destinationCity: _resolveDestination(data.flight, data.itinerarySummary, data.hotel, data.tripSettings, isAr),
                    tripSettings: data.tripSettings,
                  ),
                  SizedBox(height: 16.h),

                  // 6. Quick Executive Services Grid
                  ExecutiveServicesGrid(
                    isArabic: isAr,
                    assignedBus: data.assignedBus,
                    onTabSelect: onNavigateToTab,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
