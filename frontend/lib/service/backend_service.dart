import 'package:intl/intl.dart';
import 'package:plan_pm/api/models/lecture_model.dart';
import 'package:plan_pm/global/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'dart:developer' as developer;

class BackendService {
  static final BackendService _backendService = BackendService._internal();

  void messToText(List<Map<String, dynamic>> response) {
    response.forEach((value) {
      print(
        "${value["group"]}|${DateFormat.EEEE().format(DateTime.parse(value["startTime"]))}|${value["startTime"]} - ${value["endTime"]}, Subject: ${value["subject"]}, ",
      );
    });
  }

  String DateTimeToSupabase(DateTime datetime) {
    return DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime(datetime.year, datetime.month, datetime.day));
  }

  factory BackendService() {
    return _backendService;
  }

  BackendService._internal();

  Future<List<LectureModel>> fetchLectures(DateTime filterDate) async {
    if (Student.specialisation == null) {
      print("Specjalizacja studenta nie została ustawiona");
    }
    final List<String> selectedGroups = Student.selectedGroups ?? [];

    final today = filterDate;
    final tomorrow = filterDate.add(Duration(days: 1));

    var query = Supabase.instance.client
        .from("classes")
        .select('''
        id,
        group,
        subject,
        startTime,
        endTime,
        programs!inner(name, programType, year),
        teachersclasses(teachers(fullName, title)),
        rooms:room(
          name,
          building:building(name)
        )
      ''')
        .gte('startTime', DateTimeToSupabase(today))
        .lt('startTime', DateTimeToSupabase(tomorrow))
        .eq("programs.programType", Student.term?[0] ?? "S")
        .eq(
          "programs.name",
          Student.specialisation ?? Student.degreeCourse ?? "",
        )
        .eq("programs.year", Student.year ?? 0);

    if (selectedGroups.isNotEmpty) {
      query = query.inFilter("group", selectedGroups);
    }

    final response = await query;

    final data = response;

    // messToText(data);
    // developer.log(data.toString());

    // print(data);
    final lectures = data.map((json) => LectureModel.fromJson(json)).toList();
    lectures.sort((a, b) => a.date.compareTo(b.date));
    return lectures;
  }

  Future<List<String>> fetchGroups() async {
    List<Map<String, dynamic>> response = await Supabase.instance.client.rpc(
      "get_distinct_groups",
      params: {
        'program_name_filter':
            Student.specialisation ?? Student.degreeCourse ?? "",
        'program_type_filter': Student.term?[0] ?? "S",
        'program_year_filter': Student.year ?? 0,
      },
    );
    List<String> data = response
        .map((group) => group.values.first as String)
        .toList();
    return data;
  }
}
