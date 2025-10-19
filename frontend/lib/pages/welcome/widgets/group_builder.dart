import 'package:flutter/material.dart';
import 'package:plan_pm/global/student.dart';

class GroupBuilder extends StatefulWidget {
  const GroupBuilder({super.key, required this.groups});

  final Map<String, dynamic> groups;

  @override
  State<GroupBuilder> createState() => _GroupBuilderState();
}

class _GroupBuilderState extends State<GroupBuilder> {
  final List<String> selectedGroups = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withAlpha(75)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.groups.entries.map(
              (letter) => Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Text(
                          letter.key[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "Grupa ${letter.key}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 5,
                    children: [
                      ...letter.value.map((g) {
                        bool isSelected;
                        if (selectedGroups.contains(g["long"])) {
                          isSelected = true;
                        } else {
                          isSelected = false;
                        }
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            foregroundColor: isSelected
                                ? Colors.white
                                : Colors.black,
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.black.withAlpha(75),
                            ),
                          ),

                          onPressed: () {
                            if (isSelected == true) {
                              setState(() {
                                selectedGroups.remove(g["long"]);
                              });
                            } else {
                              setState(() {
                                selectedGroups.add(g["long"]);
                              });
                            }
                            Student.selectedGroups = selectedGroups;
                          },
                          child: Text(g['short'] ?? g['long'] ?? ''),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
