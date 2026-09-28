import 'package:flutter/material.dart';

/// Premium Enterprise Design System Color Palette
/// Designed specifically for Orange Trip Cairo 2026.
/// MINIMAL + ORANGE + BLACK + WHITE + SOFT GRAYS + WARM CREAM
class OrangeColors {
  // 1. Primary & Brand Colors
  static const Color primaryOrange = Color(0xFFFF7900); // Strategic Highlights & Primary CTAs
  static const Color darkOrange = Color(0xFFF16E00); // WCAG AA Compliant Orange on light surfaces
  static const Color black = Color(0xFF000000); // Primary Headings & High-contrast Text
  static const Color white = Color(0xFFFFFFFF); // Clean Content Surfaces
  static const Color warmCream = Color(0xFFFFF3E8); // Highlighted Cards & Important Info Sections
  static const Color background = Color(0xFFF2F2F2); // Main Application Canvas Background

  // 2. Secondary & Grayscale Hierarchy
  static const Color secondaryText = Color(0xFF8F8F8F); // Metadata, subtitles, inactive states
  static const Color darkSecondaryText = Color(0xFF333333); // Body text, secondary headings
  static const Color lightBorder = Color(0xFFE4E4E4); // Subtle 1px structural card/field borders
  static const Color lightGray = Color(0xFFEEEEEE); // Input fills & soft control surfaces

  // 3. Status & Semantic Colors
  static const Color error = Color(0xFFD6382B); // Destructive actions & error states
  static const Color success = Color(0xFF107C41); // Restrained corporate green

  // Backward-compatible aliases to ensure existing references compile seamlessly
  static const Color brandOrange = primaryOrange;
  static const Color accessibleOrange = darkOrange;
  static const Color coreBlack = black;
  static const Color coreWhite = white;
  static const Color darkGrey = darkSecondaryText;
  static const Color mediumGrey = secondaryText;
  static const Color borderGrey = lightBorder;
  static const Color lightGrey = lightGray;
  static const Color cardBg = white;
  static const Color darkSurface = black;
  static const Color danger = error;
  static const Color warning = Color(0xFF8F6B00);
  static const Color info = primaryOrange;
}
