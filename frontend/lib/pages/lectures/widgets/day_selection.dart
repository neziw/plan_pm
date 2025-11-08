import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';

List<String> daysShort = ["Pon", "Wt", "Śr", "Czw", "Pt"];
List<String> days = ["poniedziałek", "wtorek", "środa", "czwartek", "piątek"];

class DaySelection extends StatefulWidget {
  const DaySelection({
    super.key,
    required this.currentDate,
    required this.onChange,
    required this.defaultSelected,
  });

  final Function(int selectedDay, DateTime selectedDate) onChange;
  final int defaultSelected;
  final DateTime currentDate;

  @override
  State<DaySelection> createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  late DateTime currentDate = widget.currentDate;

  late int selectedDay = widget.defaultSelected;

  DateTime getDateFromIndex(DateTime date, int index) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    final dateFromIndex = weekStart.add(Duration(days: index));
    return dateFromIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (currentDate.weekday == 1) {
                      currentDate = currentDate.subtract(Duration(days: 3));
                    } else {
                      currentDate = currentDate.subtract(Duration(days: 1));
                    }
                    selectedDay = currentDate.weekday - 1;
                    widget.onChange(selectedDay, currentDate);
                  });
                },
                icon: Icon(
                  LucideIcons.chevronLeft,
                  color: AppColor.onBackgroundVariant,
                ),
              ),
              Text(
                DateFormat("d MMMM").format(currentDate),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.onBackground,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (currentDate.weekday == 5) {
                      currentDate = currentDate.add(Duration(days: 3));
                    } else {
                      currentDate = currentDate.add(Duration(days: 1));
                    }

                    selectedDay = currentDate.weekday - 1;
                    widget.onChange(selectedDay, currentDate);
                  });
                },
                icon: Icon(
                  LucideIcons.chevronRight,
                  color: AppColor.onBackgroundVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.outline),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColor.surface,
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              daysShort.length,
              (index) => index == selectedDay
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: AppColor.primary,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: null,
                          child: Text(
                            daysShort[index],
                            textAlign: TextAlign.center,
                            softWrap: false,
                            style: TextStyle(
                              color: AppColor.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedDay = index;
                            currentDate = currentDate = getDateFromIndex(
                              currentDate,
                              index,
                            );
                            widget.onChange(selectedDay, currentDate);
                          });
                        },
                        child: Text(
                          daysShort[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColor.onSurfaceVariant),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
