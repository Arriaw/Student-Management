import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'Assignments.dart';
import 'Classes.dart';
import 'Homepage.dart';
import 'News.dart'; // Ensure this is installed correctly

class Task {
  String title;
  DateTime dueDate;
  bool isDone;

  Task({required this.title, required this.dueDate, required this.isDone});
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  int _pageIndex = 3;
  List<Task> tasks = [];

  static List<Widget> _widgetOptions = <Widget>[
    AssignmentsPage(),
    NewsPage(),
    ClassesPage(),
    TodoListPage(),
    Homepage()
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => _widgetOptions[index])
      );
    });
  }

  void _addTask(String title, DateTime dueDate) {
    setState(() {
      tasks.add(Task(title: title, dueDate: dueDate, isDone: false));
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void _showAddTaskDialog() {
    TextEditingController titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('      افزودن تسک جدید'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '                       عنوان'),
              ),
              SizedBox(height: 20),
              Text("برای : ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate)
                    setState(() {
                      selectedDate = picked;
                    });
                },
                child: Text('تاریخ'),
              ),
              SizedBox(height: 20),
              Text("Due Time: ${selectedTime.format(context)}"),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null && pickedTime != selectedTime)
                    setState(() {
                      selectedTime = pickedTime;
                    });
                },
                child: Text('Select time'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('کنسله'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('افزودن'),
              onPressed: () {
                final DateTime dueDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                _addTask(titleController.text, selectedDate);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Jalali jalaliDate = Jalali.now();
    final f = jalaliDate.formatter;
    List<Task> notFinishedTasks = tasks.where((task) => !task.isDone).toList();
    List<Task> doneTasks = tasks.where((task) => task.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'کار ها',
            style: TextStyle(fontFamily: 'Lato', fontSize: 40),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
              child: Text(
                '‏${f.d} ${f.mN} ${f.y}',
                style: TextStyle(color: Colors.black54, fontSize: 17),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 2,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, sectionIndex) {
                List<Task> tasksInSection =
                sectionIndex == 0 ? notFinishedTasks : doneTasks;
                String sectionTitle =
                sectionIndex == 0 ? '' : '                              کار های انجام شده';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        sectionTitle,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tasksInSection.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(tasksInSection[index].title),
                          subtitle: Text(
                            "ددلاین : ${DateFormat('yyyy-MM-dd – kk:mm').format(tasksInSection[index].dueDate)}",
                          ),
                          trailing: IconButton(
                            icon: Icon(sectionIndex == 0
                                ? Icons.check
                                : Icons.undo),
                            onPressed: () {
                              _toggleTask(tasksInSection[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'تمرین ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert),
            label: 'خبر ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'کلاس ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'کار ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'سرا',
          ),
        ],
        currentIndex: _pageIndex,
        selectedItemColor: Color.fromRGBO(31, 48, 110, 1),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTapped
      ),
    );
  }
}
