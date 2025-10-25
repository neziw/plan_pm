import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/main.dart';
import 'package:plan_pm/pages/welcome/widgets/group_builder.dart';
import 'package:plan_pm/service/backend_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

ButtonStyle buttonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
  ),
);

String longToShort(String long) {
  final pieces = long
      .split(",")
      .map((piece) => piece.split("/")[0])
      .toString()
      .replaceAll("(", "")
      .replaceAll(")", "");

  return pieces;
}

class GroupSelectionPage extends StatelessWidget {
  const GroupSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();
    Student.selectedGroups = [];
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black.withAlpha(50)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: "Plan PM"),
                      ),
                      (r) => false,
                    );
                  },
                  child: Text("Pomiń", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColor.light.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setStringList(
                      "groups",
                      Student.selectedGroups ?? [],
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: "Plan PM"),
                      ),
                      (r) => false,
                    );
                  },
                  child: Text("Zapisz"),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.black.withAlpha(20))),
        title: Text(
          "Ustawienia studiów",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              Text(
                "Na podstawie Twoich ustawień studiów pobraliśmy dostępne grupy. Wybierz jedną lub wiele, aby śledzić kilka planów.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withAlpha(150),
                ),
              ),
              FutureBuilder(
                future: _backendService.fetchGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.white,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: Radius.circular(12),
                          dashPattern: [10, 5],
                          color: Colors.black.withAlpha(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            spacing: 5,
                            children: [
                              LoadingAnimationWidget.progressiveDots(
                                color: Colors.black.withAlpha(75),
                                size: 48,
                              ),
                              Text(
                                "Ładowanie grup...",
                                style: TextStyle(
                                  color: Colors.black.withAlpha(100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Błąd w FutureBuilder ${snapshot.error}'),
                    );
                  }
                  if (snapshot.data == null) {
                    return Center(child: Text("Null"));
                  }
                  final data = snapshot.data!;

                  final groups = data
                      .map((g) {
                        final group = g.toString();
                        if (group.split(",").length > 1) {
                          print("Shitty group found: $group");
                          // Treat as "Other" and keep same short/long when parsing is ambiguous
                          return {
                            "Other": [
                              {"short": longToShort(group), "long": group},
                            ],
                          };
                        }

                        final first = group.split("/")[0];
                        final shortName = first;
                        final longName = group;
                        final key = shortName.isNotEmpty ? shortName[0] : "";

                        return {
                          key: [
                            {"short": shortName, "long": longName},
                          ],
                        };
                      })
                      .fold<Map<String, List<Map<String, String>>>>({}, (
                        acc,
                        elem,
                      ) {
                        elem.forEach((k, v) {
                          acc.putIfAbsent(k, () => []).addAll(v);
                        });
                        return acc;
                      });

                  return Column(
                    spacing: 10,
                    children: [GroupBuilder(groups: groups)],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
