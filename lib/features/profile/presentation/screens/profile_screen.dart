import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/orange_button.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../widgets/biometrics_card.dart';
import '../widgets/emergency_hotlines_card.dart';
import '../widgets/language_selector_card.dart';
import '../widgets/participant_identity_card.dart';
import '../widgets/password_security_card.dart';
import '../widgets/privacy_consent_card.dart';
import '../widgets/profile_header_card.dart';

class ProfileScreen extends StatelessWidget {
  final UserEntity user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final fullName = (data?.fullName.isNotEmpty == true) ? data!.fullName : user.fullName;
        final isBiometricsEnabled = data?.isBiometricsEnabled ?? false;
        final dataNoticeAccepted = data?.dataNoticeAccepted ?? user.dataNoticeAccepted;
        final mediaConsentGranted = data?.mediaConsentGranted ?? user.mediaConsentGranted;
        final employeeId = user.employeeId.isNotEmpty ? user.employeeId : 'DIR-001';
        final phoneNumber = user.phoneNumber.isNotEmpty ? user.phoneNumber : '+962 7 7000 0000';
        final tripSettings = data?.tripSettings;
        final medicalPhone = tripSettings?.emergencyMedicalPhone.isNotEmpty == true
            ? tripSettings!.emergencyMedicalPhone
            : '+20 100 000 9999';
        final operationsPhone = tripSettings?.operationsDeskPhone.isNotEmpty == true
            ? tripSettings!.operationsDeskPhone
            : '+962 7 7700 0001';

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Header Card
              ProfileHeaderCard(
                fullName: fullName,
                email: user.email,
                isArabic: isAr,
              ),
              SizedBox(height: 16.h),

              // 2. Official Participant Identity Card (Clean DB Schema)
              ParticipantIdentityCard(
                employeeId: employeeId,
                fullName: fullName,
                email: user.email,
                phoneNumber: phoneNumber,
                isArabic: isAr,
              ),
              SizedBox(height: 14.h),

              // 3. Privacy Notice & Media Coverage Consent Card
              PrivacyConsentCard(
                dataNoticeAccepted: dataNoticeAccepted,
                mediaConsentGranted: mediaConsentGranted,
                isArabic: isAr,
                onMediaConsentChanged: (newVal) async {
                  final cubit = context.read<DashboardCubit>();
                  final success = await cubit.updateConsent(
                    dataNoticeAccepted: true,
                    mediaConsentGranted: newVal,
                  );
                  if (context.mounted && success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isAr
                              ? 'تم تحديث خيارات التغطية الإعلامية بنجاح'
                              : 'Media consent preferences updated',
                          style: AppTypography.font(
                            fontWeight: FontWeight.w600,
                            color: OrangeColors.white,
                          ),
                        ),
                        backgroundColor: OrangeColors.black,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 14.h),

              // 4. Central 24/7 Emergency & Operations Hotlines
              EmergencyHotlinesCard(
                medicalPhone: medicalPhone,
                operationsPhone: operationsPhone,
                isArabic: isAr,
              ),
              SizedBox(height: 14.h),

              // 5. Language Selection Card
              LanguageSelectorCard(isArabic: isAr),
              SizedBox(height: 14.h),

              // 6. Biometrics Authentication Switch Card
              BiometricsCard(
                isBiometricsEnabled: isBiometricsEnabled,
                onToggle: (enabled) {
                  context.read<DashboardCubit>().toggleBiometrics(enabled);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        enabled ? 'biometrics_enabled'.tr() : 'biometrics_disabled'.tr(),
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
              SizedBox(height: 14.h),

              // 7. Password Security Card
              const PasswordSecurityCard(),
              SizedBox(height: 20.h),

              // 8. Sign Out Button
              OrangeButton(
                text: 'logout_button'.tr(),
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
