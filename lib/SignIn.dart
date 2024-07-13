import "dart:async";
import "dart:io";
import "package:arka_project/Homepage.dart";
import "package:arka_project/SignUp.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:url_launcher/url_launcher.dart";

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  bool _obscurePassword = true;
  bool UserIdChecker = false;
  bool PasswordChecker = false;
  bool chekcerRun = false;
  String res = '';
  String response = '';
  String host = '192.168.100.15';
  int port = 8080;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _launchInWebView(Uri url) async{
    if(!await launchUrl(url , mode: LaunchMode.inAppWebView)){
      throw Exception('Could not launch $url');
    }
  }


  Future<String> login() async {
    final completer  = Completer<String>();
    print("i'm hewre");
    print(_usernameController.text + " " + _passwordController.text);

    await Socket.connect('192.168.100.15',8080).then((serverSocket) {
      serverSocket.write(
          "LoginChecker~${_usernameController.text}~${_passwordController
              .text}\u0000");
      serverSocket.flush();
      serverSocket.listen((socketResponse) {
        setState(() {
          response = String.fromCharCodes(socketResponse);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;

    chekcerRun = true;
    if (response == "401") {
      UserIdChecker = true;
      PasswordChecker = false;
    } else if (response == "404") {
      UserIdChecker = false;
      PasswordChecker = false;
    } else if (response == "200") {
      UserIdChecker = true;
      PasswordChecker = true;
    }

    return response;
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String sidG = '';

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200, // Adjust height as needed
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromRGBO(31, 48, 110, 1), // Start color
                        Color(0xFF623AA2), // End color
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
              height: 150, // Adjust height as needed
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(31, 48, 110, 1), // Start color
                        Color(0xFF623AA2), // End color
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned(
              left: 37,
              top: 130,
              width: 340,
              height: 119,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'به سامانه مدیریت دانشجویی خوش آمدید!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bnazanin',
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),

            Positioned(
                top: 670,
                left: screenWidth *0.3,
                child: TextButton(
                  onPressed: () => setState(() {
                    _launchInWebView(Uri.parse("https://lms2.sbu.ac.ir"));
                  }),
                  child: const Text("ورود به سامانه یادگیری مجازی", style: TextStyle(color: Colors.blueAccent , fontSize: 13), ),
                )),

            Positioned(
              top: 710,
              left: (screenWidth *0.45) ,

              child: Image.asset(
                'Backend/Images/sbu.png',
                width: 40,
                height: 40,
              ),
            ),

            Positioned(
              left: 74,
              top: 246,
              width: 250,
              height: 30,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'وارد حساب کاربری خود شوید',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),

            Positioned(
              left: 155,
              top: 488,
              width: 209,
              height: 24,
              child: Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Lato',
                      color: Colors.black, // Default text color
                    ),
                    children: [
                      const TextSpan(text: 'حساب کاربری ندارید؟ '),
                      TextSpan(
                        text: 'بسازید',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 201,
              top: 627,
              width: 88,
              height: 34,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'ورود',
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
              top: 313,
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
                      ),
                    ]),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
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
              top: 404,
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
                    ]),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Color(0xFFC8C8C8),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF9A9A9A),
                      ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9A9A9A),
                      ),
                      onPressed: () {
                        // Toggle the state of obscurePassword
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 289,
              top: 627,
              width: 56,
              height: 34,
              child: ElevatedButton(
                onPressed: () async {
                  if (_usernameController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    showToast("پرکردن تمام فیلد ها الزامی است !");
                  } else {
                    res = await login();
                    if (res == "200") {
                      print('this res is ' + res);
                      res = '0';
                      sidG = _usernameController.text;

                      Navigator.push(context,
                        MaterialPageRoute(builder:
                            (context) =>
                            MyApp(sidM: sidG,
                              // sid: sidG,
                            )
                        ),
                      );
                    }else if (res == "401"){
                      showToast('خطا در ورود: رمز وارد شده درست نمی باشد!');
                    }else if(res == "404"){
                      showToast('خطا در ورود: شماره دانشجویی وارد شده \nدر سیستم ثبت نشده است. ثبت نام کنید');
                    }
                  }
                },

                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                 child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromRGBO(31, 48, 110, 1), Color(0xFF623AA2)],
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

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

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

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

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

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
