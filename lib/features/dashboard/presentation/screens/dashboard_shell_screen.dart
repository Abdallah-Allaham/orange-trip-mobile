import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_brand_logo.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/orange_button.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/phone_launcher.dart';
import '../../domain/entities/bus_entity.dart';
import '../../domain/entities/itinerary_item_entity.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/announcement_card.dart';
import '../widgets/executive_services_grid.dart';
import '../widgets/flight_brief_card.dart';
import '../widgets/hotel_brief_card.dart';
import '../widgets/next_activity_card.dart';
import '../widgets/trip_countdown_hero.dart';
import '../../../../core/utils/name_formatter.dart';

class DashboardShellScreen extends StatelessWidget {
  final UserEntity user;

  const DashboardShellScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => sl<DashboardCubit>()..loadDashboard(),
      child: _DashboardShellView(user: user),
    );
  }
}

class _DashboardShellView extends StatefulWidget {
  final UserEntity user;

  const _DashboardShellView({required this.user});

  @override
  State<_DashboardShellView> createState() => _DashboardShellViewState();
}

class _DashboardShellViewState extends State<_DashboardShellView> {
  int _currentTabIndex = 0;
  int _travelSubTabIndex = 0; // 0 = Flights, 1 = VIP Buses, 2 = Hotel & Wi-Fi
  String _selectedItineraryDay = 'all';

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
          final sStr = DateFormat('d MMM', isAr ? 'ar' : 'en').format(sDt);
          final eStr = DateFormat('d MMM yyyy', isAr ? 'ar' : 'en').format(eDt);
          return '$sStr – $eStr';
        }
        return DateFormat('d MMM yyyy', isAr ? 'ar' : 'en').format(sDt);
      } catch (_) {}
    }
    if (flight?.outboundDepartureTime != null && flight.outboundDepartureTime.toString().isNotEmpty) {
      try {
        final depDt = DateTime.parse(flight.outboundDepartureTime.toString().replaceAll(' ', 'T'));
        if (flight?.returnDepartureTime != null && flight.returnDepartureTime.toString().isNotEmpty) {
          final retDt = DateTime.parse(flight.returnDepartureTime.toString().replaceAll(' ', 'T'));
          final depStr = DateFormat('d MMM', isAr ? 'ar' : 'en').format(depDt);
          final retStr = DateFormat('d MMM yyyy', isAr ? 'ar' : 'en').format(retDt);
          return '$depStr – $retStr';
        }
        return DateFormat('d MMM yyyy', isAr ? 'ar' : 'en').format(depDt);
      } catch (_) {}
    }
    if (hotel?.checkInDate != null && hotel.checkInDate.toString().isNotEmpty) {
      final inDate = hotel.checkInDate.toString().split(',').first;
      final outDate = hotel.checkOutDate?.toString().split(',').first ?? '';
      if (outDate.isNotEmpty) return '$inDate – $outDate';
      return inDate;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final strings = AppStrings(context.locale.languageCode);

    return Scaffold(
      backgroundColor: OrangeColors.background,
      appBar: AppBar(
        backgroundColor: OrangeColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: OrangeColors.lightBorder,
            height: 1,
          ),
        ),
        iconTheme: const IconThemeData(color: OrangeColors.black),
        title: Row(
          children: [
            AppBrandLogo(size: 30.w),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.appTitle,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: OrangeColors.black,
                    height: 1.2,
                  ),
                ),
                Text(
                  NameFormatter.formatWithTitle(widget.user.fullName, isArabic: isAr),
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: OrangeColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: OrangeColors.black, size: 20.sp),
            tooltip: strings.logout,
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: _buildCurrentTab(strings, isAr),
      bottomNavigationBar: _buildModernBottomNav(strings),
    );
  }

  // =========================================================================
  // MODERN MINIMAL BOTTOM NAVIGATION BAR
  // Specification:
  // INACTIVE ITEM: Gray icon (#8F8F8F), Gray label (#8F8F8F).
  // ACTIVE ITEM: Orange rounded container (#FF7900), White icon (#FFFFFF), Black label (#000000).
  // =========================================================================
  Widget _buildModernBottomNav(AppStrings strings) {
    return Container(
      decoration: const BoxDecoration(
        color: OrangeColors.white,
        border: Border(
          top: BorderSide(color: OrangeColors.lightBorder, width: 1.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: strings.dashboard,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.flight_outlined,
              activeIcon: Icons.flight,
              label: strings.travel,
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.calendar_month_outlined,
              activeIcon: Icons.calendar_month,
              label: strings.itinerary,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: strings.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentTabIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentTabIndex = index),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: OrangeColors.primaryOrange,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  activeIcon,
                  size: 20.sp,
                  color: OrangeColors.white,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Icon(
                  icon,
                  size: 22.sp,
                  color: OrangeColors.secondaryText,
                ),
              ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? OrangeColors.black : OrangeColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildCurrentTab(AppStrings strings, bool isAr) {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab(strings, isAr);
      case 1:
        return _buildTravelTab(strings, isAr);
      case 2:
        return _buildItineraryTab(strings, isAr);
      case 3:
        return _buildProfileTab(strings, isAr);
      default:
        return _buildHomeTab(strings, isAr);
    }
  }

  // =========================================================================
  // TAB 1: EXECUTIVE HOME DASHBOARD
  // =========================================================================
  Widget _buildHomeTab(AppStrings strings, bool isAr) {
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
                  isAr ? 'جاري تحميل لوحة القيادة اللوجستية...' : 'Loading Executive Dashboard...',
                  style: GoogleFonts.cairo(
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
                    isAr ? 'تعذر جلب بيانات السفر والجدول الزمني' : 'Failed to load trip logistics',
                    style: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(fontSize: 13.sp, color: OrangeColors.secondaryText),
                  ),
                  SizedBox(height: 20.h),
                  OrangeButton(
                    text: isAr ? 'إعادة المحاولة' : 'Retry',
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
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Hero Trip Countdown Card (Primary Card: #FFF3E8, 24r)
                  TripCountdownHero(
                    fullName: data.fullName.isNotEmpty ? data.fullName : widget.user.fullName,
                    role: data.role.isNotEmpty ? data.role : widget.user.role,
                    assignedBus: data.assignedBus.isNotEmpty ? data.assignedBus : widget.user.assignedBus,
                    assignedGroup: data.assignedGroup.isNotEmpty ? data.assignedGroup : widget.user.assignedGroup,
                    countdownDuration: state.tripCountdown,
                    isArabic: isAr,
                    destination: _resolveDestination(data.flight, data.itinerarySummary, data.hotel, data.tripSettings, isAr),
                    tripDates: _formatTripDates(data.flight, data.hotel, data.tripSettings, data.allItineraryItems, isAr),
                    weatherTemp: data.tripSettings?.weatherTemp ?? data.itinerarySummary.weatherTemp,
                  ),
                  SizedBox(height: 16.h),

                  // 2. Broadcast Announcements List (all announcements)
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
                                isAr ? 'تم تأكيد الاطلاع على التنبيه الإداري' : 'Announcement acknowledged successfully',
                                style: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: OrangeColors.white),
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

                  // 3. Next Activity Interactive Card ("شو في عنا كمان ساعة")
                  NextActivityCard(
                    summary: data.itinerarySummary,
                    countdownDuration: state.nextActivityCountdown,
                    isArabic: isAr,
                    onDetailsTap: () => setState(() => _currentTabIndex = 2),
                  ),
                  SizedBox(height: 16.h),

                  // 4. Flight Logistics Brief Card (Outbound RJ Flight)
                  FlightBriefCard(
                    flight: data.flight,
                    isArabic: isAr,
                    tripSettings: data.tripSettings,
                  ),
                  SizedBox(height: 16.h),

                  // 5. Hotel Logistics Brief Card (Active Hotel + Wi-Fi)
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
                    onTabSelect: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
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

  // =========================================================================
  // TAB 2: TRAVEL & LOGISTICS (WITH SUB-TABS: FLIGHTS, VIP BUSES, HOTEL)
  // =========================================================================
  Widget _buildTravelTab(AppStrings strings, bool isAr) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final flight = data?.flight;
        final hotel = data?.hotel;
        final buses = data?.buses ?? [];
        final assignedBus = data?.assignedBus ?? widget.user.assignedBus;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isAr ? 'ترتيبات السفر والتنقلات والإقامة' : 'Executive Travel & Ground Logistics',
                style: GoogleFonts.cairo(fontSize: 18.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
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
                      label: isAr ? 'تذاكر الطيران' : 'Flight Tickets',
                    ),
                    _buildSubTabButton(
                      index: 1,
                      label: isAr ? 'حافلات النقل' : 'VIP Buses',
                    ),
                    _buildSubTabButton(
                      index: 2,
                      label: isAr ? 'الفندق والواي فاي' : 'Hotel & Wi-Fi',
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
                _buildReturnFlightCard(flight, data?.tripSettings, isAr),
              ],

              // SUB-TAB 1: VIP BUSES FLEET
              if (_travelSubTabIndex == 1) ...[
                _buildBusesSection(buses, assignedBus, isAr),
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
              style: GoogleFonts.cairo(
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

  Widget _buildReturnFlightCard(dynamic flight, dynamic tripSettings, bool isAr) {
    final airline = flight?.airline ?? 'Royal Jordanian';
    final flightNum = flight?.flightNumberReturn ?? 'RJ 506';
    final dynCity = tripSettings != null
        ? (isAr ? tripSettings.destinationCityAr : tripSettings.destinationCityEn)
        : 'Cairo';
    final dynCode = tripSettings?.airportCode ?? 'CAI';
    final defaultRoute = '$dynCity ($dynCode) → Amman (AMM)';
    final returnRoute = flight?.returnRoute ?? defaultRoute;
    final depRaw = flight?.returnDepartureTime ?? '';
    final arrRaw = flight?.returnArrivalTime ?? '';

    String originCity = dynCity.isNotEmpty ? dynCity : 'Cairo';
    String originCode = dynCode.isNotEmpty ? dynCode : 'CAI';
    String destCity = 'Amman';
    String destCode = 'AMM';

    if (returnRoute.contains('→') || returnRoute.contains('->')) {
      final parts = returnRoute.contains('→') ? returnRoute.split('→') : returnRoute.split('->');
      if (parts.length == 2) {
        final origPart = parts[0].trim();
        final dstPart = parts[1].trim();

        final oMatch = RegExp(r'\(([^)]+)\)').firstMatch(origPart);
        if (oMatch != null) {
          originCode = oMatch.group(1) ?? 'CAI';
          originCity = origPart.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
        } else {
          originCity = origPart;
          originCode = origPart.length <= 4 ? origPart.toUpperCase() : origPart.substring(0, 3).toUpperCase();
        }

        final dMatch = RegExp(r'\(([^)]+)\)').firstMatch(dstPart);
        if (dMatch != null) {
          destCode = dMatch.group(1) ?? 'AMM';
          destCity = dstPart.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
        } else {
          destCity = dstPart;
          destCode = dstPart.length <= 4 ? dstPart.toUpperCase() : dstPart.substring(0, 3).toUpperCase();
        }
      }
    }

    String returnDate = 'TBD';
    String depTime = 'TBD';
    String arrTime = 'TBD';

    if (depRaw.isNotEmpty) {
      try {
        final dt = DateTime.parse(depRaw.replaceAll(' ', 'T'));
        returnDate = DateFormat('d MMM', isAr ? 'ar' : 'en').format(dt);
        depTime = DateFormat('hh:mm a').format(dt);
      } catch (_) {
        if (depRaw.contains('·') || depRaw.contains('•')) {
          returnDate = depRaw.split(RegExp(r'[·•]')).first.trim();
          depTime = depRaw.split(RegExp(r'[·•]')).last.trim();
        } else {
          final parts = depRaw.split(' ');
          if (parts.length >= 2 && !parts[1].contains(':')) {
            returnDate = '${parts[0]} ${parts[1]}';
            depTime = parts.last;
          } else {
            returnDate = parts.first;
            depTime = parts.last;
          }
        }
      }
    } else if (tripSettings != null && tripSettings.endDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(tripSettings.endDate);
        returnDate = DateFormat('d MMM', isAr ? 'ar' : 'en').format(dt);
      } catch (_) {
        returnDate = tripSettings.endDate;
      }
    }

    if (arrRaw.isNotEmpty) {
      try {
        final dt = DateTime.parse(arrRaw.replaceAll(' ', 'T'));
        arrTime = DateFormat('hh:mm a').format(dt);
      } catch (_) {
        if (arrRaw.contains('·') || arrRaw.contains('•')) {
          arrTime = arrRaw.split(RegExp(r'[·•]')).last.trim();
        } else if (arrRaw.contains(' ')) {
          arrTime = arrRaw.split(' ').last.trim();
        } else {
          arrTime = arrRaw;
        }
      }
    }

    String duration = isAr ? 'مباشر' : 'Direct';
    if (depRaw.isNotEmpty && arrRaw.isNotEmpty) {
      try {
        final dep = DateTime.parse(depRaw.replaceAll(' ', 'T'));
        final arr = DateTime.parse(arrRaw.replaceAll(' ', 'T'));
        final diff = arr.difference(dep);
        if (!diff.isNegative) {
          final h = diff.inHours;
          final m = diff.inMinutes.remainder(60);
          duration = isAr ? '${h > 0 ? "$h س " : ""}$m د' : '${h > 0 ? "${h}h " : ""}${m}m';
        }
      } catch (_) {}
    }

    return Container(
      padding: AppSpacing.cardPaddingCompact,
      decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.flight_land, color: OrangeColors.primaryOrange, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '$airline · $flightNum',
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: OrangeColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: OrangeColors.warmCream,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      isAr ? 'رحلة العودة' : 'RETURN',
                      style: GoogleFonts.cairo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    returnDate,
                    style: GoogleFonts.cairo(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: OrangeColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: OrangeColors.background,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      originCode,
                      style: GoogleFonts.cairo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.black,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      depTime,
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                    Text(
                      originCity,
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      isAr ? Icons.arrow_back : Icons.arrow_forward,
                      color: OrangeColors.primaryOrange,
                      size: 18.sp,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      duration,
                      style: GoogleFonts.cairo(
                        fontSize: 10.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      destCode,
                      style: GoogleFonts.cairo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.black,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      arrTime,
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.primaryOrange,
                      ),
                    ),
                    Text(
                      destCity,
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: OrangeColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusesSection(List<BusEntity> buses, String assignedBus, bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buses.map((bus) {
        return Container(
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: AppCards.secondary(borderRadius: AppRadius.cardRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: OrangeColors.warmCream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_bus_outlined, size: 18.sp, color: OrangeColors.primaryOrange),
                        SizedBox(width: 8.w),
                        Text(
                          isAr ? bus.busNameAr : bus.busNameEn,
                          style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        ),
                      ],
                    ),
                    Text(
                      bus.busNumber,
                      style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.primaryOrange, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isAr ? 'نقطة التجمع: ' : 'Gathering Point: ',
                          style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            isAr ? bus.gatheringPointAr : bus.gatheringPointEn,
                            style: GoogleFonts.cairo(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          isAr ? 'التجمع: ' : 'Gathering: ',
                          style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          bus.gatheringTime,
                          style: GoogleFonts.cairo(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          isAr ? 'الانطلاق: ' : 'Departure: ',
                          style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          bus.departureTime,
                          style: GoogleFonts.cairo(fontSize: 12.sp, fontWeight: FontWeight.w700, color: OrangeColors.primaryOrange),
                        ),
                      ],
                    ),
                    Divider(height: 24.h, color: OrangeColors.lightBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${isAr ? "مشرف الحافلة:" : "Coordinator:"} ${bus.coordinatorName}',
                                style: GoogleFonts.cairo(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4.h),
                              InkWell(
                                onTap: () => launchPhoneCall(bus.coordinatorPhone),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone_in_talk, size: 14.sp, color: OrangeColors.primaryOrange),
                                    SizedBox(width: 6.w),
                                    Text(
                                      bus.coordinatorPhone,
                                      style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.primaryOrange, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isAr ? "السائق:" : "Driver:"} ${bus.driverName}',
                                style: GoogleFonts.cairo(fontSize: 11.5.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 4.h),
                              InkWell(
                                onTap: () => launchPhoneCall(bus.driverPhone),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone_in_talk, size: 14.sp, color: OrangeColors.secondaryText),
                                    SizedBox(width: 6.w),
                                    Text(
                                      bus.driverPhone,
                                      style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // =========================================================================
  // TAB 3: DYNAMIC MULTI-DAY ITINERARY WITH DAY FILTERING
  // =========================================================================
  Widget _buildItineraryTab(AppStrings strings, bool isAr) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        // Generate all trip days from tripSettings.startDate to tripSettings.endDate
        final tripDates = <String>[];
        if (data?.tripSettings != null) {
          try {
            final start = DateTime.parse(data!.tripSettings.startDate);
            final end = DateTime.parse(data.tripSettings.endDate);
            if (!end.isBefore(start)) {
              for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
                tripDates.add(DateFormat('yyyy-MM-dd').format(d));
              }
            }
          } catch (_) {}
        }

        final distinctDates = <String>{
          ...tripDates,
          ...allItems.map((i) => i.date.trim()).where((d) => d.isNotEmpty)
        }.toList()..sort();

        final effectiveSelectedDay = (distinctDates.contains(_selectedItineraryDay) || _selectedItineraryDay == 'all')
            ? _selectedItineraryDay
            : 'all';

        // Filter items by selected day
        final filteredItems = effectiveSelectedDay == 'all'
            ? allItems
            : allItems.where((i) => i.date.trim() == effectiveSelectedDay).toList();

        final dayFilters = <Map<String, String>>[
          {
            'key': 'all',
            'label': isAr ? 'كافة الأيام' : 'All Days',
            'sub': '${allItems.length} ${isAr ? "فعاليات" : "events"}',
          },
          ...distinctDates.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final dateStr = entry.value;
            String sub = dateStr;
            try {
              final parsed = DateTime.parse(dateStr);
              sub = DateFormat('d MMM', isAr ? 'ar' : 'en').format(parsed);
            } catch (_) {}
            return {
              'key': dateStr,
              'label': isAr ? 'اليوم $index' : 'Day $index',
              'sub': sub,
            };
          }),
        ];

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          children: [
            Text(
              isAr ? 'برنامج الرحلة والفعاليات الرسمية' : 'Official Trip Agenda & Timeline',
              style: GoogleFonts.cairo(fontSize: 18.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
            ),
            SizedBox(height: 14.h),

            // Day Selector Chips (Section 13: Selected = #FF7900 + White text, Unselected = White + Black text)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dayFilters.map((df) {
                  final isSelected = _selectedItineraryDay == df['key'];
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedItineraryDay = df['key']!;
                        });
                      },
                      borderRadius: BorderRadius.circular(18.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? OrangeColors.primaryOrange : OrangeColors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: isSelected ? OrangeColors.primaryOrange : OrangeColors.lightBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              df['label']!,
                              style: GoogleFonts.cairo(
                                fontSize: 12.sp,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected ? OrangeColors.white : OrangeColors.black,
                              ),
                            ),
                            Text(
                              df['sub']!,
                              style: GoogleFonts.cairo(
                                fontSize: 10.sp,
                                color: isSelected ? OrangeColors.white.withValues(alpha: 0.85) : OrangeColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.h),

            // Filtered Itinerary Timeline Items
            if (filteredItems.isEmpty) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 40.sp, color: OrangeColors.secondaryText),
                      SizedBox(height: 12.h),
                      Text(
                        isAr ? 'لا توجد أنشطة مجدولة لهذا اليوم' : 'No scheduled activities for this day',
                        style: GoogleFonts.cairo(color: OrangeColors.secondaryText, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              ...filteredItems.map((item) => _buildItineraryCard(item, isAr)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildItineraryCard(ItineraryItemEntity item, bool isAr) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: AppCards.secondary(borderRadius: BorderRadius.circular(22.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: OrangeColors.warmCream,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${item.date.split("-").sublist(1).reversed.join("/")} · ${item.startTime} - ${item.endTime}',
                  style: GoogleFonts.cairo(
                    color: OrangeColors.primaryOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              if (item.dressCodeEn.isNotEmpty)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: OrangeColors.lightGray,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.checkroom_outlined, size: 12.sp, color: OrangeColors.secondaryText),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            isAr ? item.dressCodeAr : item.dressCodeEn,
                            style: GoogleFonts.cairo(fontSize: 10.sp, fontWeight: FontWeight.w600, color: OrangeColors.darkSecondaryText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            isAr ? item.titleAr : item.titleEn,
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 14.sp, color: OrangeColors.black),
          ),
          SizedBox(height: 4.h),
          Text(
            isAr ? item.descriptionAr : item.descriptionEn,
            style: GoogleFonts.cairo(fontSize: 12.sp, color: OrangeColors.darkSecondaryText, height: 1.4),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 15.sp, color: OrangeColors.primaryOrange),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  isAr ? item.locationAr : item.locationEn,
                  style: GoogleFonts.cairo(fontSize: 11.5.sp, color: OrangeColors.secondaryText, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          if (item.gatheringPointEn.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.group_outlined, size: 15.sp, color: OrangeColors.darkOrange),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${isAr ? "نقطة التجمع:" : "Gathering:"} ${isAr ? item.gatheringPointAr : item.gatheringPointEn}',
                    style: GoogleFonts.cairo(fontSize: 11.5.sp, color: OrangeColors.darkSecondaryText, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 4: PROFILE & BIOMETRICS (Section 15: Warm Cream Card, Orange Circle Avatar, White Initials)
  // =========================================================================
  Widget _buildProfileTab(AppStrings strings, bool isAr) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final fullName = (data?.fullName.isNotEmpty == true) ? data!.fullName : widget.user.fullName;
        final isBiometricsEnabled = data?.isBiometricsEnabled ?? false;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Header Card (Section 15: Background: #FFF3E8, Radius: 24px, Avatar: Orange circle + White initials)
              Container(
                padding: EdgeInsets.all(22.w),
                decoration: AppCards.primary(
                  borderRadius: AppRadius.cardRadius,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: OrangeColors.primaryOrange,
                      child: Text(
                        NameFormatter.getInitial(fullName),
                        style: GoogleFonts.cairo(
                          color: OrangeColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            NameFormatter.formatWithTitle(fullName, isArabic: isAr),
                            style: GoogleFonts.cairo(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: OrangeColors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.user.email,
                            style: GoogleFonts.cairo(
                              fontSize: 12.5.sp,
                              color: OrangeColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 2. Language Selection Card (English / العربية)
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'لغة التطبيق' : 'Application Language',
                      style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w700, color: OrangeColors.darkSecondaryText),
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
                                if (mounted) setState(() {});
                              }
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: !isAr ? OrangeColors.primaryOrange : OrangeColors.lightGray,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: Text(
                                  'English',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.sp,
                                    fontWeight: !isAr ? FontWeight.w700 : FontWeight.w500,
                                    color: !isAr ? OrangeColors.white : OrangeColors.darkSecondaryText,
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
                                if (mounted) setState(() {});
                              }
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isAr ? OrangeColors.primaryOrange : OrangeColors.lightGray,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: Text(
                                  'العربية',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.sp,
                                    fontWeight: isAr ? FontWeight.w700 : FontWeight.w500,
                                    color: isAr ? OrangeColors.white : OrangeColors.darkSecondaryText,
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
              ),
              SizedBox(height: 14.h),

              // 3. Biometrics Authentication Switch Card (Section 19: Inactive: Light bg, dark knob. Active: Orange track, white knob)
              Container(
                decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
                child: SwitchListTile(
                  value: isBiometricsEnabled,
                  title: Text(
                    isAr ? 'تسجيل الدخول بالبصمة أو Face ID' : 'Biometric Quick Unlock',
                    style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    isAr ? 'الدخول السريع والآمن دون الحاجة لكتابة كلمة المرور' : 'Unlock instantly using fingerprint or Face ID',
                    style: GoogleFonts.cairo(fontSize: 11.sp, color: OrangeColors.secondaryText),
                  ),
                  secondary: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: OrangeColors.warmCream,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(Icons.fingerprint, color: OrangeColors.primaryOrange, size: 22.sp),
                  ),
                  onChanged: (enabled) {
                    context.read<DashboardCubit>().toggleBiometrics(enabled);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          enabled
                              ? (isAr ? 'تم تفعيل البصمة لتسجيل الدخول السريع' : 'Biometrics enabled')
                              : (isAr ? 'تم إلغاء تفعيل البصمة' : 'Biometrics disabled'),
                          style: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: OrangeColors.white),
                        ),
                        backgroundColor: OrangeColors.black,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 14.h),

              // 4. Change Password Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'كلمة المرور والأمان' : 'Password & Security',
                      style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w700, color: OrangeColors.darkSecondaryText),
                    ),
                    TextButton(
                      onPressed: () => _showChangePasswordDialog(isAr),
                      child: Text(
                        isAr ? 'تغيير كلمة المرور' : 'Change Password',
                        style: GoogleFonts.cairo(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.primaryOrange),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // 5. Card A: 24/7 Medical & Safety Emergency
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(Icons.emergency_outlined, color: Colors.red, size: 20.sp),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'طوارئ السلامة والصحة 24/7' : '24/7 Medical & Safety Emergency',
                                style: GoogleFonts.cairo(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                              ),
                              Text(
                                isAr ? 'الإسعاف والرعاية الطبية الفورية' : 'Immediate medical & safety response',
                                style: GoogleFonts.cairo(fontSize: 11.sp, color: OrangeColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20.h, color: OrangeColors.lightBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr ? 'خط الطوارئ المباشر' : 'Emergency Hotline',
                          style: GoogleFonts.cairo(color: OrangeColors.secondaryText, fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () => launchPhoneCall(data?.hotel.emergencyContact ?? '+20 100 000 9999'),
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.phone_in_talk, size: 14.sp, color: Colors.red),
                                SizedBox(width: 6.w),
                                Text(
                                  (data != null && data.hotel.emergencyContact.isNotEmpty)
                                      ? data.hotel.emergencyContact
                                      : '+20 100 000 9999',
                                  style: GoogleFonts.cairo(color: Colors.red, fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // 5. Card B: 24/7 Operations & Logistics Desk
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.w),
                          decoration: BoxDecoration(
                            color: OrangeColors.warmCream,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(Icons.support_agent_outlined, color: OrangeColors.primaryOrange, size: 20.sp),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'مكتب العمليات وإدارة الرحلة 24/7' : '24/7 Trip Operations & Logistics',
                                style: GoogleFonts.cairo(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                              ),
                              Text(
                                isAr ? 'منسق عام وفد أورنج والخدمات اللوجستية' : 'Delegation lead & travel logistics',
                                style: GoogleFonts.cairo(fontSize: 11.sp, color: OrangeColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20.h, color: OrangeColors.lightBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr ? 'ضابط العمليات' : 'Operations Officer',
                          style: GoogleFonts.cairo(color: OrangeColors.secondaryText, fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () => launchPhoneCall('+962 7 7111 2233'),
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: OrangeColors.warmCream,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.phone_in_talk, size: 14.sp, color: OrangeColors.primaryOrange),
                                SizedBox(width: 6.w),
                                Text(
                                  '+962 7 7111 2233',
                                  style: GoogleFonts.cairo(color: OrangeColors.primaryOrange, fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // 6. Sign Out Button (Section 7: Secondary Button)
              OrangeButton(
                text: strings.logout,
                isOutlined: true,
                icon: Icons.logout,
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(bool isAr) {
    final currentPwController = TextEditingController();
    final newPwController = TextEditingController();
    final confirmPwController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
        title: Text(
          isAr ? 'تغيير كلمة المرور' : 'Change Password',
          style: GoogleFonts.cairo(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'كلمة المرور الحالية' : 'Current Password',
                labelStyle: GoogleFonts.cairo(fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: newPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'كلمة المرور الجديدة' : 'New Password',
                labelStyle: GoogleFonts.cairo(fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: confirmPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'تأكيد كلمة المرور' : 'Confirm Password',
                labelStyle: GoogleFonts.cairo(fontSize: 12.sp),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel', style: GoogleFonts.cairo(color: OrangeColors.secondaryText, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: OrangeColors.primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAr ? 'تم تحديث كلمة المرور بنجاح' : 'Password updated successfully',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: OrangeColors.white),
                  ),
                  backgroundColor: OrangeColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
              );
            },
            child: Text(
              isAr ? 'تحديث' : 'Update',
              style: GoogleFonts.cairo(color: OrangeColors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
