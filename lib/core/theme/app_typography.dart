import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Font option for Arabic script across platforms.
/// [notoSansArabic] is the official Orange Design System non-Latin font for Android.
/// [cairo] is available as an alternative Arabic typography choice.
enum ArabicFontOption {
  notoSansArabic,
  cairo,
}

/// Centralized Font System following Orange Design System (ODS) specifications:
/// - iOS: Native San Francisco (SF Pro for English, SF Arabic for Arabic)
/// - Android: Roboto for English, Noto Sans Arabic (or Cairo) for Arabic
/// - Web: Orange Helvetica Neue / Roboto for English, Cairo / Noto Sans Arabic for Arabic
class AppFont {
  /// Toggleable Arabic font preference for Android / Web.
  /// Defaults to [ArabicFontOption.notoSansArabic] per Orange Design System Android Guidelines.
  static ArabicFontOption arabicFontOption = ArabicFontOption.notoSansArabic;

  /// Main font factory that dynamically resolves the correct font family
  /// depending on current platform (iOS vs Android vs Web) and current language.
  static TextStyle getStyle({
    BuildContext? context,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
    FontStyle? fontStyle,
    TextBaseline? textBaseline,
    Color? backgroundColor,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    List<Shadow>? shadows,
    bool? isArabic,
  }) {
    final bool arabic = isArabic ?? _detectArabic(context);

    // 1. iOS Platform: Orange Design System mandates native San Francisco (SF Pro & SF Arabic)
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        fontStyle: fontStyle,
        textBaseline: textBaseline,
        backgroundColor: backgroundColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        shadows: shadows,
      );
    }

    // 2. Android Platform: Roboto (EN) or Noto Sans Arabic (AR) per ODS
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      if (arabic) {
        if (arabicFontOption == ArabicFontOption.cairo) {
          return GoogleFonts.cairo(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            fontStyle: fontStyle,
            textBaseline: textBaseline,
            backgroundColor: backgroundColor,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationStyle: decorationStyle,
            decorationThickness: decorationThickness,
            shadows: shadows,
          );
        }
        return GoogleFonts.notoSansArabic(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          fontStyle: fontStyle,
          textBaseline: textBaseline,
          backgroundColor: backgroundColor,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          shadows: shadows,
        );
      } else {
        return GoogleFonts.roboto(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          fontStyle: fontStyle,
          textBaseline: textBaseline,
          backgroundColor: backgroundColor,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          shadows: shadows,
        );
      }
    }

    // 3. Web or Desktop platforms
    if (arabic) {
      return GoogleFonts.notoSansArabic(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        fontStyle: fontStyle,
        textBaseline: textBaseline,
        backgroundColor: backgroundColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        shadows: shadows,
      );
    } else {
      return GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        fontStyle: fontStyle,
        textBaseline: textBaseline,
        backgroundColor: backgroundColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        shadows: shadows,
      );
    }
  }

  static bool _detectArabic(BuildContext? context) {
    if (context != null) {
      final locale = Localizations.maybeLocaleOf(context);
      if (locale != null) {
        return locale.languageCode == 'ar';
      }
    }
    return Intl.getCurrentLocale().startsWith('ar');
  }
}
