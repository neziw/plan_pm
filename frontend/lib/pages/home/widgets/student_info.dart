import 'package:flutter/material.dart';
import 'package:plan_pm/global/student.dart';

class StudentInfo extends StatelessWidget {
  const StudentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informacje na temat studenta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withAlpha(50)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(title: "Wydział", content: Student.faculty),
                    InfoText(title: "Kierunek", content: Student.degreeCourse),
                    InfoText(
                      title: "Specjalizacja",
                      content: Student.specialisation,
                    ),
                    InfoText(
                      title: "Rok studiów",
                      content: "${Student.year.toString()} rok",
                    ),
                    InfoText(title: "Tryb studiów", content: Student.term),
                    InfoText(
                      title: "Wybrane grupy",
                      content: Student.selectedGroups
                          ?.map(
                            (group) =>
                                group.split(",").map((g) => g.split("/")[0]),
                          )
                          .toString()
                          .trim()
                          .replaceAll("(", "")
                          .replaceAll(")", ""),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({super.key, required this.title, required this.content});

  final String title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              children: [
                Text(
                  content ?? "Brak danych",
                  softWrap: true,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        );
      },
    );
  }
}
