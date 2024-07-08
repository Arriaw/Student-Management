import 'dart:math';
import 'Course.dart';

class Student {
  String studentName;
  String studentID;
  String password;
  int numberOfCourses = 0;
  int numberOfUnits = 0;
  List<Course> courses = [];
  Map<Course, double> coursesScore = {};
  double averageScore = 0.0;

  Student(String name, String ID, int countStudent)
      : studentName = name,
        studentID = ID,
        password = _generatePassword(countStudent);

  Student.withPassword(this.studentName, this.studentID, this.password);

  static String _generatePassword(int countStudent) {
    final now = DateTime.now();
    final random = Random();
    final year = now.year.toString();
    final randomNum = (random.nextInt(900) + 100).toString();
    final count = countStudent.toString().padLeft(2, '0');
    return '$year$randomNum$count';
  }


  void printRecord() {
    print('Student Record:');
    print('    Number of courses: $numberOfCourses');
    print('    Number of Units: $numberOfUnits');
    print('    Courses Taken:');
    coursesScore.forEach((course, score) {
      print('        ${course.name}: $score');
    });
    print('    Average Score: $averageScore');
  }

  void printCourses() {
    for (var course in courses) {
      print(course.name);
    }
  }

  void signUpInCourse(Course course) {
    if (courses.contains(course)) {
      print('This student is already in this course.');
    } else {
      courses.add(course);
      coursesScore[course] = 0.0;
      print('Signed Up successfully.');
    }
  }

  void _updateNumberOfCourses() {
    numberOfCourses = courses.length;
  }

  void _updateNumberOfUnits() {
    numberOfUnits = courses.fold(0, (sum, course) => sum + course.unit);
  }

  Course? topCourse() {
    if (numberOfCourses == 0) return null;

    return coursesScore.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  Course? worstCourse() {
    if (numberOfCourses == 0) return null;

    return coursesScore.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  void addCourse(Course course) {
    courses.add(course);
    coursesScore[course] = 0.0;
  }

  void removeCourse(Course course) {
    courses.remove(course);
    coursesScore.remove(course);
  }

  void addScore(Course course, double score) {
    coursesScore[course] = score;
  }

  void _updateAverage() {
    if (coursesScore.isEmpty) {
      averageScore = 0.0;
      return;
    }

    final totalScore = coursesScore.entries
        .fold(0.0, (sum, entry) => sum + entry.value * entry.key.unit);
    averageScore = totalScore / numberOfUnits;
  }

  List<Course> get getCourses => courses;

  double get getAverageScore {
    _updateAverage();
    return averageScore;
  }

  String get getStudentName => studentName;

  String get getStudentID => studentID;

  int get getNumberOfUnits {
    _updateNumberOfUnits();
    return numberOfUnits;
  }

  int get getNumberOfCourses {
    _updateNumberOfCourses();
    return numberOfCourses;
  }

  String get getPassword => password;
}
