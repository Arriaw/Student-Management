import 'Course.dart';

class Assignment {
  String name;
  String description;
  double score;
  Course course;
  DateTime deadline;
  int remainingDays = 0;
  bool isActive = false;

  Assignment(this.course, String deadline, this.name, this.description, this.score)
      : deadline = DateTime.parse('yyyy-MM-dd');

  void setDeadline(String deadline) {
    this.deadline = DateTime.parse('yyyy-MM-dd');
  }

  DateTime get getDeadline => deadline;

  void _updateRemainingDays() {
    final currentDate = DateTime.now();
    remainingDays = deadline.difference(currentDate).inDays;
  }

  void printRemainingDays() {
    if (!isActive) {
      print('This assignment is not active yet.');
      return;
    }
    _updateRemainingDays();
    if (remainingDays > 0) {
      print('You have $remainingDays days to do the assignment.');
    } else if (remainingDays == 0) {
      print('Deadline is today !!');
    } else {
      print('Deadline has already ended :(');
    }
  }

  void setActive(bool isActive) {
    this.isActive = isActive;
  }

  bool get getIsActive => isActive;

  Course get getCourse => course;

  String get getDescription => description;

  String get getName => name;

  double get getScore => score;

  int get getRemainingDays {
    _updateRemainingDays();
    return remainingDays;
  }
}