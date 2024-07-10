import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:file_picker/file_picker.dart';
import 'News.dart';
import 'Classes.dart';
import 'TodoPage.dart';
import 'Homepage.dart';

class Assignment {
  String name;
  String description;
  DateTime dueTime;
  bool isDone;
  double score;

  Assignment({required this.name, required this.description, required this.dueTime, required this.isDone, required this.score});

  factory Assignment.fromString(String taskString) {
    final parts = taskString.split(',');
    return Assignment(
      name: parts[0],
      description: parts[1],
      dueTime: DateTime.parse(parts[2]),
      isDone: parts[3] == 'true',
      score: double.parse(parts[4]),
    );
  }
}

class AssignmentsPage extends StatefulWidget {
  String sid;

  AssignmentsPage({required this.sid,});
  @override
  State<StatefulWidget> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  String sidR = '';
  int _pageIndex = 0;
  String host = "192.168.1.36";
  int port = 8080;
  late Future<void> _future;
  List<Assignment> assignments = [];
  late  List<Widget> _widgetOptions;



  void _onBottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _future = getAssignments();
    sidR = widget.sid;
    _widgetOptions = <Widget>[
      AssignmentsPage(sid: sidR,),
      NewsPage(sid: sidR,),
      ClassesPage(sid: sidR,),
      TodoListPage(sid: sidR,),
      Homepage(sid: sidR,),
    ];

  }

  Future<void> getAssignments() async {
    String allAssignmentsResponse = '';
    final allAssignmentsCompleter = Completer<String>();

    print("Connecting to server to get all assignments...");
    try {

      final socket = await Socket.connect(host, port);
      socket.write("getAllAssignments~${widget.sid}\u0000");
      await socket.flush();
      socket.listen((data) {
        allAssignmentsResponse = utf8.decode(data.sublist(2));
        allAssignmentsCompleter.complete(allAssignmentsResponse);
        socket.destroy();
      }, onError: (error) {
        print('Error: $error');
        allAssignmentsCompleter.completeError(error);
        socket.destroy();
      }, onDone: () {
        if (!allAssignmentsCompleter.isCompleted) {
          allAssignmentsCompleter.complete(allAssignmentsResponse);
        }
        socket.destroy();
      });
    } catch (e) {
      print('Error: $e');
      allAssignmentsCompleter.completeError(e);
    }

    try {
      allAssignmentsResponse = await allAssignmentsCompleter.future;

      print("All Assignments response: $allAssignmentsResponse");

      if (allAssignmentsResponse == "404") {
        print("No assignments found");
      } else {
        setState(() {
          assignments = allAssignmentsResponse
              .split('\n')
              .where((assignment) => assignment.isNotEmpty)
              .map((assignment) => Assignment.fromString(assignment))
              .toList();
        });
      }
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  Future<void> toggleAssignmentOnServer(Assignment assignment) async {
    String response = '';
    final completer = Completer<String>();

    try {
      final socket = await Socket.connect(host, port);
      print("connected to server as toggleAssignment");
      socket.write('toggleAssignment~${widget.sid}~${assignment.name}~${assignment.dueTime.toString()}~${assignment.isDone}\u0000');
      socket.flush();
      socket.listen((data) {
        response = utf8.decode(data);
        print("toggleAssignment response : " + response);
        completer.complete(response);
      });
      socket.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _toggleAssignment(Assignment assignment) {
    setState(() {
      assignment.isDone = !assignment.isDone;
    });
    toggleAssignmentOnServer(assignment);
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

  String _formatJalaliDateTime(DateTime dateTime) {
    final Jalali jalaliDate = Jalali.fromDateTime(dateTime);
    return '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}  -  ${dateTime.hour}:${dateTime.minute}';
  }

  String _formatJalaliDate(DateTime dateTime) {
    final Jalali jalaliDate = Jalali.fromDateTime(dateTime);
    return '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';
  }

  void _showAssignmentDialog(BuildContext context, Assignment assignment) {
    final TextEditingController deliveryNotesController = TextEditingController();
    String? uploadedFileName;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'جزئیات تمرین',
                    style: TextStyle(
                      fontFamily: "Bnazanin",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'عنوان: ',
                            style: TextStyle(fontFamily: "Bnazanin", fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: assignment.name,
                            style: const TextStyle(
                              fontFamily: "Bnazanin",
                              fontSize: 19,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'ددلاین: ',
                            style: TextStyle(fontFamily: "Bnazanin", fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: _formatJalaliDateTime(assignment.dueTime),
                            style: const TextStyle(
                              fontFamily: "Bnazanin",
                              fontSize: 19,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'مدت زمان باقی مانده: ',
                            style: TextStyle(fontFamily: "Bnazanin", fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: _calculateRemainingDays(assignment.dueTime),
                            style: const TextStyle(
                              fontFamily: "Bnazanin",
                              fontSize: 19,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'توضیحات:',
                      style: TextStyle(
                        fontFamily: "Bnazanin",
                        fontSize: 19,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 50),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        assignment.description,
                        style: const TextStyle(fontFamily: "Bnazanin", fontSize: 19, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'نمره: ',
                            style: TextStyle(
                              fontFamily: "Bnazanin",
                              fontSize: 19,
                            ),
                          ),
                          TextSpan(
                            text: assignment.score.toString(),
                            style: const TextStyle(
                              fontFamily: "Bnazanin",
                              fontSize: 19,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      controller: deliveryNotesController,
                      decoration: InputDecoration(
                        hintText: 'توضیحات تحویل',
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.upload),
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              setState(() {
                                uploadedFileName = result.files.single.name;
                              });
                            }
                          },
                        ),
                        const Text(
                          'بارگذاری تمرین',
                          style: TextStyle(fontFamily: "Bnazanin", fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (uploadedFileName != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'فایل آپلود شده: $uploadedFileName',
                        style: const TextStyle(
                          fontFamily: "Bnazanin",
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'ثبت',
                      style: TextStyle(fontFamily: "Bnazanin", fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() async {
                        assignment.isDone = true;
                        // Handle saving uploaded file information
                      });
                      Navigator.of(context).pop();
                    },
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
    final Jalali jalaliDate = Jalali.now();
    final f = jalaliDate.formatter;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'تمرین ها',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Bnazanin',
              fontWeight: FontWeight.bold,
            ),
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
                        style: const TextStyle(color: Colors.black54, fontSize: 22, fontFamily: 'Bnazanin'),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      Assignment assignment = assignments[index];
                      return Card(
                        color: assignment.isDone ? const Color.fromRGBO(245, 72, 127, 110) : const Color.fromRGBO(245, 72, 127, 15),
                        elevation: 10,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          title: Text(
                            assignment.name,
                            style: TextStyle(
                                fontFamily: 'Bnazanin',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: assignment.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                decorationColor: Colors.white),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          subtitle: Text(
                            '${_formatJalaliDate(assignment.dueTime)}',
                            style: const TextStyle(fontFamily: 'Bnazanin', fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                          trailing: assignment.isDone
                              ? const Icon(
                            Icons.check_circle_outlined,
                            color: Colors.white,
                          )
                              : const Icon(
                            Icons.circle_outlined,
                            color: Colors.white,
                          ),
                          onTap: () => _showAssignmentDialog(context, assignment),
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
