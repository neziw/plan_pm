import 'package:flutter/material.dart';
import 'package:plan_pm/pages/home/widgets/home_section.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/pages/home/widgets/today_lectures.dart';
import 'package:plan_pm/pages/news/widgets/news_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HomeSection(
              title: "Nowości z uczelni",
              child: NewsBuilder(limit: 3),
            ),
            TodayLectures(),
          ],
        ),
      ),
    );
  }
}
