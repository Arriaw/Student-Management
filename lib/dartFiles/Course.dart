import 'Teacher.dart';
import 'Student.dart';
import 'Assignment.dart';

class Course {
  String id;
  int unit;
  String name;
  Teacher teacher;
  bool isActive = false;
  List<Student> students = [];
  int studentCount = 0;
  Map<Student, double> studentScores = {};
  List<Assignment> assignments = [];
  int assignmentsCount = 0;
  // DateTime examDate;
  List<Assignment> activeAssignments = [];
  late String topStudentName;

  Course({required this.name, required this.unit, required this.id, required this.teacher}){
    // var sortedEntries = studentScores.entries.toList()
    //   ..sort((a, b) => b.value.compareTo(a.value));
    //
    // topStudent = sortedEntries.first.key;
    topStudentName = "Aria";
  }

  void printStudents() {
    for (var student in students) {
      print(student.studentName);
    }
  }

  void printTopStudents() {
    var sortedEntries = studentScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // topStudent = sortedEntries.first.key;
    print('Top Students in $name:');
    for (var i = 0; i < sortedEntries.length; i++) {
      var entry = sortedEntries[i];
      print('    ${i + 1}: Name: ${entry.key.studentName}, Score: ${entry.value}');
    }
  }

  void addScore(Student student, double score) {
    studentScores[student] = score;
  }

  String get getName => name;

  int get getUnit => unit;

  List<Student> get getStudents => students;

  void addStudent(Student student) {
    students.add(student);
    studentScores[student] = 0.0;
    student.addCourse(this);
  }

  void removeStudent(Student student) {
    students.remove(student);
    studentScores.remove(student);
    student.removeCourse(this);
  }

  void addAssignment(Assignment assignment) {
    assignments.add(assignment);
  }

  void removeAssignment(Assignment assignment) {
    assignments.remove(assignment);
  }

  void updateActiveAssignments() {
    activeAssignments = assignments.where((assignment) => assignment.isActive).toList();
  }

  void updateStudentCount() {
    studentCount = students.length;
  }

  void updateAssignmentCount() {
    assignmentsCount = assignments.length;
  }

  List<Assignment> get getActiveAssignments => activeAssignments;

  List<Assignment> get getAssignments => assignments;

  int get getAssignmentsCount {
    updateAssignmentCount();
    return assignmentsCount;
  }

  // DateTime get getExamDate => examDate;

  Teacher? get getTeacher => teacher;

  int get getStudentCount {
    updateStudentCount();
    return studentCount;
  }

  void setActive(bool isActive) {
    this.isActive = isActive;
  }

  bool get getIsActive => isActive;

  String get getID => id;

  void setTeacher(Teacher teacher) {
    this.teacher = teacher;
  }
}