import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/pages/welcome/group_selection_page.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wybrane grupy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 35,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupSelectionPage(),
                    ),
                  );
                },
                label: Text("Zmień grupy"),
                icon: Icon(LucideIcons.edit3),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(
                    color: Colors.black.withAlpha(50),
                  ), // outline color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wybrane grupy",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withAlpha(150),
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children:
                          Student.selectedGroups != null &&
                              Student.selectedGroups!.isNotEmpty
                          ? Student.selectedGroups!
                                .expand((group) => group.split(","))
                                .map(
                                  (g) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black.withAlpha(50),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 7,
                                      ),
                                      child: Text(
                                        g
                                            .split("/")[0]
                                            .trim()
                                            .replaceAll("(", "")
                                            .replaceAll(")", ""),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                          : [Text("Brak danych")],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
