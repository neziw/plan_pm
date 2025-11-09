import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/global/widgets/themed_outline_button.dart';
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.onBackground,
              ),
            ),
            SizedBox(
              height: 35,
              child: ThemedOutlineButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputPage()),
                  );
                },
                label: "Edytuj",
                icon: LucideIcons.edit3,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoText(title: "Wydział", content: Student.faculty),
              Divider(
                height: 1,
                thickness: 1,
                indent: 12,
                color: AppColor.outline,
              ),
              InfoText(title: "Kierunek", content: Student.degreeCourse),
              Divider(
                height: 1,
                thickness: 1,
                indent: 12,
                color: AppColor.outline,
              ),
              InfoText(title: "Specjalizacja", content: Student.specialisation),
              Divider(
                height: 1,
                thickness: 1,
                indent: 12,
                color: AppColor.outline,
              ),
              InfoText(
                title: "Rok studiów",
                content: "${Student.year.toString()} rok",
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: 12,
                color: AppColor.outline,
              ),
              InfoText(title: "Tryb studiów", content: Student.term),
              SizedBox(height: 5),
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
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: AppColor.onSurfaceVariant),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              content ?? "Brak danych",
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
