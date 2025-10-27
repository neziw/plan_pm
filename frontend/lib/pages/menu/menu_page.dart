import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/pages/menu/widgets/group_info.dart';
import 'package:plan_pm/pages/menu/widgets/student_info.dart';
import 'package:plan_pm/pages/welcome/welcome_page.dart';
import 'package:plan_pm/l10n/app_localizations.dart';
import 'package:plan_pm/pages/welcome/input_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StudentInfo(),
            GroupInfo(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Debug",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColor.onBackground,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.outline),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Powrót do",
                              style: TextStyle(color: AppColor.onSurface),
                            ),
                            SizedBox(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColor.primary,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WelcomePage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Welcome screen",
                                  style: TextStyle(color: AppColor.onPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
