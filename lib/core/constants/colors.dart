import 'package:flutter/material.dart';

/// Official Orange Boosted Design System Colors
/// Strict corporate palette: Black, White, and Orange.
class OrangeColors {
  // Core Triad
  static const Color brandOrange = Color(0xFFFF7900); // Primary Brand Orange (CTAs & Highlights)
  static const Color accessibleOrange = Color(0xFFF16E00); // WCAG AA Compliant Orange on White
  static const Color coreBlack = Color(0xFF000000); // Primary Text / Dark Canvas
  static const Color coreWhite = Color(0xFFFFFFFF); // Light Canvas / Text on Orange

  // Monochromes & Grayscale
  static const Color darkGrey = Color(0xFF333333); // Secondary text & dark cards
  static const Color mediumGrey = Color(0xFF666666); // Subtitles, captions, inactive icons
  static const Color borderGrey = Color(0xFFCCCCCC); // Sharp structural borders (1px)
  static const Color lightGrey = Color(0xFFF6F6F6); // Background fills & input backgrounds
  static const Color cardBg = Color(0xFFFFFFFF); // Card background
  static const Color darkSurface = Color(0xFF141416); // Deep charcoal executive background

  // Semantic Accents
  static const Color success = Color(0xFF228722); // Verified status / Success
  static const Color warning = Color(0xFF8F6B00); // Alerts / Attention
  static const Color danger = Color(0xFFCD3C14); // Critical warnings / Errors
  static const Color info = Color(0xFF527EDB); // Informational links
}
