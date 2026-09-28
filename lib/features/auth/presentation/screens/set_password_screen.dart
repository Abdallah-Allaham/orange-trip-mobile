import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/orange_button.dart';
import '../widgets/orange_text_field.dart';

class SetPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialToken;

  const SetPasswordScreen({super.key, this.initialEmail, this.initialToken});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
    _tokenController.addListener(_handleLinkOrTokenPaste);
  }

  void _handleLinkOrTokenPaste() {
    final text = _tokenController.text.trim();
    if (text.startsWith('http://') || text.startsWith('https://')) {
      try {
        final uri = Uri.parse(text);
        final token = uri.queryParameters['token'];
        final email = uri.queryParameters['email'];

        if (token != null && token.isNotEmpty) {
          _tokenController.value = TextEditingValue(
            text: token,
            selection: TextSelection.collapsed(offset: token.length),
          );
        }
        if (email != null && email.isNotEmpty && _emailController.text.isEmpty) {
          _emailController.text = email;
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _tokenController.removeListener(_handleLinkOrTokenPaste);
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().setPassword(
            _emailController.text.trim(),
            _passwordController.text,
            _tokenController.text.trim().isNotEmpty ? _tokenController.text.trim() : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrangeColors.background,
      appBar: AppBar(
        backgroundColor: OrangeColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: OrangeColors.lightBorder, height: 1),
        ),
        title: Text(
          'account_activation_title'.tr(),
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: OrangeColors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: OrangeColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PasswordSetSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: OrangeColors.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'activation_success'.tr(),
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: OrangeColors.white,
                  ),
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: OrangeColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  state.message,
                  style: GoogleFonts.cairo(fontSize: 13.sp, color: OrangeColors.white),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
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
                        Text(
                          'account_activation_title'.tr(),
                          style: GoogleFonts.cairo(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: OrangeColors.black,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'activation_description'.tr(),
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            color: OrangeColors.secondaryText,
                            height: 1.45,
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
                            if (v == null || v.trim().isEmpty) {
                              return 'email_required'.tr();
                            }
                            if (!v.contains('@')) return 'Invalid email address';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Activation Token Field
                        OrangeTextField(
                          label: 'token_label'.tr(),
                          hint: 'token_hint'.tr(),
                          controller: _tokenController,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'token_required'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // New Password Field
                        OrangeTextField(
                          label: 'new_password_label'.tr(),
                          hint: 'new_password_hint'.tr(),
                          controller: _passwordController,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'password_required'.tr();
                            }
                            if (v.length < 8) {
                              return 'password_min_length'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Confirm Password Field
                        OrangeTextField(
                          label: 'confirm_password_label'.tr(),
                          hint: 'confirm_password_hint'.tr(),
                          controller: _confirmPasswordController,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'confirm_password_required'.tr();
                            }
                            if (v != _passwordController.text) {
                              return 'passwords_do_not_match'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Submit Button
                        OrangeButton(
                          text: 'activate_account_button'.tr(),
                          isLoading: isLoading,
                          onPressed: _handleSubmit,
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
