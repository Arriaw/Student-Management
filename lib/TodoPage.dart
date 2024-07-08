import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'Assignments.dart';
import 'Classes.dart';
import 'Homepage.dart';
import 'News.dart';

class Task {
  String title;
  DateTime dueDate;
  bool isDone;

  Task({required this.title, required this.dueDate, required this.isDone});

  factory Task.fromString(String taskString) {
    final parts = taskString.split(',');
    return Task(
      title: parts[0],
      dueDate: DateTime.parse(parts[1]),
      isDone: parts[2] == 'true',
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  int _pageIndex = 3;
  List<Task> tasks = [];
  String host = "192.168.100.14";
  int port = 8080;
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = getTasks();
  }

  Future<void> getTasks() async {
    String response = '';
    final completer = Completer<String>();
    print("Connecting to server as getTask ...");
    try {
      final socket = await Socket.connect(host, port);
      socket.write("getTasks~${202438100}\u0000");
      await socket.flush();
      print("Connected to server as getTask");

      socket.listen((data) {
        response = utf8.decode(data.sublist(2));
        completer.complete(response);
        socket.destroy();
      }, onError: (error) {
        print('Error: $error');
        completer.completeError(error);
      }, onDone: () {
        if (!completer.isCompleted) {
          completer.complete(response);
        }
        socket.destroy();
      });
    } catch (e) {
      print('Error: $e');
      completer.completeError(e);
    }
    
    try {
    response = await completer.future;
    print("The getTask response is: ${response}");
    if (response == "404") {
      print("no tasks yet");
    }
    else {
      setState(() {
        tasks = response.split('\n')
            .where((task) => task.isNotEmpty)
            .map((task) => Task.fromString(task))
            .toList();
        });
      }
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[AssignmentsPage(), NewsPage(), ClassesPage(), TodoListPage(), Homepage()];

  void _onBottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _widgetOptions[index]));
    });
  }

  Future<void> addTaskToServer(Task task) async {
    String response = '';
    final completer = Completer<String>();

    try {
      final socket = await Socket.connect(host, port);
      print("connected to server as addTask");
      socket.write(
          'addTask~${202438100}~${task.title}~${task.dueDate.toString()}~${task.isDone}\u0000');
      socket.flush();
      socket.listen((data) {
        response = utf8.decode(data);
        print("addTask response: ${response}");
        completer.complete(response);
      });
      socket.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addTask(String title, DateTime dueDate) {
    final newTask = Task(title: title, dueDate: dueDate, isDone: false);
    setState(() {
      tasks.add(newTask);
    });
    addTaskToServer(newTask);
  }


  Future<void> toggleTaskOnServer(Task task) async {
    String response = '';
    final completer = Completer<String>();

    try {
      final socket = await Socket.connect(host, port);
      print("connected to server as toggleTask");
      socket.write(
          'toggleTask~${202438100}~${task.title}~${task.dueDate.toString()}~${task.isDone}\u0000');
      socket.flush();
      socket.listen((data) {
        response = utf8.decode(data);
        print("toggleTask response : " + response);
        completer.complete(response);
      });
      socket.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
    toggleTaskOnServer(task);
  }

  Future<void> deleteTaskFromServer(Task task) async {
    try {
      final socket = await Socket.connect(host, port);
      socket.write(
          'deleteTask~${202438100}~${task.title}~${task.dueDate.toString()}\u0000');
      socket.flush();

      socket.listen((data) {
        final response = utf8.decode(data);
        print(response); // Handle response if needed
      });
      socket.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
    deleteTaskFromServer(task);
  }


  String _formatJalaliDateTime(DateTime dateTime) {
    final Jalali jalaliDate = Jalali.fromDateTime(dateTime);
    return '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}  -  ${dateTime.hour}:${dateTime.minute}';
  }

  String _formatJalaliDate(DateTime dateTime) {
    final Jalali jalaliDate = Jalali.fromDateTime(dateTime);
    return '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';
  }

  String _calculateRemainingDays(DateTime dueDate) {
    final Duration difference = dueDate.difference(DateTime.now());
    if (difference.inDays >= 1) {
      return '‏${difference.inDays} روز تا ددلاین ';
    } else if (difference.inDays == 0 && difference.inMinutes > 0) {
      return '‏${difference.inHours}:${difference.inMinutes - difference.inHours * 60} ساعت تا ددلاین ';
    } else {
      return 'زمان ددلاین گذشته است';
    }
  }

  void _showAddTaskDialog() {
    TextEditingController titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    print(selectedTime);
    print(selectedDate);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'افزودن تسک جدید',
                style: TextStyle(fontFamily: 'Bnazanin', fontSize: 32),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(border: UnderlineInputBorder(), hintText: '                       عنوان'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "برای تاریخ : ${_formatJalaliDate(selectedDate)}",
                    style: const TextStyle(fontFamily: 'Bnazanin', fontSize: 19),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: const Text(
                      'تاریخ',
                      style: TextStyle(fontSize: 20, fontFamily: 'Bnazanin'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "برای ساعت : ${selectedTime.hour}:${selectedTime.minute}",
                    style: const TextStyle(fontFamily: 'Bnazanin', fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: const Text(
                      'ساعت',
                      style: TextStyle(fontSize: 20, fontFamily: 'Bnazanin'),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'لغو',
                    style: TextStyle(fontSize: 20, fontFamily: 'Bnazanin'),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'افزودن',
                    style: TextStyle(fontSize: 20, fontFamily: 'Bnazanin'),
                  ),
                  onPressed: () {
                    final DateTime dueDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    _addTask(titleController.text, dueDateTime);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
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
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'کار ها',
            style: TextStyle(fontFamily: 'Bnazanin', fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                      child: Text(
                        '‏${f.d} ${f.mN} ${f.y}',
                        style: const TextStyle(color: Colors.black54, fontSize: 23, fontFamily: 'Bnazanin'),
                      ),
                    ),
                  ),
                  notFinishedTasks.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'با به علاوه پایین ، تسک خود را ایجاد کنید.',
                              style: TextStyle(fontFamily: 'Bnazanin', fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        )
                      : _buildTaskSection('کار های ناتمام', notFinishedTasks, false),
                  if (doneTasks.isNotEmpty) _buildTaskSection('کار های انجام شده', doneTasks, true),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 30,
        selectedFontSize: 17,
        unselectedFontSize: 14,
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
        selectedItemColor: const Color.fromRGBO(31, 48, 110, 1),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Task> tasks, bool isDoneSection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Bnazanin'),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            return Card(
              elevation: 7,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  task.title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                subtitle: Column(children: [
                  Text(
                    "ددلاین : ${_formatJalaliDateTime(task.dueDate)}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 17, fontFamily: 'Bnazanin'),
                  ),
                  Text(
                    _calculateRemainingDays(task.dueDate),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontFamily: 'Bnazanin', fontSize: 16),
                  ),
                ]),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(isDoneSection ? Icons.undo : Icons.check_circle_outlined, color: isDoneSection ? Colors.orange : Colors.green),
                      onPressed: () {
                        _toggleTask(task);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                      onPressed: () {
                        _deleteTask(task);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
