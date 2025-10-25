import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/pages/welcome/input_page.dart';

class StudentInfo extends StatelessWidget {
  const StudentInfo({super.key});

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
              "Informacje akademickie",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 35,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const InputPage()),
                  );
                },
                label: Text("Edytuj"),
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoText(title: "Wydział", content: Student.faculty),
              Divider(
                height: 5,
                thickness: 1,
                indent: 12,
                color: Colors.black.withAlpha(50),
              ),
              InfoText(title: "Kierunek", content: Student.degreeCourse),
              Divider(
                height: 5,
                thickness: 1,
                indent: 12,
                color: Colors.black.withAlpha(50),
              ),
              InfoText(title: "Specjalizacja", content: Student.specialisation),
              Divider(
                height: 5,
                thickness: 1,
                indent: 12,
                color: Colors.black.withAlpha(50),
              ),
              InfoText(
                title: "Rok studiów",
                content: "${Student.year.toString()} rok",
              ),
              Divider(
                height: 5,
                thickness: 1,
                indent: 12,
                color: Colors.black.withAlpha(50),
              ),
              InfoText(title: "Tryb studiów", content: Student.term),
            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black.withAlpha(150)),
          ),
          Row(
            children: [
              Text(
                content ?? "Brak danych",
                softWrap: true,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
