import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'News.dart';
import 'Classes.dart';
import 'TodoPage.dart';
import 'Homepage.dart';


class AssignmentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AssignmentsPage();
}

class _AssignmentsPage extends State<AssignmentsPage> {
  int _pageIndex = 0;

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
    final Jalali jalaliDate = Jalali.now();
    // final String formattedDate = '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';
    final f = jalaliDate.formatter;

    return Scaffold(
      appBar: AppBar(
        title:
        Align(
          alignment: Alignment.centerRight,
          child: Text('تمرین ها',
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
                '‏${f.d} ${f.mN} ${f.y}',
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