import 'dart:async';
import 'dart:convert';
import 'dart:io';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SignIn.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpstate createState() => _SignUpstate();
}

class _SignUpstate extends State<SignUp> {
  String host = "192.168.100.15";
  int port = 4050;

  TextEditingController name = new TextEditingController();
  TextEditingController ID = new TextEditingController();
  String? role;

  String response = '';
  String sidr = "";
  bool flag = false;
  bool CheckRun = false;

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<String> signupm() async {
    final completer = Completer<String>();

    await Socket.connect(host, 4050).then((serverSocket) {
      String mess = "SignUp~${name.text}~${ID.text}~${role} \u0000";
      List<int> encoded = utf8.encode(mess);
      serverSocket.add(encoded);
      serverSocket.flush();
      serverSocket.listen((socketResponse) {
        setState(() {
          response = String.fromCharCodes(socketResponse);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;
    print('the response is : ${response}');
    sidr = response;
    CheckRun = true;

    return response;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromRGBO(31, 48, 110, 1),
                        Color(0xFFB210FF),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 150,
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(31, 48, 110, 1),
                        Color(0xFFB210FF),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              top: 166,
              width: 300,
              height: 43,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'ساخت حساب کاربری',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
            Positioned(
              left: 120,
              top: 627,
              width: 188,
              height: 34,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'ساخت حساب',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 433,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'نقش',
                    hintStyle: TextStyle(
                      color: Color(0xFFC8C8C8),
                    ),
                    prefixIcon: Icon(
                      Icons.backpack,
                      color: Color(0xFF9A9A9A),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'student',
                      child: Text('Student'),
                    ),
                    DropdownMenuItem(
                      value: 'teacher',
                      child: Text('Teacher'),
                    ),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      role = value;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 249,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(40), boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 3),
                  )
                ]),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'نام و نام خانوادگی',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
                        // fontFamily: "Bnazanin",
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xFF9A9A9A),
                      )),
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 341,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(40), boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 3),
                  )
                ]),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  controller: ID,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'کد ملی (as your password)',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xFF9A9A9A),
                      )),
                ),
              ),
            ),
            Positioned(
                top: 670,
                left: screenWidth * 0.3,
                child: TextButton(
                  onPressed: () => setState(() {
                    _launchInWebView(Uri.parse("https://lms2.sbu.ac.ir"));
                  }),
                  child: const Text(
                    "ورود به سامانه یادگیری مجازی",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 11),
                  ),
                )),
            Positioned(
              top: 710,
              left: (screenWidth * 0.45),
              child: Image.asset(
                'Backend/Images/sbu.png',
                width: 40,
                height: 40,
              ),
            ),
            Positioned(
                left: 289,
                top: 627,
                width: 56,
                height: 34,
                child: ElevatedButton(
                  onPressed: () async {
                    if (name.text.isEmpty || ID.text.isEmpty || role == '') {
                      showToast("پرکردن تمام فیلد ها الزامی است !");
                    } else {
                      print("SignUp-${name.text}-${ID.text}-${role}");
                      response = await signupm();
                      if (response == "401") {
                        print("the id ${ID.text} is already taken !");
                        showToast("خطا در ثبت: اسم یا کد ملی تکراری است");
                      } else if (response == '') {
                        await Future.delayed(const Duration(seconds: 2));
                        if (response == '') {
                          showToast("خطا در برقراری ارتباط با سرور !");
                          print("end of time");
                        } else {
                          print("the user ${name.text} created successfully with SID : ${response}");
                          flag = true;
                          showToast("${response} اضافه شد . sid:${name}");
                          await Future.delayed(const Duration(seconds: 2));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                        }
                      } else {
                        print("the user ${name.text} created successfully with SID : ${response}");
                        flag = true;
                        showToast("${name.text} اضافه شد\n . sid:${sidr}");
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF97794), Color(0xFF623AA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 200,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
            const Positioned(
              left: 120,
              top: 750,
              child: FaIcon(
                FontAwesomeIcons.facebook,
                size: 35.0,
                color: Colors.blue,
              ),
            ),
            const Positioned(
              left: 177,
              top: 750,
              child: FaIcon(
                FontAwesomeIcons.twitter,
                size: 35.0,
                color: Colors.blue,
              ),
            ),
            const Positioned(
              left: 232,
              top: 750,
              child: FaIcon(
                FontAwesomeIcons.google,
                size: 35.0,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 60);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 120);
    var secondEndPoint = Offset(size.width, size.height - 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height - 100);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    var secondControlPoint = Offset(3 * size.width / 4, size.height + 40);
    var secondEndPoint = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 60);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 120);
    var secondEndPoint = Offset(size.width, size.height - 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
