import "package:flutter/material.dart";


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
                        Color(0xFFF97794), // Start color
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF97794), // Start color
                        Color(0xFF623AA2), // End color
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 94,
              top: 144 ,
              width: 203,
              height: 83,
              child: Container(
                alignment: Alignment.center,

                child: Text(
                  'سلام',
                  style: TextStyle(fontSize: 64,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),

            Positioned(
              left: 94,
              top: 246 ,
              width: 203,
              height: 30,
              child: Container(
                alignment: Alignment.center,

                child: Text(
                  'وارد حساب کاربری خود شوید',
                  style: TextStyle(fontSize: 18,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),


            Positioned(
              left: 91,
              top: 750,
              width: 209,
              height: 24,
              child: Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Lato',
                      color: Colors.black, // Default text color
                    ),
                    children: [
                      TextSpan(text: 'حساب کاربری ندارید؟ '),
                      TextSpan(
                        text: 'بسازید',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 150,
              top: 488,
              width: 200,
              height: 24,
              child: Container(
                alignment: Alignment.center,

                child: Text(
                  'رمز عبور خود را فراموش کرده ام',
                  style: TextStyle(fontSize: 15,
                    fontFamily: 'Lato',
                    color: Color(0xFFBEBEBE),
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

                child: Text(
                  'ورود',
                  style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),





            ///USERNAME

            Positioned(
              left: 45,
              top: 313,
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
              top: 404,
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

