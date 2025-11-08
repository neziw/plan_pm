import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/api/models/lecture_model.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/pages/lectures/widgets/lecture.dart';
import 'package:plan_pm/service/backend_service.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:collection/collection.dart';

List<LectureModel> getClosestLectures(
  List<LectureModel> lectures,
  DateTime referenceTime, {
  int count = 3,
}) {
  // Filter out past lectures
  final filtered = lectures.where((lecture) {
    final minutesDiff = lecture.date.difference(referenceTime).inMinutes;
    return minutesDiff >= 0;
  }).toList();

  // Sort those lectures by date from oldest to newest
  filtered.sort((a, b) {
    return a.date.compareTo(b.date);
  });
  // Take {count} from those lectures
  return filtered.take(count).toList();
}

class TodayLectures extends StatefulWidget {
  const TodayLectures({super.key});

  @override
  State<TodayLectures> createState() => _TodayLecturesState();
}

class _TodayLecturesState extends State<TodayLectures> {
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    int idx = 0;
    final _backendService = BackendService();
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Twoje najblizsze zajęcia",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColor.onBackground,
          ),
        ),
        FutureBuilder<List<LectureModel>>(
          future: _backendService.fetchLectures(DateTime.now()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Błąd w FutureBuilder ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(12),
                    dashPattern: [10, 5],
                    color: AppColor.outline,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      spacing: 5,
                      children: [
                        LoadingAnimationWidget.progressiveDots(
                          color: AppColor.onSurfaceVariant,
                          size: 48,
                        ),
                        Text(
                          "Ładowanie planu",
                          style: TextStyle(color: AppColor.onSurfaceVariant),
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
                    lectureDate.month == currentDate.month;
              }).toList(),
              currentDate,
            );

            if (lectures.isEmpty) {
              return NoUpcomingClasses();
            }

            // Group those lectures by date
            Map<DateTime, List<LectureModel>> groups = groupBy(
              lectures,
              (lecture) => DateTime(
                lecture.date.year,
                lecture.date.month,
                lecture.date.day,
              ),
            );
            return Column(
              spacing: 10,
              children: [
                Skeletonizer(
                  effect: const ShimmerEffect(baseColor: Color(0x4FFFFFFF)),
                  enabled: snapshot.connectionState == ConnectionState.waiting,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: groups.keys.length,
                    itemBuilder: (context, index) {
                      final lectures = groups[groups.keys.toList()[index]];
                      final lecturesWidgets = lectures!.map((lecture) {
                        return Lecture(
                          idx: idx++,
                          name: lecture.name,
                          timeFrom: lecture.startTime,
                          timeTo: lecture.endTime,
                          location: lecture.location,
                          professor: lecture.professor,
                          group: lecture.group,
                          duration: lecture.duration,
                        );
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat(
                              'dd.MM.yyyy - EEE',
                            ).format(groups.keys.toList()[index]),
                            style: TextStyle(
                              color: AppColor.onBackgroundVariant,
                            ),
                          ),
                          ...lecturesWidgets,
                        ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 5],
          radius: Radius.circular(12),
          color: AppColor.outline,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.surface,
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
                  color: AppColor.onSurfaceVariant,
                ),
                Text(
                  "Brak zajęć na dziś",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColor.onSurface,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Jesteś na bieżąco! Skorzystaj z wolnego czasu lub przejrzyj swój harmonogram.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.onSurfaceVariant,
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
