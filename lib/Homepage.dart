import 'package:flutter/material.dart';
import 'News.dart';
import 'Classes.dart';
import 'TodoPage.dart';
import 'Assignments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  int _pageIndex = 4;

  static final List<Widget> _widgetOptions = <Widget>[
    AssignmentsPage(),
    NewsPage(),
    ClassesPage(),
    TodoListPage(),
    Homepage()
  ];

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
        title:
        const Align(
          alignment: Alignment.centerRight,
          child: Text('سرا',
            style: TextStyle(fontSize: 50,
                fontFamily: 'Bnazanin',
            fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: const Column(
        children: [

        ],
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