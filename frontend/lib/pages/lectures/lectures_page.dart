import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/dummy.dart';
import 'package:plan_pm/global/extensions.dart';
import 'package:plan_pm/global/notifiers.dart';
import 'package:plan_pm/pages/lectures/widgets/day_selection.dart';
import 'package:plan_pm/pages/lectures/widgets/lecture.dart';

class LecturesPage extends StatelessWidget {
  const LecturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  LucideIcons.chevronLeft,
                  color: Colors.blueGrey[400],
                ),
              ),
              Text(
                "Jun 14 - 18, 2025",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  LucideIcons.chevronRight,
                  color: Colors.blueGrey[400],
                ),
              ),
            ],
          ),
        ),
        DaySelection(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ValueListenableBuilder(
            valueListenable: Notifiers.selectedDay,
            builder: (BuildContext context, value, Widget? child) {
              return Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value.toCapitalized,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${dummySchedule.where((lecture) => lecture["Data zajęć"]!.split(" ")[1] == Notifiers.selectedDay.value).length} zajęcia",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ValueListenableBuilder<String>(
              valueListenable: Notifiers.selectedDay,
              builder:
                  (BuildContext context, String currentDay, Widget? child) {
                    return Column(
                      children: dummySchedule
                          .where(
                            (lecture) =>
                                lecture["Data zajęć"]!.split(" ")[1] ==
                                Notifiers.selectedDay.value,
                          )
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (lecture) => Lecture(
                              idx: lecture.key,
                              name: lecture.value["Przedmiot"]!,
                              timeFrom: lecture.value["Czas od"]!,
                              timeTo: lecture.value["Czas do"]!,
                              location: lecture.value["Sala"]!,
                              professor: lecture.value["Prowadzący"]!,
                              group: lecture.value["Grupy"]!,
                              duration: lecture.value["Liczba godzin"]!,
                            ),
                          )
                          .toList(),
                    );
                  },
            ),
          ),
        ),
      ],
    );
  }
}
