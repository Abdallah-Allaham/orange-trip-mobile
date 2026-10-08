import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';

class OrangeTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool enabled;

  const OrangeTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  State<OrangeTextField> createState() => _OrangeTextFieldState();
}

class _OrangeTextFieldState extends State<OrangeTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.font(
            color: OrangeColors.darkSecondaryText,
            fontWeight: FontWeight.w700,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          validator: widget.validator,
          style: AppTypography.font(
            color: OrangeColors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.font(
              color: OrangeColors.secondaryText,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: OrangeColors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: OrangeColors.lightBorder, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: OrangeColors.lightBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: OrangeColors.primaryOrange, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: OrangeColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: OrangeColors.error, width: 2.0),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: OrangeColors.secondaryText,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
