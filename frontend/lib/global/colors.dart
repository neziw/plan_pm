import 'package:flutter/material.dart';

class ColorThemes {
  static const Color lightBackground = Color(0xf7f8faFF);
  static const Color lightOnBackground = Colors.black;
  static final Color lightOnBackgroundVariant = Colors.black.withAlpha(150);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Colors.black;
  static final Color lightOnSurfaceVariant = Colors.black.withAlpha(100);
  static const Color lightPrimary = Color(0xFF0884ff);
  static const Color lightOnPrimary = Colors.white;
  static final Color lightOnPrimaryVariant = Colors.black.withAlpha(180);
  static final Color lightOutline = Colors.black.withAlpha(30);
  static const int lightColorfulAlphaValue = 40;

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static final Color darkOnBackgroundVariant = Colors.white.withAlpha(150);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static final Color darkOnSurfaceVariant = Colors.white.withAlpha(100);
  static const Color darkPrimary = Color(0xFF409CFF);
  static const Color darkOnPrimary = Colors.white;
  static final Color darkOnPrimaryVariant = Colors.white.withAlpha(180);
  static const Color darkOutline = Colors.transparent;
  static const int darkColorfulAlphaValue = 150;
}

class AppColor {
  static Brightness _brightness = Brightness.light;

  static void update(Brightness brightness) {
    _brightness = brightness;
  }

  static Color get background => _brightness == Brightness.light
      ? ColorThemes.lightBackground
      : ColorThemes.darkBackground;

  static Color get onBackground => _brightness == Brightness.light
      ? ColorThemes.lightOnBackground
      : ColorThemes.darkOnBackground;

  static Color get onBackgroundVariant => _brightness == Brightness.light
      ? ColorThemes.lightOnBackgroundVariant
      : ColorThemes.darkOnBackgroundVariant;

  static Color get surface => _brightness == Brightness.light
      ? ColorThemes.lightSurface
      : ColorThemes.darkSurface;

  static Color get onSurface => _brightness == Brightness.light
      ? ColorThemes.lightOnSurface
      : ColorThemes.darkOnSurface;

  static Color get onSurfaceVariant => _brightness == Brightness.light
      ? ColorThemes.lightOnSurfaceVariant
      : ColorThemes.darkOnSurfaceVariant;

  static Color get primary => _brightness == Brightness.light
      ? ColorThemes.lightPrimary
      : ColorThemes.darkPrimary;

  static Color get onPrimary => _brightness == Brightness.light
      ? ColorThemes.lightOnPrimary
      : ColorThemes.darkOnPrimary;

  static Color get onPrimaryVariant => _brightness == Brightness.light
      ? ColorThemes.lightOnPrimaryVariant
      : ColorThemes.darkOnPrimaryVariant;

  static Color get outline => _brightness == Brightness.light
      ? ColorThemes.lightOutline
      : ColorThemes.darkOutline;

  static int get colorfulAlphaValue => _brightness == Brightness.light
      ? ColorThemes.lightColorfulAlphaValue
      : ColorThemes.darkColorfulAlphaValue;
}
