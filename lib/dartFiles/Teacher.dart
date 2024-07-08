import 'dart:math';
import 'Student.dart';
import 'Assignment.dart';
import 'Course.dart';

class Teacher {
  String teacherName;
  String id;
  String? password;
  int numberOfCoursesInTerm = 0;
  List<Course> coursesInTerm = [];

  Teacher(String name, String id)
      : teacherName = name,
        id = id;

  Teacher.withPassword(this.teacherName, this.id, this.password);

  static String generatePassword(int countTeacher) {
    final now = DateTime.now();
    final random = Random();
    final year = now.year.toString();
    final randomNum = (random.nextInt(900) + 100).toString();
    final count = countTeacher.toString().padLeft(2, '0');
    return '$year$randomNum$count';
  }

  void addCourse(Course course) {
    coursesInTerm.add(course);
    updateNumberOfCourses();
  }

  void addStudent(Student student, Course course) {
    if (!coursesInTerm.contains(course)) {
      print("This teacher doesn't have this course.");
      return;
    }
    if (course.students.contains(student)) {
      print("This student is already in the course.");
      return;
    }
    course.addStudent(student);
    student.addCourse(course);
  }

  void removeStudent(Student student, Course course) {
    if (!coursesInTerm.contains(course)) {
      print("This teacher doesn't have this course.");
      return;
    }
    if (!course.students.contains(student)) {
      print("This student is not in the course.");
      return;
    }
    student.removeCourse(course);
    course.removeStudent(student);
  }

  void setScore(Student student, Course course, double score) {
    if (!coursesInTerm.contains(course)) {
      print("This teacher doesn't have this course.");
      return;
    }
    if (!course.students.contains(student)) {
      print("This student is not in the course.");
      return;
    }
    student.addScore(course, score);
    course.addScore(student, score);
  }

  void addAssignment(Assignment assignment, Course course) {
    if (!coursesInTerm.contains(course)) {
      print("This teacher doesn't have this course.");
      return;
    }
    course.addAssignment(assignment);
  }

  void setAssignmentActivity(Assignment assignment, bool activity) {
    assignment.setActive(activity);
  }

  void removeAssignment(Assignment assignment, Course course) {
    if (!coursesInTerm.contains(course)) {
      print("This teacher doesn't have this course.");
      return;
    }
    course.removeAssignment(assignment);
  }

  void updateNumberOfCourses() {
    numberOfCoursesInTerm = coursesInTerm.length;
  }

  void printCourses() {
    for (var course in coursesInTerm) {
      print(course.name);
    }
  }

  @override
  String toString() {
    return 'Teacher{name: $teacherName, id: $id, password: $password}';
  }
}