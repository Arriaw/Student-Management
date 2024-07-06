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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Align(
              alignment: Alignment.centerRight,
              child: Text('کلاس ها',
                  style: TextStyle(fontSize: 40,
                  fontFamily: 'Lato'),
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
                'ترم بهار ۱۴۰۳',
                style: TextStyle(color: Colors.black54,
                    fontSize: 17),
              ),
            ),
          ),
        ],
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
        onTap: _onBottomNavTapped,
      ),
    );
  }
}