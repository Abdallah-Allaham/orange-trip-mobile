import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Font option for Arabic script across platforms.
/// [notoSansArabic] is the official Orange Design System non-Latin font for Android.
/// [cairo] is available for testing or alternative Arabic typography choice.
enum ArabicFontOption {
  notoSansArabic,
  cairo,
}

/// Font option for English / Latin script.
/// [roboto] is the official Orange Design System Android font.
/// [systemDefault] uses Apple's native San Francisco (SF Pro) on iOS.
/// [cairo] uses Cairo's Latin letters (handy for testing against the old font).
enum EnglishFontOption {
  roboto,
  systemDefault,
  cairo,
}

/// Centralized Font System following Orange Design System (ODS) specifications:
/// - iOS: Native San Francisco (SF Pro for English, SF Arabic for Arabic)
/// - Android: Roboto for English, Noto Sans Arabic (or Cairo) for Arabic
/// - Web: Orange Helvetica Neue / Roboto for English, Cairo / Noto Sans Arabic for Arabic
class AppFont {
  /// Toggleable Arabic font preference for Android / Web.
  /// Defaults to [ArabicFontOption.notoSansArabic] per Orange Design System Guidelines.
  static ArabicFontOption arabicFontOption = ArabicFontOption.notoSansArabic;

  /// Toggleable English font preference.
  /// Defaults to [EnglishFontOption.systemDefault] on iOS (San Francisco)
  /// and [EnglishFontOption.roboto] on Android per Orange Design System Guidelines.
  static EnglishFontOption englishFontOption = (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
      ? EnglishFontOption.systemDefault
      : EnglishFontOption.roboto;

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

    // ==========================================
    // 1. ARABIC RESOLVER
    // ==========================================
    if (arabic) {
      // On iOS: if using official guidelines, Apple's native system Arabic (SF Arabic) is used
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && arabicFontOption == ArabicFontOption.notoSansArabic) {
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

      // If set to Cairo (for testing or preference)
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

      // Default Android & Web fallback: Noto Sans Arabic (ODS Standard)
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
    }

    // ==========================================
    // 2. ENGLISH / LATIN RESOLVER
    // ==========================================
    if (englishFontOption == EnglishFontOption.cairo) {
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

    if (englishFontOption == EnglishFontOption.systemDefault) {
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

    // Default: Roboto (ODS Standard for Android / Web)
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
