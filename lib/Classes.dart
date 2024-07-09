import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arka_project/dartFiles/Course.dart';
import 'package:flutter/material.dart';
import 'News.dart';
import 'Assignments.dart';
import 'TodoPage.dart';
import 'Homepage.dart';

class ClassesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  int _pageIndex = 2;
  List<Course> courses = [];
  String host = "192.168.100.14";
  int port = 8080;
  late Future<void> _future;
  String res = '';

  static final List<Widget> _widgetOptions = <Widget>[
    AssignmentsPage(),
    NewsPage(),
    ClassesPage(),
    TodoListPage(),
    Homepage(),
  ];

  @override
  void initState() {
    super.initState();
    _future = getClasses();
  }

  Future<void> getClasses() async {
    String response = '';
    final completer = Completer<String>();
    print("Connecting to server as getClasses...");
    try {
      final socket = await Socket.connect(host, port);
      socket.write("getClasses~${202433000}\u0000");
      await socket.flush();
      print("Connected to server as getClasses");

      socket.listen((data) {
        response = utf8.decode(data.sublist(2));
        completer.complete(response);
        socket.destroy();
      }, onError: (error) {
        print("Error: ${error}");
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
      print("The getClasses response is: ${response}");
      if (response == "404") {
        print("no classes yet");
      } else {
        setState(() {
          courses = response.split('\n').where((course) => course.isNotEmpty).map((course) => Course.fromString(course)).toList();
        });
      }
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  Future<String> addCourseToServer(String id) async {
    String response = '';
    final completer = Completer<String>();

    try {
      final socket = await Socket.connect(host, port);
      socket.write('addClass~${202433000}~$id\u0000');
      await socket.flush();
      socket.listen((data) {
        response = String.fromCharCodes(data);
        print("addCourse response: ${response}");
        completer.complete(response);
      });
      socket.close();
    } catch (e) {
      print('Error: $e');
    }
    try {
      response = await completer.future;
    } catch (e) {
      print('Error processing response: $e');
    }
    response = await completer.future;
    return response;
  }

  Future<void> _course200(String id) async {
    String response = '';
    final completer = Completer<String>();

    try {
      final socket = await Socket.connect(host, port);
      print("connected to server as course200");
      socket.write('classInfo~$id\u0000');
      socket.flush();
      socket.listen((data) {
        response = utf8.decode(data);
        print("addTask response: $response");
        completer.complete(response);
      });
      socket.close();
    } catch (e) {
      print('Error: $e');
    }

    try {
      response = await completer.future;
      print("The classInfo response is: ${response}");
      setState(() {
          courses.add(Course.fromString(response));
        });
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  void _addCourse(String id) async {
    String response = await addCourseToServer(id);
    if (response == "404") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'کد گلستان درس اشتباه است',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else if (response == "400") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'در حال حاضر در کلاس هستید',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      _course200(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'کلاس با موفقیت اضافه شد',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    });
  }

  void _showAddClassBottomSheet() {
    TextEditingController classIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '  افزودن کلاس جدید',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 24, fontFamily: "Bnazanin"),
                  ),
                  Icon(Icons.school),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: classIdController,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'کد گلستان درس را وارد نمایید.‏',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _addCourse(classIdController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'افزودن',
                    style: TextStyle(fontFamily: "Bnazanin", fontSize: 23),
                  ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            'کلاس ها',
            style: TextStyle(fontSize: 50, fontFamily: 'Bnazanin', fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
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
                      child: const Text(
                        'ترم بهار ۱۴۰۳',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 21,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddClassBottomSheet(),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'افزودن کلاس',
                          style: TextStyle(fontFamily: "Bnazanin", fontSize: 22),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(31, 48, 110, 1),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      Course course = courses[index];
                      return Card(
                        elevation: 10,
                        color: index % 3 == 0
                            ? const Color.fromRGBO(255, 69, 69, 100)
                            : (index % 3 == 1 ? const Color.fromRGBO(193, 129, 255, 100) : const Color.fromRGBO(72, 192, 141, 100)),
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '  ${course.name}',
                                    style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: "Bnazanin"),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const Icon(Icons.school, color: Colors.white),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'استاد: ${course.teacherName}',
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Divider(color: Colors.white),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    ' تعداد واحد: ${course.unit}',
                                    style: const TextStyle(color: Colors.white, fontFamily: "Bnazanin", fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const Icon(
                                    Icons.onetwothree_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    '  تکالیف باقی‌مانده: ${course.availableAssignmentsCount}',
                                    style: const TextStyle(color: Colors.white, fontFamily: "Bnazanin", fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const Icon(Icons.assignment, color: Colors.white),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    '  دانشجوی ممتاز: ${course.topStudentName}',
                                    style: const TextStyle(color: Colors.white, fontFamily: "Bnazanin", fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const Icon(Icons.star, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
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
}
