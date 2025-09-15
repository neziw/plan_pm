import 'package:intl/intl.dart';

class LectureModel {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final String room;
  final String building;
  final String location;
  final String professor;
  final String group;
  final String duration;

  LectureModel(
    this.location,
    this.duration, {
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.building,
    required this.group,
    required this.professor,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> teachersObject = json["teachersclasses"];
    String professors = teachersObject
        .map((t) {
          final teacher = t["teachers"];
          if (teacher == null) return "Brak nauczyciela";
          return "${teacher["title"] ?? ""} ${teacher["fullName"] ?? ""}"
              .trim();
        })
        .where((name) => name.isNotEmpty)
        .join(", ");

    DateTime timeFrom = DateTime.parse(json["startTime"]);
    DateTime timeTo = DateTime.parse(json["endTime"]);
    int duration = timeTo.difference(timeFrom).inMinutes;
    String location =
        "${json["rooms"]["building"]["name"]} ${json["rooms"]["name"]}";
    return LectureModel(
      location,
      "${duration} min",
      id: json["id"] as String,
      name: json["subject"] as String,
      startTime: DateFormat.Hm().format(timeFrom).toString(),
      endTime: DateFormat.Hm().format(timeTo).toString(),
      room: json["rooms"]["name"] ?? "No room",
      building: json["rooms"]["building"]["name"] ?? "No building",
      group: json["group"] as String,
      professor: professors,
    );
  }

  @override
  String toString() {
    return 'Lecture(id: $id, name: $name, startTime: $startTime, endTime: $endTime, room: $room, building: $building, location: $location, professor: $professor, group: $group, duration: $duration)';
  }
}
