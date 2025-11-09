import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';
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
      HapticFeedback.lightImpact();
      setState(() {
        selectedTab = index;
        Notifiers.selectedTab.value = index;
      });
    }

    return ValueListenableBuilder(
      valueListenable: Notifiers.selectedTab,
      builder: (BuildContext context, selectedTabNotifier, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColor.outline)),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColor.background,
            selectedItemColor: AppColor.primary,
            unselectedItemColor: AppColor.onBackgroundVariant,
            currentIndex: selectedTabNotifier,
            onTap: setSelectedTab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.home),
                label: "Strona główna",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.calendar),
                label: "Zajęcia",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.newspaper),
                label: "Nowości",
              ),
            ],
          ),
        );
      },
    );
  }
}
