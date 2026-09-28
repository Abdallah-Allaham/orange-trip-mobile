import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
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
      backgroundColor: OrangeColors.coreWhite,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            widget.onLoginSuccess();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: OrangeColors.danger,
                content: Text(
                  state.message,
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top bar: Orange Logo and Language toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Official Orange Square Logo with text
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0.r),
                              child: Image.asset(
                                'assets/images/orange_logo.png',
                                width: 44.w,
                                height: 44.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Language Toggle Button (Always includes Globe Icon)
                            OutlinedButton.icon(
                              onPressed: _toggleLanguage,
                              icon: Icon(
                                Icons.language,
                                size: 16.sp,
                                color: OrangeColors.coreBlack,
                              ),
                              label: Text(
                                isArabic ? 'English' : 'العربية',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.sp,
                                  color: OrangeColors.coreBlack,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: OrangeColors.lightGrey,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                side: const BorderSide(color: OrangeColors.borderGrey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // Header (Cleaned up, no redundant texts)
                        Text(
                          'brand_orange'.tr(),
                          style: TextStyle(
                            color: OrangeColors.brandOrange,
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'app_title'.tr(),
                          style: TextStyle(
                            color: OrangeColors.coreBlack,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 32.h),

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
                        SizedBox(height: 12.h),

                        // Quick Sign-In Checkbox (Face ID & Fingerprint)
                        Row(
                          children: [
                            SizedBox(
                              width: 22.w,
                              height: 22.h,
                              child: Checkbox(
                                value: _enableBiometrics,
                                activeColor: OrangeColors.brandOrange,
                                checkColor: OrangeColors.coreBlack,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0.r),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _enableBiometrics = val ?? false;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'quick_sign_in'.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: OrangeColors.darkGrey,
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
                        SizedBox(height: 16.h),

                        // Biometric Quick Button (if enabled/available)
                        if (canUseBiometrics) ...[
                          OrangeButton(
                            text: 'biometric_unlock'.tr(),
                            isOutlined: true,
                            icon: Icons.fingerprint,
                            onPressed: () {
                              context.read<AuthCubit>().authenticateWithBiometrics();
                            },
                          ),
                          SizedBox(height: 16.h),
                        ],

                        // First Time Attendee / Activation Link
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
                            style: TextStyle(
                              color: OrangeColors.accessibleOrange,
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
          );
        },
      ),
    );
  }
}
