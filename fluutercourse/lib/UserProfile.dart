import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GradientStackPage(),
    );
  }
}

class GradientStackPage extends StatefulWidget {
  @override
  _GradientStackPageState createState() => _GradientStackPageState();
}

class _GradientStackPageState extends State<GradientStackPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF16A9FC), Color(0xFF69DBFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          IndexedStack(
            index: _selectedIndex,
            children: [
              AboutPage(),
              WorkPage(),
              ActivityPage(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'ABOUT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'WORK',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'ACTIVITY',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ABOUT PAGE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WorkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          top: 50,
          width: 350,
          height: 250,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 3),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 191,
          top: 61,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 154,
              height: 229,
              child: Image.asset(
                'assets/images.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 71,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'علی',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                    color: Color(0XFF79838B),
                  ),
                ),
                Text(
                  'محمدی',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                    color: Color(0XFF79838B),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 73,
          top: 155,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              ":" + "مقطع",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Color(0XFF79838B),
              ),
            ),
          ),
        ),
        Positioned(
          left: -10,
          top: 155,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "کارشناسی",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Colors.black,
              ),
            ),
          ),
        ),
        //شماره دانشجویی
        Positioned(
          left: 56,
          top: 175,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              ":" + "شماره دانشجو",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Color(0XFF79838B),
              ),
            ),
          ),
        ),
        Positioned(
          left: -16,
          top: 175,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "202421071",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Colors.black,
              ),
            ),
          ),
        ),
        // //شماره دانشجویی
        Positioned(
          left: 56,
          top: 195,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              ":" + "رشته تحصیلی",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Color(0XFF79838B),
              ),
            ),
          ),
        ),
        Positioned(
          left: -24,
          top: 195,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "مهندسی کامپیوتر",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Colors.black,
              ),
            ),
          ),
        ),
        // //دوره
        Positioned(
          left: 74,
          top: 215,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              ":" + "دوره",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Color(0XFF79838B),
              ),
            ),
          ),
        ),
        Positioned(
          left: -2,
          top: 215,
          width: 200,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "روزانه",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Colors.black,
              ),
            ),
          ),
        ),
        Positioned(
          left: 40,
          top: 384.97,
          child: Column(
            children: [
              Row(
                children: [
                  RectangleWithText(number: '23', text: 'تعداد واحد\n اخذ شده'), // Custom number and text
                  SizedBox(width: 10),
                  RectangleWithText(number: '13.5', text: 'معدل کل'), // Custom number and text
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  RectangleWithText(number: '3', text: 'تعداد ترم\n گذرانده'), // Custom number and text
                  SizedBox(width: 10),
                  RectangleWithText(number: '15', text: 'معدل ترم گذشته'), // Custom number and text
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ACTIVITY PAGE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class RectangleWithText extends StatelessWidget {
  final String number;
  final String text;

  RectangleWithText({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144.32,
      height: 177.31,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0XFF9FADB8),
            ),
          ),
        ],
      ),
    );
  }
}
