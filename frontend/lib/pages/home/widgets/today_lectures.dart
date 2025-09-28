import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_pm/api/models/lecture_model.dart';
import 'package:plan_pm/pages/lectures/widgets/lecture.dart';
import 'package:plan_pm/service/backend_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

List<LectureModel> getClosestLectures(
  List<LectureModel> lectures,
  TimeOfDay referenceTime, {
  int count = 3,
}) {
  lectures.sort((a, b) {
    final aTime = TimeOfDay.fromDateTime(
      DateFormat("HH:mm").parse(a.startTime),
    );
    final bTime = TimeOfDay.fromDateTime(
      DateFormat("HH:mm").parse(b.startTime),
    );

    int aMinutes =
        (aTime.hour * 60 + aTime.minute) -
        (referenceTime.hour * 60 + referenceTime.minute);
    int bMinutes =
        (bTime.hour * 60 + bTime.minute) -
        (referenceTime.hour * 60 + referenceTime.minute);

    if (aMinutes < 0 && bMinutes >= 0) return 1;
    if (bMinutes < 0 && aMinutes >= 0) return -1;

    return aMinutes.abs().compareTo(bMinutes.abs());
  });

  // Filter out past lectures
  final filtered = lectures.where((lecture) {
    final lectureTime = TimeOfDay.fromDateTime(
      DateFormat("HH:mm").parse(lecture.startTime),
    );
    final minutesDiff =
        (lectureTime.hour * 60 + lectureTime.minute) -
        (referenceTime.hour * 60 + referenceTime.minute);
    return minutesDiff >= 0;
  }).toList();

  return filtered.take(count).toList();
}

class TodayLectures extends StatefulWidget {
  const TodayLectures({super.key});

  @override
  State<TodayLectures> createState() => _TodayLecturesState();
}

class _TodayLecturesState extends State<TodayLectures> {
  final DateTime currentDate = DateTime(2025, 6, 16, 9, 45);

  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Najblizsze zajęcia",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        FutureBuilder<List<LectureModel>>(
          future: _backendService.fetchLectures(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Błąd w FutureBuilder ${snapshot.error}'),
              );
            }
            if (snapshot.data == null) {
              return Center(child: Text("Brak zajęć na dziś"));
            }
            final unfilteredLectures = snapshot.data ?? [];
            if (unfilteredLectures.isEmpty) {
              return Center(child: Text("No data"));
            }

            final lectures = getClosestLectures(
              unfilteredLectures.where((lecture) {
                final lectureDate = lecture.date;
                return lectureDate.year == currentDate.year &&
                    lectureDate.month == currentDate.month &&
                    lectureDate.day == currentDate.day;
              }).toList(),
              TimeOfDay.fromDateTime(currentDate),
            );

            if (lectures.isEmpty) {
              return Center(child: Text("No data"));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                spacing: 10,
                children: [
                  Skeletonizer(
                    effect: const ShimmerEffect(baseColor: Color(0x4FFFFFFF)),
                    enabled:
                        snapshot.connectionState == ConnectionState.waiting,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
              ),
            );
          },
        ),
      ],
    );
  }
}
