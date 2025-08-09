import 'package:flutter/material.dart';

class AppColor {
  static var light = _AppColorLight();
}

class _AppColorLight {
  // Tutaj definiujemy kolory dla jasnego motywu
  _AppColorLight();

  Color backgroundPrimary = Color(0xFFFFFFFF);
  Color backgroundSecondary = Color.fromARGB(255, 241, 241, 241);
}
