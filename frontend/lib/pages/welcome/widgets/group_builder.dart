import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/l10n/app_localizations.dart';

class GroupBuilder extends StatefulWidget {
  const GroupBuilder({super.key, required this.groups});

  final Map<String, dynamic> groups;

  @override
  State<GroupBuilder> createState() => _GroupBuilderState();
}

String convertLetterToGroup(String letter, AppLocalizations l10n) {
  switch (letter.toLowerCase()) {
    case "a":
      return l10n.groupTypeAuditorium;

    case "c":
      return l10n.groupTypeClasses;

    case "l":
      return l10n.groupTypeLabs;

    default:
      return l10n.groupTypeOther;
  }
}

class _GroupBuilderState extends State<GroupBuilder> {
  final List<String> selectedGroups = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.groups.entries.map(
          (letter) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Text(
                    convertLetterToGroup(letter.key, l10n),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.onBackgroundVariant,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  ...letter.value.map((g) {
                    int groupLength = letter.value.length;
                    bool isSelected = selectedGroups.contains(g["long"]);

                    final Widget button = OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: isSelected
                            ? AppColor.primary
                            : AppColor.surface,
                        foregroundColor: isSelected
                            ? AppColor.onPrimary
                            : AppColor.onSurface,
                        side: BorderSide(
                          color: isSelected
                              ? AppColor.primary
                              : AppColor.outline,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isSelected) {
                            selectedGroups.remove(g["long"]);
                          } else {
                            // Deselect other groups in the same letter group
                            for (var other in letter.value) {
                              selectedGroups.remove(other["long"]);
                            }
                            selectedGroups.add(g["long"]);
                          }
                          Student.selectedGroups = selectedGroups;
                        });
                      },
                      child: Text(
                        g['short'] ?? g['long'] ?? '',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                    if (groupLength > 1) {
                      return Expanded(child: button);
                    }
                    return button;
                  }).toList(),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
