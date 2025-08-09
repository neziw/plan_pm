import 'package:flutter/material.dart';

class Notifiers {
  static ValueNotifier<int> selectedTab = ValueNotifier(
    1,
  ); // Zmienna, która przechowuje index strony, na której jesteśmy
  static ValueNotifier<String> selectedDay = ValueNotifier("poniedziałek");
}
