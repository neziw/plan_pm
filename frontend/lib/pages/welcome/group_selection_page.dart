import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/main.dart';
import 'package:plan_pm/pages/welcome/widgets/group_builder.dart';
import 'package:plan_pm/pages/welcome/widgets/toast.dart';
import 'package:plan_pm/service/backend_service.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 32,
                child: Icon(LucideIcons.graduationCap, size: 32),
              ),
              Text(
                "Wybierz grupy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              FutureBuilder(
                future: _backendService.fetchGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Przetwarzamy twoje dane..."));
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

                  print(groups);

                  return Column(
                    spacing: 10,
                    children: [
                      Toast(),
                      GroupBuilder(groups: groups),
                    ],
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: "Plan PM"),
                      ),
                    );
                  },
                  child: Text("Kontynuuj"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: "Plan PM"),
                      ),
                    );
                  },
                  child: Text("Pomiń"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
