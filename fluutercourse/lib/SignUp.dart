import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFFEECE13), // Start color
                        Color(0xFFB210FF), // End color
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0 ,
              right: 0,
              top: 0,
              height: 150, // Adjust height as needed
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFEECE13), // Start color
                        Color(0xFFB210FF), // End color
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 50,
              top: 166 ,
              width: 300,
              height: 43,
              child: Container(
                alignment: Alignment.center,

                child: Text(
                  'ساخت حساب کاربری',
                  style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),

            // Positioned(
            //   left: 94,
            //   top: 246 ,
            //   width: 203,
            //   height: 30,
            //   child: Container(
            //     alignment: Alignment.center,
            //
            //     child: Text(
            //       'وارد حساب کاربری خود شوید',
            //       style: TextStyle(fontSize: 18,
            //         fontFamily: 'Lato',
            //       ),
            //     ),
            //   ),
            // ),


            // Positioned(
            //   left: 58,
            //   top: 700,
            //   width: 280,
            //   height: 60,
            //   child: Container(
            //     alignment: Alignment.center,
            //     child: RichText(
            //       textAlign: TextAlign.center,
            //       text: TextSpan(
            //         text: 'با استفاده از شبکه‌های اجتماعی' + ' ',
            //         // text: "create account\n",
            //         style: TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.bold,
            //           fontFamily: 'Lato',
            //           color: Colors.black,
            //         ),
            //         children: [
            //           TextSpan(
            //             text: 'حساب ایجاد کنید',
            //             style: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.bold,
            //               fontFamily: 'Lato',
            //               color: Colors.black,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            Positioned(
              left: 48,
              top: 700 ,
              width: 300,
              height: 43,
              child: Container(
                alignment: Alignment.center,

                child: Text(
                  'با استفاده از شبکه‌های اجتماعی حساب ایجاد کنید',
                  style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),


            // Positioned(
            //   left: 150,
            //   top: 488,
            //   width: 200,
            //   height: 24,
            //   child: Container(
            //     alignment: Alignment.center,
            //
            //     child: Text(
            //       'رمز عبور خود را فراموش کرده ام',
            //       style: TextStyle(fontSize: 15,
            //         fontFamily: 'Lato',
            //         color: Color(0xFFBEBEBE),
            //       ),
            //     ),
            //   ),
            // ),



            Positioned(
              left: 120,
              top: 627,
              width: 188,
              height: 34,
              child: Container(
                alignment: Alignment.center,

                child: Text(
                  'ساخت حساب',
                  style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),

            //Email


            Positioned(
              left: 45,
              top: 433,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
                      ),
                      prefixIcon: Icon(Icons.person, color: Color(0xFF9A9A9A),)
                  ),
                ),
              ),

            ),

            //Mobile


            Positioned(
              left: 45,
              top: 525,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Mobile',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
                      ),
                      prefixIcon: Icon(Icons.phone_android, color: Color(0xFF9A9A9A),)
                  ),
                ),
              ),

            ),





            ///USERNAME

            Positioned(
              left: 45,
              top: 249,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
                      ),
                      prefixIcon: Icon(Icons.person, color: Color(0xFF9A9A9A),)
                  ),
                ),
              ),

            ),

            Positioned(
              left: 45,
              top: 341,
              width: 300,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Color(0xFFC8C8C8),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF9A9A9A),)
                  ),
                ),
              ),
            ),

            Positioned(
              left: 289,
              top: 627,
              width: 56,
              height: 34,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: Offset(0, 3),
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF97794), // Start color
                      Color(0xFF623AA2), // End color
                    ],
                    stops: [0.0, 1.0], // Positions of the colors
                  ),

                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),

              ),
            ),

            Positioned(
              left: 120,
              top: 750,

              child: FaIcon(
                FontAwesomeIcons.facebook,
                size: 35.0,
                color: Colors.blue,
              ),
            ),
            Positioned(
              left: 177,
              top: 750,

              child: FaIcon(
                FontAwesomeIcons.twitter,
                size: 35.0,
                color: Colors.blue,
              ),
            ),
            Positioned(
              left: 232,
              top: 750,

              child: FaIcon(
                FontAwesomeIcons.google ,
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

