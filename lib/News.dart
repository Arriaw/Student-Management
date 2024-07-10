import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'Classes.dart';
import 'TodoPage.dart';
import 'Assignments.dart';
import 'Homepage.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class JalaliDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Jalali jalaliDate = Jalali.now();

    // final String formattedDate = '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(format1(jalaliDate),
        style: const TextStyle(fontSize: 20 , fontFamily: "Bnazanin"),
      ),
    );
  }

  String format1(Date d) {
    final f = d.formatter;
    return '-------------- (${f.wN} ${f.d} ${f.mN}) امروز ' + '--------------';
  }

  String format2(Date d) {
    final f = d.formatter;
    return '${f.y} ${f.d} ${f.mN}';
  }
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex;
  int _pageIndex = 1;
  final ScrollController _scrollController = ScrollController();

  static final List<Widget> _widgetOptions = <Widget>[
    AssignmentsPage(),
    NewsPage(),
    ClassesPage(),
    TodoListPage(),
    Homepage(sid: '',)
  ];

  final List<Widget> _tabs = [
    NewsContent('تمدید ها'),
    NewsContent('تولد های امروز'),
    NewsContent('یاد آوری ها'),
    NewsContent('رویداد ها'),
    NewsContent('اخبار'),
  ];

  final List<String> _tabTitles = [
    ('تمدید ها'),
    ('تولد های امروز'),
    ('یاد آوری ها'),
    ('رویداد ها'),
    ('اخبار'),
  ];

  _NewsPageState() : _currentIndex = 4; // Start with the last tab
  @override
  void initState() {
    super.initState();
    // Ensure the scroll starts at the rightmost position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
        title:
            const Align(
                alignment: Alignment.centerRight,
                child: Text('خبر ها',
                  style: TextStyle(fontFamily: 'Bnazanin',
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
                )
            ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),

              child: const Text(
                'ترم بهار ۱۴۰۳',
                style: TextStyle(color: Colors.black54,
                fontSize: 22),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Align(
                alignment: Alignment.centerRight,
                child : Row(
                  children: List.generate(_tabTitles.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton(
                        onPressed: () => _onTabTapped(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentIndex == index ? const Color.fromRGBO(31, 48, 110, 1) : Colors.white
                        ),
                        child: Text(_tabTitles[index],
                          style: TextStyle(color: _currentIndex != index ? const Color.fromRGBO(31, 48, 110, 1) : Colors.white,
                            fontFamily: 'Bnazanin',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                            ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Center(
            child: JalaliDateWidget(),
          ),
          Expanded(
            child: _tabs[_currentIndex],
          ),
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

class NewsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: 'تمدید ها'),
              Tab(text: 'تولد های امروز'),
              Tab(text: 'یاد آوری ها'),
              Tab(text: 'رویداد ها'),
              Tab(text: 'اخبار'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NewsContent('اخبار'),
            NewsContent('رویداد ها'),
            NewsContent('تولد های امروز'),
            NewsContent('یاد آوری ها'),
            NewsContent('تمدید ها'),
          ],
        ),
      ),
    );
  }
}

class NewsContent extends StatelessWidget {
  final String tab;

  NewsContent(this.tab);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(' $tab'),
    );
  }
}
