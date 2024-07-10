import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'News.dart';
import 'Classes.dart';
import 'TodoPage.dart';
import 'Assignments.dart';
import 'UserProfile.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  String sidM;
  MyApp({required this.sidM});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(sid: sidM,),
      routes: {
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class Homepage extends StatefulWidget {
  String sid;
  Homepage({
    required this.sid,
  });

  @override
  State<StatefulWidget> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  String sidR = '';
  int _pageIndex = 4;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    sidR = widget.sid;


    _widgetOptions = <Widget>[
      AssignmentsPage(),
      NewsPage(),
      ClassesPage(),
      TodoListPage(),
      Homepage(sid: sidR,)
    ];
  }
  void _onBottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => _widgetOptions[index])
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.person, color: Colors.blue),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder:
                      (context) =>
                      UserProfile(
                        nameS: "",
                        role: "",
                        sid: sidR,
                        currentTerm: "",
                        vahed: "",
                        average: "",
                        ImagePath: "",
                      )
                  ),
                );

              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SummarySection(sid: sidR,),
              SizedBox(height: 20),
              CurrentTasksSection(),
              SizedBox(height: 20),
              CompletedTasksSection(),
            ],
          ),
        ),
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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('پروفایل'),
      ),
      body: Center(
        child: Text('This is the profile page'),
      ),
    );
  }
}

class SummarySection extends StatefulWidget{
  String sid ;
  SummarySection({required this.sid});
  @override
  _SummarySectionstate createState() => _SummarySectionstate();
}

class _SummarySectionstate extends State<SummarySection> {
  String response = '';
  int port = 8080;
  String host = '192.168.1.36';


  String CountAllAssignments = '0';
  String BestScore = '';
  String WorthScore= '';
  List<Task> tasks = [];
  late Future<void> _future;


  Future<String> getCountAssignments() async {
    final completer  = Completer<String>();

    print("i'm hewre");

    await Socket.connect(host,port).then((serverSocket) {
      serverSocket.write("getAssignmentsCount~${widget.sid}\u0000");
      serverSocket.flush();
      serverSocket.listen((socketResponse) {
        setState(() {
          response = String.fromCharCodes(socketResponse);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;

    CountAllAssignments = response;

    print("the count is : ${CountAllAssignments}");

    return response;
  }

  Future<String> getBestScore() async {
    final completer  = Completer<String>();

    print("i'm hewre");

    await Socket.connect(host,port).then((serverSocket) {
      serverSocket.write("getBestScore~${widget.sid}\u0000");
      serverSocket.flush();
      serverSocket.listen((socketResponse) {
        setState(() {
          response = String.fromCharCodes(socketResponse);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;

    BestScore = response;

    print("the BestScore is : ${BestScore}");

    return response;
  }

  Future<String> getWorthScore() async {
    final completer  = Completer<String>();

    print("i'm hewre");

    await Socket.connect(host,port).then((serverSocket) {
      serverSocket.write("getWorthScore~${widget.sid}\u0000");
      serverSocket.flush();
      serverSocket.listen((socketResponse) {
        setState(() {
          response = String.fromCharCodes(socketResponse);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;

    WorthScore = response;

    print("the BestScore is : ${WorthScore}");

    return response;
  }


  Future<void> getTasks() async {
    String response = '';
    final completer = Completer<String>();
    print("Connecting to server as getTask ...");
    try {
      final socket = await Socket.connect(host, port);
      socket.write("getTasks~${widget.sid}\u0000");
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
      } else {
        setState(() {
          tasks = response.split('\n').where((task) => task.isNotEmpty).map((task) => Task.fromString(task)).toList();
        });
      }
    } catch (e) {
      print('Error processing response: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCountAssignments();
    getBestScore();
    getWorthScore();
    _future = getTasks();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'خلاصه',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right, // Align text to the right
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 10, // Space between items horizontally
            runSpacing: 10, // Space between lines
            alignment: WrapAlignment.start,
            children: [
              SummaryCard('بهترین نمره ات : ${BestScore}', Icons.star),
              SummaryCard('2 تا امتحان داری', Icons.favorite_border),
              SummaryCard('${CountAllAssignments}  تا تمرین داری', Icons.alarm),
              SummaryCard('3 تا ددلاین بریده', Icons.notifications),
              SummaryCard('بدترین نمره ات : ${WorthScore}', Icons.sentiment_very_dissatisfied),
            ],
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  SummaryCard(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Set a fixed width for the cards
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              SizedBox(height: 5),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentTasksSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Move text to the right
      children: [
        Text(
          'کارهای جاری',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right, // Align text to the right
        ),
        SizedBox(height: 10),
        for(Task ta : ){

        }
        TaskItem('آز ریز - تمرین 1'),
        TaskItem('تست - تمرین 1'),
      ],
    );
  }

}

class TaskItem extends StatelessWidget {
  final String title;

  TaskItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.close, color: Colors.red),
        trailing: Icon(Icons.check_circle, color: Colors.green),
        title: Text(title, textAlign: TextAlign.right),
      ),
    );
  }
}

class CompletedTasksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Move text to the right
      children: [
        Text(
          'تمرین‌های انجام شده',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right, // Align text to the right
        ),
        SizedBox(height: 10),
        TaskItem('تمرین 1 معماری'),
        TaskItem('AP - تمرین 2'),
      ],
    );
  }
}
