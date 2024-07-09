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
      routes: {
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  int _pageIndex = 4;

  final List<Widget> _widgetOptions = <Widget>[
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
        title: Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.person, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
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
              SummarySection(),
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

class SummarySection extends StatelessWidget {
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
              SummaryCard('بهترین نمره هفته', Icons.star),
              SummaryCard('2 تا امتحان داری', Icons.favorite_border),
              SummaryCard('3 تا تمرین داری', Icons.alarm),
              SummaryCard('3 تا ددلاین بریده', Icons.notifications),
              SummaryCard('بدترین نمره هفته', Icons.sentiment_very_dissatisfied),
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
