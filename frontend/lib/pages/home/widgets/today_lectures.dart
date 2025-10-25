import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  int currentWeekDay = DateTime.now().weekday - 1;

  DateTime now = DateTime.now();
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    if (now.weekday == DateTime.saturday) {
      // Saturday -> next Monday
      currentDate = now.add(Duration(days: 2));
    } else if (now.weekday == DateTime.sunday) {
      // Sunday -> next Monday
      currentDate = now.add(Duration(days: 1));
    } else {
      currentDate = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Twoje najblizsze zajęcia",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        FutureBuilder<List<LectureModel>>(
          future: _backendService.fetchLectures(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Błąd w FutureBuilder ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(12),
                    dashPattern: [10, 5],
                    color: Colors.black.withAlpha(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      spacing: 5,
                      children: [
                        LoadingAnimationWidget.progressiveDots(
                          color: Colors.black.withAlpha(75),
                          size: 48,
                        ),
                        Text(
                          "Ładowanie planu",
                          style: TextStyle(color: Colors.black.withAlpha(100)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            final unfilteredLectures = snapshot.data ?? [];
            if (unfilteredLectures.isEmpty) {
              return NoUpcomingClasses();
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
              return NoUpcomingClasses();
            }

            return Column(
              spacing: 10,
              children: [
                Skeletonizer(
                  effect: const ShimmerEffect(baseColor: Color(0x4FFFFFFF)),
                  enabled: snapshot.connectionState == ConnectionState.waiting,
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
            );
          },
        ),
      ],
    );
  }
}

class NoUpcomingClasses extends StatelessWidget {
  const NoUpcomingClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 5],
          radius: Radius.circular(12),
          color: Colors.black.withAlpha(50),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Icon(
                  LucideIcons.calendarX,
                  size: 32,
                  color: Colors.black.withAlpha(120),
                ),
                Text(
                  "Brak zajęć na dziś",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Jesteś na bieżąco! Skorzystaj z wolnego czasu lub przejrzyj swój harmonogram.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
