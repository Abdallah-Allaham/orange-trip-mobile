import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/name_formatter.dart';
import '../../../../core/utils/phone_launcher.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/orange_button.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../widgets/change_password_dialog.dart';

class ProfileScreen extends StatelessWidget {
  final UserEntity user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final strings = AppStrings(context.locale.languageCode);

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final fullName = (data?.fullName.isNotEmpty == true) ? data!.fullName : user.fullName;
        final isBiometricsEnabled = data?.isBiometricsEnabled ?? false;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Header Card
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
                        style: AppTypography.font(
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
                            style: AppTypography.font(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: OrangeColors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            user.email,
                            style: AppTypography.font(
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
                      style: AppTypography.font(fontSize: 13.sp, fontWeight: FontWeight.w700, color: OrangeColors.darkSecondaryText),
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
                                  style: AppTypography.font(
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
                                  style: AppTypography.font(
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

              // 3. Biometrics Authentication Switch Card
              Container(
                decoration: AppCards.secondary(borderRadius: BorderRadius.circular(20.r)),
                child: SwitchListTile(
                  value: isBiometricsEnabled,
                  title: Text(
                    isAr ? 'تسجيل الدخول بالبصمة أو Face ID' : 'Biometric Quick Unlock',
                    style: AppTypography.font(fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    isAr ? 'الدخول السريع والآمن دون الحاجة لكتابة كلمة المرور' : 'Unlock instantly using fingerprint or Face ID',
                    style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText),
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
                          style: AppTypography.font(fontWeight: FontWeight.w600, color: OrangeColors.white),
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
                      style: AppTypography.font(fontSize: 13.sp, fontWeight: FontWeight.w700, color: OrangeColors.darkSecondaryText),
                    ),
                    TextButton(
                      onPressed: () => showChangePasswordDialog(context, isAr),
                      child: Text(
                        isAr ? 'تغيير كلمة المرور' : 'Change Password',
                        style: AppTypography.font(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.primaryOrange),
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
                                style: AppTypography.font(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                              ),
                              Text(
                                isAr ? 'الإسعاف والرعاية الطبية الفورية' : 'Immediate medical & safety response',
                                style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText),
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
                          style: AppTypography.font(color: OrangeColors.secondaryText, fontSize: 12.sp, fontWeight: FontWeight.w500),
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
                                  style: AppTypography.font(color: Colors.red, fontSize: 12.5.sp, fontWeight: FontWeight.w700),
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
                                style: AppTypography.font(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
                              ),
                              Text(
                                isAr ? 'منسق عام وفد أورنج والخدمات اللوجستية' : 'Delegation lead & travel logistics',
                                style: AppTypography.font(fontSize: 11.sp, color: OrangeColors.secondaryText),
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
                          style: AppTypography.font(color: OrangeColors.secondaryText, fontSize: 12.sp, fontWeight: FontWeight.w500),
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
                                  style: AppTypography.font(color: OrangeColors.primaryOrange, fontSize: 12.5.sp, fontWeight: FontWeight.w700),
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

              // 6. Sign Out Button
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
}
