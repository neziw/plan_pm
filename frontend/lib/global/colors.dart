import 'package:flutter/material.dart';

class AppColor {
  // Tło aplikacji
  // static Color background = Color(0xf7f8faFF);
  // static Color onBackground = Colors.black;
  // static Color onBackgroundVariant = Colors.black.withAlpha(150);

  // // Bloczki
  // static Color surface = Colors.white;
  // static Color onSurface = Colors.black;
  // static Color onSurfaceVariant = Colors.black.withAlpha(100);

  // // Jaskrawe
  // static Color primary = Color(0xFF0884ff);
  // static Color onPrimary = Colors.white;
  // static Color onPrimaryVariant = Colors.black.withAlpha(180);

  // // Utility
  // static Color outline = Colors.black.withAlpha(30);
  // static int colorfulAlphaValue = 40;

  static Color background = const Color(0xFF121212); // Standardowe głębokie tło
  static Color onBackground = const Color(
    0xFFE0E0E0,
  ); // Nie "czysta" biel, lżejsza dla oczu
  static Color onBackgroundVariant = Colors.white.withAlpha(
    150,
  ); // Odpowiednik Twojego wariantu

  // Bloczki
  static Color surface = const Color(
    0xFF1E1E1E,
  ); // Tło "kart", lekko jaśniejsze od tła
  static Color onSurface = const Color(0xFFE0E0E0); // Tekst na kartach
  static Color onSurfaceVariant = Colors.white.withAlpha(
    100,
  ); // Odpowiednik Twojego wariantu

  // Jaskrawe
  static Color primary = const Color(
    0xFF409CFF,
  ); // Lżejszy niebieski, lepszy kontrast
  static Color onPrimary =
      Colors.white; // Czarny ma lepszy kontrast na tym jaśniejszym niebieskim
  static Color onPrimaryVariant = Colors.white.withAlpha(
    180,
  ); // Tutaj wariant pasuje

  // Utility
  static Color outline = Colors.transparent; // Subt
  static int colorfulAlphaValue = 150;
}
