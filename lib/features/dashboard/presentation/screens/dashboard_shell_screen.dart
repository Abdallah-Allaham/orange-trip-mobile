import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_brand_logo.dart';
import '../../../../core/utils/name_formatter.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../home/presentation/screens/home_tab_screen.dart';
import '../../../itinerary/presentation/screens/itinerary_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../travel/presentation/screens/travel_screen.dart';
import '../cubit/dashboard_cubit.dart';

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

  void _onNavigateToTab(int index) {
    if (mounted) {
      setState(() {
        _currentTabIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final strings = AppStrings(context.locale.languageCode);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: OrangeColors.background,
        appBar: AppBar(
          backgroundColor: OrangeColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              AppBrandLogo(size: 30.w),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'O-Trip',
                    style: AppTypography.font(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: OrangeColors.black,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    NameFormatter.formatWithTitle(widget.user.fullName, isArabic: isArabic),
                    style: AppTypography.font(
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
        body: IndexedStack(
          index: _currentTabIndex,
          children: [
            HomeTabScreen(
              user: widget.user,
              onNavigateToTab: _onNavigateToTab,
            ),
            TravelScreen(
              user: widget.user,
            ),
            const ItineraryScreen(),
            ProfileScreen(
              user: widget.user,
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(strings),
      ),
    );
  }

  Widget _buildBottomNav(AppStrings strings) {
    return Container(
      decoration: BoxDecoration(
        color: OrangeColors.white,
        border: Border(
          top: BorderSide(color: OrangeColors.lightBorder, width: 1.0),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Row(
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
                style: AppTypography.font(
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
}
