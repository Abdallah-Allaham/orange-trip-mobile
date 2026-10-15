import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../widgets/emergency_coordinator_card.dart';
import '../widgets/hotline_card.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: OrangeColors.background,
      appBar: AppBar(
        backgroundColor: OrangeColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          isAr ? 'أرقام الطوارئ وغرفة العمليات' : 'Emergency & Operations',
          style: AppTypography.font(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: OrangeColors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: OrangeColors.black,
            size: 18.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final data = state is DashboardLoaded ? state.data : null;
          final tripSettings = data?.tripSettings;
          final medicalPhone = tripSettings?.emergencyMedicalPhone.isNotEmpty == true
              ? tripSettings!.emergencyMedicalPhone
              : '+20 100 000 9999';
          final operationsPhone = tripSettings?.operationsDeskPhone.isNotEmpty == true
              ? tripSettings!.operationsDeskPhone
              : '+962 7 7700 0001';
          final contacts = data?.emergencyContacts ?? [];

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
                  // Banner Information
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: OrangeColors.primaryOrange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: OrangeColors.primaryOrange.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.support_agent,
                          color: OrangeColors.primaryOrange,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            isAr
                                ? 'فريق العمليات والسلامة متواجد على مدار الساعة لخدمتكم وضمان راحتكم طوال فترة الرحلة. للتواصل المباشر يرجى استخدام الأزرار أدناه.'
                                : 'Our 24/7 Operations & Safety team is dedicated to your assistance and well-being throughout the trip. Use direct call or WhatsApp below.',
                            style: AppTypography.font(
                              fontSize: 12.sp,
                              color: OrangeColors.black,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Section Title: 24/7 Central Hotlines
                  Text(
                    isAr ? 'الخطوط المركزية الساخنة (24/7)' : '24/7 Central Hotlines',
                    style: AppTypography.font(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: OrangeColors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Card 1: Medical & Safety Emergency
                  HotlineCard(
                    icon: Icons.emergency_outlined,
                    iconColor: Colors.red,
                    title: isAr ? 'طوارئ السلامة والصحة 24/7' : '24/7 Medical & Safety Desk',
                    subtitle: isAr
                        ? 'الاستجابة الفورية، الإسعاف، والرعاية الطبية'
                        : 'Immediate response, ambulance, and hospital desk',
                    phoneNumber: medicalPhone,
                    whatsappNumber: medicalPhone,
                    isArabic: isAr,
                    isEmergency: true,
                  ),
                  SizedBox(height: 12.h),

                  // Card 2: Operations & Logistics Desk
                  HotlineCard(
                    icon: Icons.headset_mic_outlined,
                    iconColor: OrangeColors.primaryOrange,
                    title: isAr ? 'مكتب العمليات وإدارة الرحلة 24/7' : '24/7 Trip Operations & Logistics',
                    subtitle: isAr
                        ? 'منسق عام وفد أورنج والتنقلات والفندق'
                        : 'Delegation coordinator & travel logistics lead',
                    phoneNumber: operationsPhone,
                    whatsappNumber: operationsPhone,
                    isArabic: isAr,
                    isEmergency: false,
                  ),
                  SizedBox(height: 22.h),

                  // Section Title: Official Coordinators
                  if (contacts.isNotEmpty) ...[
                    Text(
                      isAr ? 'منسقو وفد أورنج الرسميون' : 'Official Orange Coordinators',
                      style: AppTypography.font(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: OrangeColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    for (final contact in contacts) ...[
                      EmergencyCoordinatorCard(contact: contact, isArabic: isAr),
                      SizedBox(height: 12.h),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
