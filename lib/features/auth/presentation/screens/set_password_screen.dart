import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
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

    // Smart URL parsing: if user pastes full invitation link, extract token & email automatically
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
        if (email != null &&
            email.isNotEmpty &&
            _emailController.text.isEmpty) {
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
        _tokenController.text.trim().isNotEmpty
            ? _tokenController.text.trim()
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrangeColors.coreWhite,
      appBar: AppBar(
        backgroundColor: OrangeColors.coreBlack,
        title: Text(
          'account_activation_title'.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: OrangeColors.coreWhite,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: OrangeColors.coreWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PasswordSetSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: OrangeColors.success,
                content: Text(
                  'activation_success'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: OrangeColors.danger,
                content: Text(state.message, style: TextStyle(fontSize: 13.sp)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Badge
                      Text(
                        'account_activation_title'.tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: OrangeColors.coreBlack,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'activation_description'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: OrangeColors.mediumGrey,
                          height: 1.4,
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

                      // Smart Token or Full Link Field
                      OrangeTextField(
                        label: 'activation_token_label'.tr(),
                        hint: 'activation_token_hint'.tr(),
                        controller: _tokenController,
                      ),
                      SizedBox(height: 16.h),

                      // New Password Field
                      OrangeTextField(
                        label: 'new_password_label'.tr(),
                        hint: 'password_hint'.tr(),
                        controller: _passwordController,
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'password_required'.tr();
                          }
                          if (v.length < 6) return 'password_too_short'.tr();
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Confirm Password Field
                      OrangeTextField(
                        label: 'confirm_password_label'.tr(),
                        hint: 'password_hint'.tr(),
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (v) {
                          if (v != _passwordController.text) {
                            return 'passwords_do_not_match'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Submit Button
                      OrangeButton(
                        text: 'save_password_button'.tr(),
                        isLoading: isLoading,
                        onPressed: _handleSubmit,
                      ),
                      SizedBox(height: 14.h),

                      // Back to login
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'back_to_login'.tr(),
                          style: TextStyle(
                            color: OrangeColors.coreBlack,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
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
