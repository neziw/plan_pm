class Faculty {
  final String name;
  Faculty({required this.name});
}

class DegreeCourse {
  final String name;
  final Faculty faculty;

  DegreeCourse({required this.name, required this.faculty});
}

class Specialisation {
  final String name;
  final DegreeCourse degreeCourse;

  Specialisation({required this.name, required this.degreeCourse});
}
