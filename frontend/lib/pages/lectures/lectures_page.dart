import 'package:flutter/material.dart';
import 'package:plan_pm/api/models/lecture_model.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/pages/home/widgets/today_lectures.dart';
import 'package:plan_pm/pages/lectures/widgets/day_selection.dart';
import 'package:plan_pm/pages/lectures/widgets/lecture.dart';
import 'package:plan_pm/service/backend_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LecturesPage extends StatefulWidget {
  const LecturesPage({super.key});

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
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

  late int selectedDay = currentDate.weekday - 1;

  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DaySelection(
            currentDate: currentDate,
            defaultSelected: selectedDay,
            onChange: (selectedDay, selectedDate) {
              setState(() {
                selectedDay = selectedDay;
                currentDate = selectedDate;
              });
            },
          ),
        ),
        FutureBuilder<List<LectureModel>>(
          future: _backendService.fetchLectures(currentDate),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Błąd w FutureBuilder ${snapshot.error}'),
              );
            }
            final unfilteredLectures = snapshot.data ?? [];
            // print(snapshot.data);
            if (unfilteredLectures.isEmpty &&
                snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: NoUpcomingClasses(),
              );
            }

            print(unfilteredLectures);

            final lectures = unfilteredLectures.where((lecture) {
              final lectureDate = lecture.date;
              return lectureDate.year == currentDate.year &&
                  lectureDate.month == currentDate.month &&
                  lectureDate.day == currentDate.day;
            }).toList();
            if (lectures.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: NoUpcomingClasses(),
              );
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${lectures.length} zajęcia",
                          style: TextStyle(color: AppColor.onBackgroundVariant),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Skeletonizer(
                        effect: const ShimmerEffect(
                          baseColor: Color(0x4FFFFFFF),
                        ),
                        enabled:
                            snapshot.connectionState == ConnectionState.waiting,
                        child: ListView.separated(
                          itemCount: lectures.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5);
                          },
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
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
