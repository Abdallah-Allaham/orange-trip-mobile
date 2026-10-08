import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_typography.dart';

class OrangeTheme {
  static const double cardBorderRadius = 24.0;
  static const double buttonBorderRadius = 22.0;
  static const double inputBorderRadius = 20.0;
  static const double dialogBorderRadius = 28.0;

  /// Default light theme getter
  static ThemeData get lightTheme => getLightTheme();

  /// Locale-aware light theme (automatically chooses font for iOS, Android, and Web)
  static ThemeData getLightTheme([Locale? locale]) {
    final bool? isArabic = locale != null ? locale.languageCode == 'ar' : null;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: OrangeColors.primaryOrange,
      scaffoldBackgroundColor: OrangeColors.background,
      colorScheme: const ColorScheme.light(
        primary: OrangeColors.primaryOrange,
        secondary: OrangeColors.darkOrange,
        surface: OrangeColors.white,
        error: OrangeColors.error,
        onPrimary: OrangeColors.white,
        onSurface: OrangeColors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: OrangeColors.white,
        foregroundColor: OrangeColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppFont.getStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: OrangeColors.black,
          isArabic: isArabic,
        ),
      ),
      cardTheme: CardThemeData(
        color: OrangeColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          side: const BorderSide(color: OrangeColors.lightBorder, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OrangeColors.primaryOrange,
          foregroundColor: OrangeColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          textStyle: AppFont.getStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            isArabic: isArabic,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OrangeColors.primaryOrange,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(color: OrangeColors.primaryOrange, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          textStyle: AppFont.getStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            isArabic: isArabic,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OrangeColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: OrangeColors.lightBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: OrangeColors.lightBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: OrangeColors.primaryOrange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: OrangeColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: OrangeColors.error, width: 2.0),
        ),
        labelStyle: AppFont.getStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: OrangeColors.darkSecondaryText,
          isArabic: isArabic,
        ),
        hintStyle: AppFont.getStyle(
          fontSize: 14,
          color: OrangeColors.secondaryText,
          isArabic: isArabic,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: OrangeColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogBorderRadius),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: OrangeColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return OrangeColors.white;
          }
          return OrangeColors.darkSecondaryText;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return OrangeColors.primaryOrange;
          }
          return OrangeColors.lightGray;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      textTheme: TextTheme(
        displayLarge: AppFont.getStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: OrangeColors.black,
          height: 1.2,
          isArabic: isArabic,
        ),
        titleLarge: AppFont.getStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: OrangeColors.black,
          height: 1.25,
          isArabic: isArabic,
        ),
        titleMedium: AppFont.getStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: OrangeColors.black,
          height: 1.3,
          isArabic: isArabic,
        ),
        bodyLarge: AppFont.getStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: OrangeColors.black,
          height: 1.45,
          isArabic: isArabic,
        ),
        bodyMedium: AppFont.getStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: OrangeColors.darkSecondaryText,
          height: 1.4,
          isArabic: isArabic,
        ),
        labelSmall: AppFont.getStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: OrangeColors.secondaryText,
          isArabic: isArabic,
        ),
      ),
    );
  }
}
