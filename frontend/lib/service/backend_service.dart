import 'package:plan_pm/api/models/lecture_model.dart';
import 'package:plan_pm/global/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BackendService {
  static final BackendService _backendService = BackendService._internal();

  factory BackendService() {
    return _backendService;
  }

  BackendService._internal();

  Future<List<LectureModel>> fetchLectures() async {
    if (Student.specialisation == null) {
      print("Specjalizacja studenta nie została ustawiona");
      return [];
    }
    final response = await Supabase.instance.client
        .from("classes")
        .select('''
        id,
        group,
        subject,
        startTime,
        endTime,
        programs!inner(name),
        teachersclasses(teachers(fullName, title)),
        rooms:room(
          name,
          building:building(name)
        )
      ''')
        .eq("programs.name", Student.specialisation!);
    final data = response;
    return data.map((json) => LectureModel.fromJson(json)).toList();
  }
}
