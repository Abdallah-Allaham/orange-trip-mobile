import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

/// Centralized Design System for Orange Trip Mobile
/// Easy to adjust, extend, or revert.
class AppSpacing {
  static double get s4 => 4.w;
  static double get s8 => 8.w;
  static double get s12 => 12.w;
  static double get s16 => 16.w;
  static double get s20 => 20.w;
  static double get s24 => 24.w; // Default horizontal screen padding
  static double get s32 => 32.w;
  static double get s40 => 40.w;
  static double get s48 => 48.w;
  static double get s64 => 64.w;

  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 24.w);
  static EdgeInsets get cardPadding => EdgeInsets.all(24.w);
  static EdgeInsets get cardPaddingCompact => EdgeInsets.all(20.w);
}

class AppRadius {
  static double get card => 24.r;
  static double get largeCard => 28.r;
  static double get button => 22.r;
  static double get input => 20.r;
  static double get small => 16.r;
  static double get dialog => 28.r;
  static double get bottomSheet => 30.r;

  static BorderRadius get cardRadius => BorderRadius.circular(24.r);
  static BorderRadius get largeCardRadius => BorderRadius.circular(28.r);
  static BorderRadius get buttonRadius => BorderRadius.circular(22.r);
  static BorderRadius get inputRadius => BorderRadius.circular(20.r);
  static BorderRadius get smallRadius => BorderRadius.circular(16.r);
  static BorderRadius get dialogRadius => BorderRadius.circular(28.r);
  static BorderRadius get bottomSheetRadius => BorderRadius.vertical(top: Radius.circular(30.r));
}

class AppCards {
  /// PRIMARY CARD
  /// Background: #FFF3E8, Border: None, Radius: 24px, Padding: 24–32px
  static BoxDecoration primary({BorderRadius? borderRadius}) {
    return BoxDecoration(
      color: OrangeColors.warmCream,
      borderRadius: borderRadius ?? AppRadius.cardRadius,
    );
  }

  /// SECONDARY CARD
  /// Background: #FFFFFF, Border: 1px solid #E4E4E4, Radius: 20–24px, Padding: 20–24px
  static BoxDecoration secondary({
    BorderRadius? borderRadius,
    bool withSubtleShadow = false,
  }) {
    return BoxDecoration(
      color: OrangeColors.white,
      borderRadius: borderRadius ?? AppRadius.cardRadius,
      border: Border.all(color: OrangeColors.lightBorder, width: 1.0),
      boxShadow: withSubtleShadow
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );
  }
}

class AppTypography {
  static TextStyle largeTitle({Color color = OrangeColors.black}) => GoogleFonts.cairo(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );

  static TextStyle sectionTitle({Color color = OrangeColors.black}) => GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.25,
      );

  static TextStyle cardTitle({Color color = OrangeColors.black}) => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle body({Color color = OrangeColors.black}) => GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.45,
      );

  static TextStyle secondary({Color color = OrangeColors.secondaryText}) => GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  static TextStyle button({Color color = OrangeColors.white}) => GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle smallLabel({Color color = OrangeColors.secondaryText}) => GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: color,
      );
}

class AppBadges {
  static Widget status({
    required String text,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? OrangeColors.warmCream,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: textColor ?? OrangeColors.primaryOrange,
        ),
      ),
    );
  }
}
