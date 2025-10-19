import 'package:flutter/material.dart';
import 'package:plan_pm/pages/home/widgets/student_info.dart';
import 'package:plan_pm/pages/home/widgets/today_lectures.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[TodayLectures(), StudentInfo()],
          ),
        ),
      ),
    );
  }
}
