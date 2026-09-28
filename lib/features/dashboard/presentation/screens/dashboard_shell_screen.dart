import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_strings.dart';
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
  String _selectedItineraryDay = 'all'; // 'all', '2026-11-02', '2026-11-03', '2026-11-04', '2026-11-05'

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final strings = AppStrings(context.locale.languageCode);

    return Scaffold(
      backgroundColor: OrangeColors.lightGrey,
      appBar: AppBar(
        backgroundColor: OrangeColors.coreWhite,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: OrangeColors.borderGrey,
            height: 1,
          ),
        ),
        iconTheme: const IconThemeData(color: OrangeColors.coreBlack),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: Image.asset(
                'assets/images/orange_logo.png',
                width: 24.w,
                height: 24.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.appTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: OrangeColors.coreBlack,
                  ),
                ),
                Text(
                  widget.user.fullName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: OrangeColors.mediumGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: OrangeColors.coreBlack, size: 20.sp),
            tooltip: strings.logout,
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: _buildCurrentTab(strings, isAr),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: OrangeColors.brandOrange,
        unselectedItemColor: OrangeColors.mediumGrey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: OrangeColors.coreWhite,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.sp),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.sp),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: strings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flight_outlined),
            activeIcon: const Icon(Icons.flight),
            label: strings.travel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: strings.itinerary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: strings.profile,
          ),
        ],
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
                Image.asset(
                  'assets/images/orange_logo.png',
                  width: 44.w,
                  height: 44.w,
                ),
                SizedBox(height: 16.h),
                const CircularProgressIndicator(
                  color: OrangeColors.brandOrange,
                  strokeWidth: 2.5,
                ),
                SizedBox(height: 12.h),
                Text(
                  isAr ? 'جاري تحميل لوحة القيادة اللوجستية...' : 'Loading Executive Dashboard...',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: OrangeColors.darkGrey,
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
                  Icon(Icons.cloud_off, size: 48.sp, color: OrangeColors.brandOrange),
                  SizedBox(height: 12.h),
                  Text(
                    isAr ? 'تعذر جلب بيانات السفر والجدول الزمني' : 'Failed to load trip logistics',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: OrangeColors.mediumGrey),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OrangeColors.brandOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                    ),
                    child: Text(
                      isAr ? 'إعادة المحاولة' : 'Retry',
                      style: const TextStyle(color: OrangeColors.coreWhite, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DashboardLoaded) {
          final data = state.data;

          return RefreshIndicator(
            color: OrangeColors.brandOrange,
            backgroundColor: OrangeColors.coreWhite,
            onRefresh: () async {
              await context.read<DashboardCubit>().refreshDashboard();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Hero Trip Countdown Card
                  TripCountdownHero(
                    fullName: data.fullName.isNotEmpty ? data.fullName : widget.user.fullName,
                    role: data.role.isNotEmpty ? data.role : widget.user.role,
                    assignedBus: data.assignedBus.isNotEmpty ? data.assignedBus : widget.user.assignedBus,
                    assignedGroup: data.assignedGroup.isNotEmpty ? data.assignedGroup : widget.user.assignedGroup,
                    countdownDuration: state.tripCountdown,
                    isArabic: isAr,
                  ),
                  SizedBox(height: 12.h),

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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: OrangeColors.success,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ],

                  // 3. Next Activity Interactive Card ("شو في عنا كمان ساعة")
                  NextActivityCard(
                    summary: data.itinerarySummary,
                    countdownDuration: state.nextActivityCountdown,
                    isArabic: isAr,
                    onDetailsTap: () => setState(() => _currentTabIndex = 2),
                  ),
                  SizedBox(height: 12.h),

                  // 4. Flight Logistics Brief Card (RJ 501 & Return RJ 506)
                  FlightBriefCard(
                    flight: data.flight,
                    isArabic: isAr,
                  ),
                  SizedBox(height: 12.h),

                  // 5. Hotel Logistics Brief Card (The St. Regis Cairo + Wi-Fi)
                  HotelBriefCard(
                    hotel: data.hotel,
                    isArabic: isAr,
                  ),
                  SizedBox(height: 12.h),

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
                  SizedBox(height: 14.h),

                  // 7. 24/7 Operations Desk Hotline Banner
                  _buildHotlineBanner(isAr),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHotlineBanner(bool isAr) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: OrangeColors.coreBlack,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: OrangeColors.darkGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: OrangeColors.brandOrange,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Icon(Icons.support_agent, color: OrangeColors.coreBlack, size: 16.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'مكتب العمليات والطوارئ 24/7' : '24/7 Operations Help Desk',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: OrangeColors.coreWhite,
                        ),
                      ),
                      Text(
                        '+962 7 7700 0001 (Orange Jordan)',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: OrangeColors.borderGrey,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showEmergencyDialog(isAr),
            borderRadius: BorderRadius.circular(2.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: OrangeColors.brandOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(color: OrangeColors.brandOrange.withValues(alpha: 0.4)),
              ),
              child: Text(
                isAr ? 'اتصال مباشر' : 'Direct Call',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: OrangeColors.brandOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(bool isAr) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.emergency, color: OrangeColors.brandOrange, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    isAr ? 'أرقام الطوارئ وغرفة العمليات 24/7' : '24/7 Operations & Emergency Contacts',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Divider(height: 24.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: OrangeColors.lightGrey,
                  child: Icon(Icons.phone, color: OrangeColors.brandOrange),
                ),
                title: Text(isAr ? 'غرفة عمليات أورنج الأردن' : 'Orange Jordan Ops Room', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('+962 7 7700 0001'),
                trailing: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isAr ? 'اتصال' : 'Call', style: const TextStyle(color: OrangeColors.brandOrange, fontWeight: FontWeight.bold)),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: OrangeColors.lightGrey,
                  child: Icon(Icons.hotel, color: OrangeColors.brandOrange),
                ),
                title: Text(isAr ? 'استقبال فندق سانت ريجيس' : 'The St. Regis Reception', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('+20 2 2597 9000 (أو اطلب 0 من الغرفة)'),
                trailing: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isAr ? 'اتصال' : 'Call', style: const TextStyle(color: OrangeColors.brandOrange, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
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
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isAr ? 'ترتيبات السفر والتنقلات والإقامة' : 'Executive Travel & Ground Logistics',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: OrangeColors.coreBlack),
              ),
              SizedBox(height: 12.h),

              // Sub-Tabs Segmented Bar (Flights, VIP Buses, Hotel & Wi-Fi)
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: OrangeColors.coreWhite,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: OrangeColors.borderGrey),
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
              SizedBox(height: 14.h),

              // SUB-TAB 0: FLIGHTS
              if (_travelSubTabIndex == 0) ...[
                if (flight != null) ...[
                  FlightBriefCard(flight: flight, isArabic: isAr),
                  SizedBox(height: 12.h),
                ],
                _buildReturnFlightCard(flight, isAr),
              ],

              // SUB-TAB 1: VIP BUSES FLEET
              if (_travelSubTabIndex == 1) ...[
                _buildBusesSection(buses, assignedBus, isAr),
              ],

              // SUB-TAB 2: HOTEL & WI-FI
              if (_travelSubTabIndex == 2) ...[
                if (hotel != null) ...[
                  HotelBriefCard(hotel: hotel, isArabic: isAr),
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
        borderRadius: BorderRadius.circular(3.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? OrangeColors.brandOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? OrangeColors.coreBlack : OrangeColors.darkGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnFlightCard(dynamic flight, bool isAr) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Royal Jordanian · RJ 506',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: OrangeColors.coreBlack,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: OrangeColors.brandOrange,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Text(
                      isAr ? 'رحلة العودة' : 'RETURN',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        color: OrangeColors.coreBlack,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '5 Nov 2026',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: OrangeColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                      'CAI',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: OrangeColors.coreBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '07:00 PM',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.brandOrange,
                      ),
                    ),
                    Text(
                      'Cairo',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: OrangeColors.mediumGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      isAr ? Icons.arrow_back : Icons.arrow_forward,
                      color: OrangeColors.brandOrange,
                      size: 16.sp,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isAr ? '2 س 15 د' : '2h 15m',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: OrangeColors.mediumGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'AMM',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: OrangeColors.coreBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '09:15 PM',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: OrangeColors.brandOrange,
                      ),
                    ),
                    Text(
                      'Amman',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: OrangeColors.mediumGrey,
                        fontWeight: FontWeight.w600,
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
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: OrangeColors.coreWhite,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: OrangeColors.borderGrey),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: OrangeColors.lightGrey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(3.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? bus.busNameAr : bus.busNameEn,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: OrangeColors.coreBlack),
                    ),
                    Text(
                      bus.busNumber,
                      style: TextStyle(fontSize: 11.sp, color: OrangeColors.darkGrey, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isAr ? 'نقطة التجمع: ' : 'Gathering Point: ',
                          style: TextStyle(fontSize: 11.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Text(
                            isAr ? bus.gatheringPointAr : bus.gatheringPointEn,
                            style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w800, color: OrangeColors.coreBlack),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          isAr ? 'التجمع: ' : 'Gathering: ',
                          style: TextStyle(fontSize: 11.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          bus.gatheringTime,
                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: OrangeColors.coreBlack),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          isAr ? 'الانطلاق: ' : 'Departure: ',
                          style: TextStyle(fontSize: 11.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          bus.departureTime,
                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: OrangeColors.brandOrange),
                        ),
                      ],
                    ),
                    Divider(height: 16.h, color: OrangeColors.borderGrey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${isAr ? "مشرف الحافلة:" : "Coordinator:"} ${bus.coordinatorName}',
                                style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(height: 3.h),
                              InkWell(
                                onTap: () => launchPhoneCall(bus.coordinatorPhone),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone_in_talk, size: 12.sp, color: OrangeColors.brandOrange),
                                    SizedBox(width: 4.w),
                                    Text(
                                      bus.coordinatorPhone,
                                      style: TextStyle(fontSize: 11.sp, color: OrangeColors.brandOrange, fontWeight: FontWeight.w800),
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
                                style: TextStyle(fontSize: 10.5.sp, color: OrangeColors.darkGrey, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 3.h),
                              InkWell(
                                onTap: () => launchPhoneCall(bus.driverPhone),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone_in_talk, size: 12.sp, color: OrangeColors.darkGrey),
                                    SizedBox(width: 4.w),
                                    Text(
                                      bus.driverPhone,
                                      style: TextStyle(fontSize: 11.sp, color: OrangeColors.darkGrey, fontWeight: FontWeight.w800),
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
        final allItems = data?.allItineraryItems ?? [];

        // Filter items by selected day
        final filteredItems = _selectedItineraryDay == 'all'
            ? allItems
            : allItems.where((i) => i.date == _selectedItineraryDay).toList();

        final dayFilters = [
          {'key': 'all', 'label': isAr ? 'كافة الأيام' : 'All Days', 'sub': '2-5 Nov'},
          {'key': '2026-11-02', 'label': isAr ? 'اليوم 1' : 'Day 1', 'sub': '2 Nov'},
          {'key': '2026-11-03', 'label': isAr ? 'اليوم 2' : 'Day 2', 'sub': '3 Nov'},
          {'key': '2026-11-04', 'label': isAr ? 'اليوم 3' : 'Day 3', 'sub': '4 Nov'},
          {'key': '2026-11-05', 'label': isAr ? 'اليوم 4' : 'Day 4', 'sub': '5 Nov'},
        ];

        return ListView(
          padding: EdgeInsets.all(14.w),
          children: [
            Text(
              isAr ? 'برنامج الرحلة والفعاليات الرسمية' : 'Official Trip Agenda & Timeline',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: OrangeColors.coreBlack),
            ),
            SizedBox(height: 12.h),

            // Day Selector Chips (Horizontal Scrollable)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dayFilters.map((df) {
                  final isSelected = _selectedItineraryDay == df['key'];
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 8.w),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            df['label']!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                              color: isSelected ? OrangeColors.coreWhite : OrangeColors.darkGrey,
                            ),
                          ),
                          Text(
                            df['sub']!,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: isSelected ? OrangeColors.coreWhite : OrangeColors.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                      selectedColor: OrangeColors.brandOrange,
                      backgroundColor: OrangeColors.coreWhite,
                      side: BorderSide(
                        color: isSelected ? OrangeColors.brandOrange : OrangeColors.borderGrey,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedItineraryDay = df['key']!;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 14.h),

            // Filtered Itinerary Timeline Items
            if (filteredItems.isEmpty) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 36.sp, color: OrangeColors.mediumGrey),
                      SizedBox(height: 8.h),
                      Text(
                        isAr ? 'لا توجد أنشطة مجدولة لهذا اليوم' : 'No scheduled activities for this day',
                        style: TextStyle(color: OrangeColors.darkGrey, fontSize: 12.sp),
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
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: OrangeColors.coreWhite,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: OrangeColors.borderGrey),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5EB),
                  borderRadius: BorderRadius.circular(2.r),
                  border: Border.all(color: OrangeColors.brandOrange.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${item.date.split("-").sublist(1).reversed.join("/")} · ${item.startTime} - ${item.endTime}',
                  style: TextStyle(
                    color: OrangeColors.accessibleOrange,
                    fontWeight: FontWeight.w800,
                    fontSize: 10.5.sp,
                  ),
                ),
              ),
              if (item.dressCodeEn.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: OrangeColors.lightGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.checkroom, size: 10.sp, color: OrangeColors.mediumGrey),
                      SizedBox(width: 3.w),
                      Text(
                        isAr ? item.dressCodeAr : item.dressCodeEn,
                        style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.darkGrey),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            isAr ? item.titleAr : item.titleEn,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.sp, color: OrangeColors.coreBlack),
          ),
          SizedBox(height: 4.h),
          Text(
            isAr ? item.descriptionAr : item.descriptionEn,
            style: TextStyle(fontSize: 11.sp, color: OrangeColors.darkGrey, height: 1.3),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 13.sp, color: OrangeColors.brandOrange),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  isAr ? item.locationAr : item.locationEn,
                  style: TextStyle(fontSize: 10.5.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (item.gatheringPointEn.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.group_outlined, size: 13.sp, color: OrangeColors.accessibleOrange),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    '${isAr ? "نقطة التجمع:" : "Gathering:"} ${isAr ? item.gatheringPointAr : item.gatheringPointEn}',
                    style: TextStyle(fontSize: 10.sp, color: OrangeColors.darkGrey, fontWeight: FontWeight.w700),
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
  // TAB 4: PROFILE & BIOMETRICS (NO VERIFIED BADGE, BIOMETRICS TOGGLE)
  // =========================================================================
  Widget _buildProfileTab(AppStrings strings, bool isAr) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final fullName = (data?.fullName.isNotEmpty == true) ? data!.fullName : widget.user.fullName;
        final isBiometricsEnabled = data?.isBiometricsEnabled ?? false;

        return SingleChildScrollView(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Header Card (Avatar + Name + Email) - Strictly NO verified badge or role subtitle
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: OrangeColors.coreWhite,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: OrangeColors.borderGrey),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26.r,
                      backgroundColor: OrangeColors.coreBlack,
                      child: Text(
                        fullName.isNotEmpty ? fullName[0] : 'U',
                        style: TextStyle(
                          color: OrangeColors.brandOrange,
                          fontWeight: FontWeight.w900,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: OrangeColors.coreBlack),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.user.email,
                            style: TextStyle(fontSize: 11.5.sp, color: OrangeColors.mediumGrey, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // 2. Language Selection Card (English / العربية)
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: OrangeColors.coreWhite,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: OrangeColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'لغة التطبيق' : 'Application Language',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: OrangeColors.darkGrey),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (context.locale.languageCode != 'en') {
                                await context.setLocale(const Locale('en'));
                                await sl<SecureStorageService>().setLanguage('en');
                              }
                            },
                            borderRadius: BorderRadius.circular(3.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                color: !isAr ? OrangeColors.brandOrange : OrangeColors.lightGrey,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Center(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: !isAr ? FontWeight.w900 : FontWeight.w600,
                                    color: !isAr ? OrangeColors.coreBlack : OrangeColors.darkGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (context.locale.languageCode != 'ar') {
                                await context.setLocale(const Locale('ar'));
                                await sl<SecureStorageService>().setLanguage('ar');
                              }
                            },
                            borderRadius: BorderRadius.circular(3.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isAr ? OrangeColors.brandOrange : OrangeColors.lightGrey,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Center(
                                child: Text(
                                  'العربية',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: isAr ? FontWeight.w900 : FontWeight.w600,
                                    color: isAr ? OrangeColors.coreBlack : OrangeColors.darkGrey,
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
              SizedBox(height: 12.h),

              // 3. Biometrics Authentication Switch Card (Face ID / Fingerprint)
              Container(
                decoration: BoxDecoration(
                  color: OrangeColors.coreWhite,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: OrangeColors.borderGrey),
                ),
                child: SwitchListTile(
                  value: isBiometricsEnabled,
                  activeThumbColor: OrangeColors.brandOrange,
                  title: Text(
                    isAr ? 'تسجيل الدخول بالبصمة أو التعرف على الوجه' : 'Biometric Quick Unlock',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    isAr ? 'الدخول السريع والآمن دون الحاجة لكتابة كلمة المرور' : 'Unlock instantly using fingerprint or face recognition',
                    style: TextStyle(fontSize: 10.sp, color: OrangeColors.mediumGrey),
                  ),
                  secondary: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: OrangeColors.lightGrey,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Icon(Icons.fingerprint, color: OrangeColors.brandOrange, size: 20.sp),
                  ),
                  onChanged: (enabled) {
                    context.read<DashboardCubit>().toggleBiometrics(enabled);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          enabled
                              ? (isAr ? 'تم تفعيل البصمة لتسجيل الدخول السريع' : 'Biometrics enabled')
                              : (isAr ? 'تم إلغاء تفعيل البصمة' : 'Biometrics disabled'),
                        ),
                        backgroundColor: OrangeColors.coreBlack,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),

              // 4. Change Password Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: OrangeColors.coreWhite,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: OrangeColors.borderGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'كلمة المرور والأمان' : 'Password & Security',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: OrangeColors.darkGrey),
                    ),
                    TextButton(
                      onPressed: () => _showChangePasswordDialog(isAr),
                      child: Text(
                        isAr ? 'تغيير كلمة المرور' : 'Change Password',
                        style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w800, color: OrangeColors.brandOrange),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // 5. Emergency Contact Info Card (Direct Clickable Dialing)
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: OrangeColors.coreWhite,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: OrangeColors.borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'جهة الاتصال في حالات الطوارئ' : 'Emergency Contact Person',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: OrangeColors.darkGrey),
                    ),
                    Divider(height: 16.h),
                    _buildProfileRow(isAr ? 'الاسم' : 'Name', 'Noor Al-Mansoor'),
                    Divider(height: 14.h),
                    _buildProfileRow(isAr ? 'صلة القرابة' : 'Relationship', isAr ? 'الزوجة' : 'Spouse'),
                    Divider(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr ? 'رقم الهاتف' : 'Phone',
                          style: TextStyle(color: OrangeColors.mediumGrey, fontSize: 11.5.sp, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () => launchPhoneCall('+962779998888'),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone_in_talk, size: 12.sp, color: OrangeColors.brandOrange),
                              SizedBox(width: 4.w),
                              Text(
                                '+962 7 7999 8888',
                                style: TextStyle(color: OrangeColors.brandOrange, fontSize: 12.sp, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 6. Sign Out Button
              OrangeButton(
                text: strings.logout,
                isOutlined: true,
                icon: Icons.logout,
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
              ),
              SizedBox(height: 16.h),
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
        title: Text(
          isAr ? 'تغيير كلمة المرور' : 'Change Password',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'كلمة المرور الحالية' : 'Current Password',
                labelStyle: TextStyle(fontSize: 11.sp),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: newPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'كلمة المرور الجديدة' : 'New Password',
                labelStyle: TextStyle(fontSize: 11.sp),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: confirmPwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isAr ? 'تأكيد كلمة المرور' : 'Confirm Password',
                labelStyle: TextStyle(fontSize: 11.sp),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: OrangeColors.brandOrange),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isAr ? 'تم تحديث كلمة المرور بنجاح' : 'Password updated successfully'),
                  backgroundColor: OrangeColors.brandOrange,
                ),
              );
            },
            child: Text(
              isAr ? 'تحديث' : 'Update',
              style: const TextStyle(color: OrangeColors.coreBlack, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: OrangeColors.mediumGrey, fontSize: 11.5.sp, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: TextStyle(color: OrangeColors.coreBlack, fontSize: 12.sp, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
