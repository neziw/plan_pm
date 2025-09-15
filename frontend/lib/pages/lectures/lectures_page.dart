import 'package:flutter/material.dart';
import 'package:plan_pm/api/models/lecture_model.dart';
import 'package:plan_pm/global/notifiers.dart';
import 'package:plan_pm/pages/lectures/widgets/day_selection.dart';
import 'package:plan_pm/pages/lectures/widgets/lecture.dart';
import 'package:plan_pm/service/backend_service.dart';

class LecturesPage extends StatefulWidget {
  const LecturesPage({super.key});

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();
    return Column(
      children: [
        DaySelection(),

        FutureBuilder<List<LectureModel>>(
          future: _backendService.fetchLectures(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Błąd: ${snapshot.error}'));
            }
            if (snapshot.data == null) {
              return Center(child: Text("No data"));
            }
            final lectures = snapshot.data ?? [];
            if (lectures.isEmpty) {
              return Center(child: Text("No data"));
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder(
                valueListenable: Notifiers.selectedDay,
                builder: (BuildContext context, value, Widget? child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("${lectures.length} zajęcia")],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: lectures.length,
                          itemBuilder: (context, index) {
                            final lecture = lectures[index];
                            return Lecture(
                              idx: index,
                              name: lecture.name,
                              timeFrom: lecture.startTime,
                              timeTo: lecture.endTime,
                              location: lecture.location,
                              professor: lecture.professor,
                              group: lecture.group,
                              duration: lecture.duration,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
