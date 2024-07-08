import 'package:arka_project/dartFiles/Course.dart';
import 'package:arka_project/dartFiles/Teacher.dart';
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

  static final List<Widget> _widgetOptions = <Widget>[
    AssignmentsPage(),
    NewsPage(),
    ClassesPage(),
    TodoListPage(),
    Homepage(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    });
  }

  void _showAddClassBottomSheet(BuildContext context) {
    TextEditingController classIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    courses.add(
                      Course(
                        id: classIdController.text,
                        name: 'برنامه نویسی',
                        teacher: Teacher("مهدیانی", "2"),
                        unit: 3,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'افزودن',
                  style: TextStyle(fontFamily: "Bnazanin", fontSize: 23),
                ),
              ),
            ],
          ),
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
            style: TextStyle(
              fontSize: 50,
              fontFamily: 'Bnazanin',
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                  onPressed: () => _showAddClassBottomSheet(context),
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
                          'استاد: ${course.teacher.teacherName}',
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
                            const Icon(Icons.onetwothree_outlined, color: Colors.white, size: 40,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(width: 4),
                            Text(
                              '  تکالیف باقی‌مانده: ${course.activeAssignments.length}',
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
