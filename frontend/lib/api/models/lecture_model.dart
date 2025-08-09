class Lecture {
  final String id;
  final String name;
  final String programType;
  final String degreeLevel;
  final int semesterNumber;
  final String academicYear;
  final int courseLength;
  final String language;
  final Map<String, dynamic> classes;

  Lecture({
    required this.id,
    required this.name,
    required this.programType,
    required this.degreeLevel,
    required this.semesterNumber,
    required this.academicYear,
    required this.courseLength,
    required this.language,
    required this.classes,
  });

  @override
  String toString() {
    return 'Lecture(id: $id, name: $name, programType: $programType, degreeLevel: $degreeLevel, semesterNumber: $semesterNumber, academicYear: $academicYear, courseLength: $courseLength, language: $language, classes: $classes)';
  }
}
