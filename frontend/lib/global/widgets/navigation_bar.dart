import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/notifiers.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    void setSelectedTab(int index) {
      setState(() {
        selectedTab = index;
        Notifiers.selectedTab.value = index;
      });
    }

    return ValueListenableBuilder(
      valueListenable: Notifiers.selectedTab,
      builder: (BuildContext context, selectedTabNotifier, Widget? child) {
        return BottomNavigationBar(
          currentIndex: selectedTabNotifier,
          onTap: setSelectedTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.calendar),
              label: "Lectures",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.menuSquare),
              label: "Menu",
            ),
          ],
        );
      },
    );
  }
}
