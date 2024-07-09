import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'سرویس',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: 'نمرات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'کلاس‌ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'کارتابل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'پروفایل',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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
