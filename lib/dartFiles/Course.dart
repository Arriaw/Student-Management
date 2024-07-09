class Course {
  int unit;
  String name;
  String teacherName;
  String topStudentName;
  int availableAssignmentsCount;

  Course({required this.name, required this.unit, required this.teacherName, required this.topStudentName, required this.availableAssignmentsCount});

  factory Course.fromString(String courseString) {
    final parts = courseString.split(',');
    return Course(
        name: parts[0],
        teacherName: parts[1],
        unit: int.parse(parts[2]),
        topStudentName: parts[3],
        availableAssignmentsCount: int.parse(parts[4])
    );
  }
}