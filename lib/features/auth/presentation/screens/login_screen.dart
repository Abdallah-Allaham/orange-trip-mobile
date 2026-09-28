import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_brand_logo.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/orange_button.dart';
import '../widgets/orange_text_field.dart';
import 'set_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'ahmad.director@orange.jo');
  final _passwordController = TextEditingController(text: 'Orange2026!');
  bool _enableBiometrics = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
            enableBiometrics: _enableBiometrics,
          );
    }
  }

  void _toggleLanguage() {
    if (context.locale.languageCode == 'ar') {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: OrangeColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            widget.onLoginSuccess();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: OrangeColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  state.message,
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: OrangeColors.white),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final canUseBiometrics = state is Unauthenticated && state.canUseBiometrics;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420.w),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: AppCards.secondary(
                      borderRadius: AppRadius.cardRadius,
                      withSubtleShadow: true,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top row: Brand Icon & Language Switcher
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppBrandLogo(size: 44.w),
                              OutlinedButton.icon(
                                onPressed: _toggleLanguage,
                                icon: Icon(
                                  Icons.language,
                                  size: 16.sp,
                                  color: OrangeColors.black,
                                ),
                                label: Text(
                                  isArabic ? 'English' : 'العربية',
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    color: OrangeColors.black,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: OrangeColors.lightGray,
                                  minimumSize: Size(0, 36.h),
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Typography Hierarchy
                          Text(
                            'brand_orange'.tr(),
                            style: GoogleFonts.cairo(
                              color: OrangeColors.primaryOrange,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          Text(
                            'app_title'.tr(),
                            style: GoogleFonts.cairo(
                              color: OrangeColors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Email Field
                          OrangeTextField(
                            label: 'email_label'.tr(),
                            hint: 'email_hint'.tr(),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'email_required'.tr();
                              if (!v.contains('@')) return 'Invalid email address';
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Password Field
                          OrangeTextField(
                            label: 'password_label'.tr(),
                            hint: 'password_hint'.tr(),
                            controller: _passwordController,
                            isPassword: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'password_required'.tr();
                              return null;
                            },
                          ),
                          SizedBox(height: 14.h),

                          // Biometric Checkbox
                          Row(
                            children: [
                              SizedBox(
                                width: 22.w,
                                height: 22.h,
                                child: Checkbox(
                                  value: _enableBiometrics,
                                  activeColor: OrangeColors.primaryOrange,
                                  checkColor: OrangeColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  side: const BorderSide(color: OrangeColors.lightBorder, width: 1.5),
                                  onChanged: (val) {
                                    setState(() {
                                      _enableBiometrics = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  'quick_sign_in'.tr(),
                                  style: GoogleFonts.cairo(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: OrangeColors.darkSecondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Sign In Button
                          OrangeButton(
                            text: 'sign_in_button'.tr(),
                            isLoading: isLoading,
                            onPressed: _handleSignIn,
                          ),
                          SizedBox(height: 14.h),

                          // Biometrics Unlock Button
                          if (canUseBiometrics) ...[
                            OrangeButton(
                              text: 'biometric_unlock'.tr(),
                              isOutlined: true,
                              icon: Icons.fingerprint,
                              onPressed: () {
                                context.read<AuthCubit>().authenticateWithBiometrics();
                              },
                            ),
                            SizedBox(height: 14.h),
                          ],

                          // First Time Attendee
                          TextButton(
                            onPressed: () {
                              final authCubit = context.read<AuthCubit>();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: authCubit,
                                    child: SetPasswordScreen(
                                      initialEmail: _emailController.text.trim(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'first_time_prompt'.tr(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                color: OrangeColors.primaryOrange,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
