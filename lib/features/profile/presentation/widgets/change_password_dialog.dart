import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_design_system.dart';

void showChangePasswordDialog(BuildContext context, [bool? isArabic]) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _ChangePasswordDialog(
      parentContext: context,
      isArabic: isArabic ?? (context.locale.languageCode == 'ar'),
    ),
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  final BuildContext parentContext;
  final bool isArabic;

  const _ChangePasswordDialog({
    required this.parentContext,
    required this.isArabic,
  });

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  bool _isStrongPassword(String pw) {
    return pw.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(pw) &&
        RegExp(r'[0-9]').hasMatch(pw);
  }

  Future<void> _submitChangePassword() async {
    final currentPassword = _currentPwController.text;
    final newPassword = _newPwController.text;
    final confirmPassword = _confirmPwController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = widget.isArabic
            ? 'يرجى تعبئة جميع الحقول المطلوبة.'
            : 'Please fill in all password fields.';
      });
      return;
    }

    if (!_isStrongPassword(newPassword)) {
      setState(() {
        _errorMessage = widget.isArabic
            ? 'يجب أن تتكون كلمة المرور الجديدة من 8 خانات على الأقل وتحتوي على حروف وأرقام.'
            : 'New password must be at least 8 characters and include letters and numbers.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = widget.isArabic
            ? 'كلمة المرور الجديدة وتأكيدها غير متطابقين.'
            : 'New password and confirmation do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final messenger = ScaffoldMessenger.of(widget.parentContext);
    final successText = 'password_updated_success'.tr();

    try {
      final storage = GetIt.I<SecureStorageService>();
      final apiClient = GetIt.I<ApiClient>();
      final userData = await storage.getUserData();
      final email = (userData?['email'] ?? '').toString().trim();

      final response = await apiClient.dio.post(
        ApiConstants.changePassword,
        data: {
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['token'] != null && data['token'].toString().isNotEmpty) {
          await storage.saveToken(data['token'].toString());
        }
        if (!mounted) return;
        Navigator.pop(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              successText,
              style: AppTypography.font(
                fontWeight: FontWeight.w600,
                color: OrangeColors.white,
              ),
            ),
            backgroundColor: OrangeColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = (response.data is Map && response.data['message'] != null)
              ? response.data['message'].toString()
              : (widget.isArabic ? 'فشل تحديث كلمة المرور.' : 'Failed to update password.');
        });
      }
    } on DioException catch (e) {
      final serverMsg = (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response!.data['message'].toString()
          : (widget.isArabic
              ? 'تعذر تحديث كلمة المرور. تأكد من كلمة المرور الحالية.'
              : 'Could not update password. Please verify your current password.');
      setState(() {
        _errorMessage = serverMsg;
      });
    } catch (_) {
      setState(() {
        _errorMessage = widget.isArabic
            ? 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'
            : 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
      title: Text(
        'change_password'.tr(),
        style: AppTypography.font(fontSize: 16.sp, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPwController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'current_password'.tr(),
                labelStyle: AppTypography.font(fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _newPwController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'new_password'.tr(),
                labelStyle: AppTypography.font(fontSize: 12.sp),
                helperText: widget.isArabic
                    ? '8 خانات على الأقل (حروف وأرقام)'
                    : '8+ chars (letters & numbers)',
                helperStyle: AppTypography.font(
                  fontSize: 10.sp,
                  color: OrangeColors.secondaryText,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _confirmPwController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'confirm_password'.tr(),
                labelStyle: AppTypography.font(fontSize: 12.sp),
              ),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: OrangeColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: OrangeColors.error.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: AppTypography.font(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: OrangeColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'cancel'.tr(),
            style: AppTypography.font(
              color: OrangeColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: OrangeColors.primaryOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          onPressed: _isLoading ? null : _submitChangePassword,
          child: _isLoading
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: OrangeColors.white,
                  ),
                )
              : Text(
                  'update'.tr(),
                  style: AppTypography.font(
                    color: OrangeColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}
