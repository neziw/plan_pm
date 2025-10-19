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

  factory BackendService() {
    return _backendService;
  }

  BackendService._internal();

  Future<List<LectureModel>> fetchLectures() async {
    if (Student.specialisation == null) {
      print("Specjalizacja studenta nie została ustawiona");
    }
    print(Student.year);
    final response = await Supabase.instance.client
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
        .eq("programs.programType", Student.term?[0] ?? "S")
        .eq(
          "programs.name",
          Student.specialisation ?? Student.degreeCourse ?? "",
        )
        .eq("programs.year", Student.year ?? 0);

    final data = response;

    // messToText(data);
    // developer.log(data.toString());

    // print(data);
    return data.map((json) => LectureModel.fromJson(json)).toList();
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
