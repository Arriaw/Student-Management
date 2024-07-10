import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'SignIn.dart';
import 'SignUp.dart';

class UserProfile extends StatefulWidget {
  String nameS;
  String role;
  String sid;
  String currentTerm;
  String vahed;
  String average;
  String ImagePath;

  UserProfile({
    required this.nameS,
    required this.role,
    required this.sid,
    required this.currentTerm,
    required this.vahed,
    required this.average,
    required this.ImagePath,
  });

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pink",
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFFFF8593)), // Use full hex color
      ),
      home: PinkPage(userProfile1: widget),
    );
  }
}

class PinkPage extends StatefulWidget {
  final UserProfile userProfile1;


  const PinkPage({required this.userProfile1});

  @override
  _PinkPageState createState() => _PinkPageState();
}

class _PinkPageState extends State<PinkPage> {




  String imgpath = "";
  TextEditingController oldPassword  = new TextEditingController();
  TextEditingController newPassword  = new TextEditingController();


  TextEditingController newValue  = new TextEditingController();



  bool passwordchecking = false;

  String host = "192.168.1.36";
  int port = 8080;

  String Specailname = '';
  late Future<void> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = getUserInfo();
  }




  String resRemoving =  '';
  Future<String> removeAccount() async {
    String response = '';

    final completer = Completer<String>();

    await Socket.connect(host, port).then((serverSocket) {
      serverSocket.write("removeAccount~${widget.userProfile1.sid}\u0000");
      serverSocket.flush();
      serverSocket.listen((socketListen) {
        setState(() {
          response = String.fromCharCodes(socketListen);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;


    return response;
  }

  Future<String> changePassword() async {
    String response = '';
    final completer = Completer<String>();



    await Socket.connect(host, port).then((serverSocket) {
      serverSocket.write(
          "changePassword~${widget.userProfile1.sid}~${oldPassword.text}~${newPassword.text}\u0000");
      serverSocket.flush();
      serverSocket.listen((socketResponse) {
        setState(() {
          response = String.fromCharCodes(socketResponse);
        });
        completer.complete(response);
      });
    });

    response = await completer.future;



    return response;

  }

  Future<String> changeFields(String filed) async {
    String response = '';
    final completer = Completer<String>();

    print("this fiels is : ${filed} and the newvalue : ${newValue.text}");


    await Socket.connect(host, 4050).then((serverSocket) {
      String mess = "changeFields~${filed}~${widget.userProfile1.sid}~${newValue.text}\u0000";
      // serverSocket.write(
      //     "changeFields-${filed}-${widget.userProfile1.sid}-${newValue.text}\u0000");
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



    return response;

  }

    Future<void> getUserInfo() async {
    String response = '';

    final completer = Completer<String>();

    print("Connecting to server...");

    try {
      final serverSocket = await Socket.connect(host, port);
      print("Connected to server");

      serverSocket.write("getUserInfo~${widget.userProfile1.sid}\u0000");
      await serverSocket.flush();

      serverSocket.listen((socketResponse) {
        print("Data received from server");
        // response = String.fromCharCodes(socketResponse);
        // response = String.fromCharCodes(socketResponse);

        // response = Utf8Decoder().convert(socketResponse);
        response = utf8.decode(socketResponse.sublist(2));

        completer.complete(response);

        serverSocket.destroy(); // Close the connection
      }, onError: (error) {
        print("Error: $error");
        completer.completeError(error);
      }, onDone: () {
        print("Connection closed");
      });

    } catch (e) {
      print("Exception: $e");
      completer.completeError(e);
    }

    response = await completer.future;



    List<String> parameters = response.split("~");

    print("the response is : ${response}");
    setState(() {
      widget.userProfile1.nameS = parameters[0];
      Specailname = parameters[0];
      widget.userProfile1.role = parameters[1];
      widget.userProfile1.currentTerm = parameters[3];
      widget.userProfile1.vahed = parameters[4];
      widget.userProfile1.average = parameters[5];
      widget.userProfile1.ImagePath = parameters[6];
      widget.userProfile1.ImagePath = 'Backend' + widget.userProfile1.ImagePath;
      imgpath = 'Backend' + parameters[6];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    print("the Image paths is : ${widget.userProfile1.ImagePath}");

    // String sid  = widget.userProfile1.sid;
    // List<String> dir = widget.userProfile1.ImagePath.split("/");
    // String typeFile = dir[dir.length -1].split(".")[1];
    //
    // String Imgpth = "Backend/Images/" + sid + "."  + typeFile;
    // print("the imgpth is : ${Imgpth}");









    return Scaffold(
      body: FutureBuilder<void>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Stack(
              children: [
                Container(
                  color: Color(0xFFFF8593), // Set the background color here
                ),
                Positioned(
                  top: screenHeight * 0.07,
                  left: (screenWidth - 130) / 2,
                  child: ClipOval(
                    child: Image.asset(

                      // 'assets/images.jpeg',
                    // 'Backend/Images/IconPerson.jpg',

                      imgpath,

                    //   'Backend/Images/202463603.jpg',
                      // "Backend/Images/202423104.jpg",
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.197,
                  left: screenWidth * 0.6,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/camera.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.25,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        // widget.userProfile1.nameS.substring(0, widget.userProfile1.nameS.length - 2),
                        widget.userProfile1.nameS,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.userProfile1.role,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.65,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F8FE),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.32,
                  left: screenWidth * 0.07,
                  right: screenWidth * 0.07,
                  child: Container(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.31,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomRow(label: 'شماره دانشجویی', value: widget.userProfile1.sid),
                          Divider(),
                          CustomRow(label: 'ترم جاری', value: widget.userProfile1.currentTerm),
                          Divider(),
                          CustomRow(label: 'تعداد واحد', value: widget.userProfile1.vahed),
                          Divider(),
                          CustomRow(label: 'معدل کل', value: widget.userProfile1.average),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.12,
                  left: screenWidth * 0.07,
                  right: screenWidth * 0.07,
                  child: Container(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.18,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomRow2(
                            label: 'ویرایش مشخصات',
                            icon: Icons.edit,
                            iconColor: Colors.purple,
                            onPressed: () {


                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('ویرایش مشخصات',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Bnazanin',
                                    ),),
                                  content: const Text(
                                    '',
                                  ),
                                  actions: <Widget>[

                                    CustomRow2(
                                      label: 'نام دانشجو',
                                      icon: Icons.edit,
                                      iconColor: Colors.purple,
                                      onPressed: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(


                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[

                                                    TextField(
                                                      obscureText: false,
                                                      textAlign: TextAlign.right,
                                                      controller: newValue,
                                                      decoration: InputDecoration(
                                                        labelText: 'مقدار جدید',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('تایید'),
                                                    onPressed: ()  async {
                                                      // String res = await changePassword();

                                                      String res = '';

                                                      res = await changeFields("studentName");

                                                      String messageString = '';
                                                      Color colorT = Colors.black;

                                                        messageString =
                                                        "نام با موفقیت تغییر کرد";
                                                        colorT = Colors.green;



                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(''),
                                                          content:  Text(
                                                            messageString,
                                                            style: TextStyle(
                                                              color: colorT,
                                                            ),
                                                          ),
                                                          actions: <Widget>[

                                                          ],
                                                        ),
                                                      );

                                                      // Wait for a delay
                                                      await Future.delayed(Duration(seconds: 2));

                                                      // Close the dialog
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));

                                                      // Navigator.of(context).pop();
                                                      // Navigator.of(context).pop();
                                                    },
                                                  ),

                                                  TextButton(
                                                    child: Text('لغو'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    Divider(),
                                    CustomRow2(
                                      label: 'شماره دانشجویی',
                                      icon: Icons.edit,
                                      iconColor: Colors.purple,
                                      onPressed: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(


                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[

                                                    TextField(
                                                      obscureText: false,
                                                      textAlign: TextAlign.right,
                                                      controller: newValue,
                                                      decoration: InputDecoration(
                                                        labelText: 'مقدار جدید',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('تایید'),
                                                    onPressed: ()  async {
                                                      // String res = await changePassword();

                                                      String res = '';

                                                      res = await changeFields("SID");

                                                      String messageString = '';
                                                      Color colorT = Colors.black;

                                                        messageString =
                                                        "نام با موفقیت تغییر کرد";
                                                        colorT = Colors.green;



                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(''),
                                                          content:  Text(
                                                            messageString,
                                                            style: TextStyle(
                                                              color: colorT,
                                                            ),
                                                          ),
                                                          actions: <Widget>[

                                                          ],
                                                        ),
                                                      );

                                                      // Wait for a delay
                                                      await Future.delayed(Duration(seconds: 2));

                                                      // Close the dialog
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));

                                                      // Navigator.of(context).pop();
                                                      // Navigator.of(context).pop();
                                                    },
                                                  ),

                                                  TextButton(
                                                    child: Text('لغو'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    Divider(),

                                    CustomRow2(
                                      label: 'ترم جاری',
                                      icon: Icons.edit,
                                      iconColor: Colors.purple,
                                      onPressed: () {

                                        _showAlertDialog(context);
                                        },
                                    ),
                                    Divider(),

                                    CustomRow2(
                                      label: 'تعداد واحد',
                                      icon: Icons.edit,
                                      iconColor: Colors.purple,
                                      onPressed: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(


                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[

                                                    TextField(
                                                      obscureText: false,
                                                      textAlign: TextAlign.right,
                                                      controller: newValue,
                                                      decoration: InputDecoration(
                                                        labelText: 'مقدار جدید',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('تایید'),
                                                    onPressed: ()  async {
                                                      // String res = await changePassword();

                                                      String res = '';

                                                      res = await changeFields("numberOfUnits");

                                                      String messageString = '';
                                                      Color colorT = Colors.black;

                                                        messageString =
                                                        "نام با موفقیت تغییر کرد";
                                                        colorT = Colors.green;


                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(''),
                                                          content:  Text(
                                                            messageString,
                                                            style: TextStyle(
                                                              color: colorT,
                                                            ),
                                                          ),
                                                          actions: <Widget>[

                                                          ],
                                                        ),
                                                      );

                                                      // Wait for a delay
                                                      await Future.delayed(Duration(seconds: 2));

                                                      // Close the dialog
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));

                                                      // Navigator.of(context).pop();
                                                      // Navigator.of(context).pop();
                                                    },
                                                  ),

                                                  TextButton(
                                                    child: Text('لغو'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });

                                      },
                                    ),
                                    Divider(),

                                    CustomRow2(
                                      label: 'معدل کل',
                                      icon: Icons.edit,
                                      iconColor: Colors.purple,
                                      onPressed: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(


                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[

                                                    TextField(
                                                      obscureText: false,
                                                      textAlign: TextAlign.right,
                                                      controller: newValue,
                                                      decoration: InputDecoration(
                                                        labelText: 'مقدار جدید',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('تایید'),
                                                    onPressed: ()  async {
                                                      // String res = await changePassword();

                                                      String res = '';

                                                      res = await changeFields("averageScore");

                                                      String messageString = '';
                                                      Color colorT = Colors.black;
                                                      if(res == 200) {
                                                        messageString =
                                                        "نام با موفقیت تغییر کرد";
                                                        colorT = Colors.green;
                                                      }else {
                                                        messageString =
                                                        "!مشکلی پیش آمده است";
                                                        colorT = Colors.redAccent;
                                                      }


                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(''),
                                                          content:  Text(
                                                            messageString,
                                                            style: TextStyle(
                                                              color: colorT,
                                                            ),
                                                          ),
                                                          actions: <Widget>[

                                                          ],
                                                        ),
                                                      );

                                                      // Wait for a delay
                                                      await Future.delayed(Duration(seconds: 2));

                                                      // Close the dialog
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));

                                                      // Navigator.of(context).pop();
                                                      // Navigator.of(context).pop();
                                                    },
                                                  ),

                                                  TextButton(
                                                    child: Text('لغو'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),

                                  ],

                                ),
                              ).then((returnVal) {
                                if (returnVal != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('You clicked: $returnVal'),
                                      action: SnackBarAction(label: 'OK', onPressed: () {}),
                                    ),
                                  );
                                }
                              });

                              print('edit button pressed ');
                            },
                          ),
                          Divider(),
                          CustomRow2(
                            label: 'تغییر رمز عبور',
                            icon: Icons.lock,
                            iconColor: Colors.pink,
                            onPressed: ()  {
                              // print("the user info is : " + userInfo);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(

                                    title: Text(
                                      'تغییر رمز عبور',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'Bnazanin',
                                        fontSize: 20,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        TextField(
                                          obscureText: true,
                                          textAlign: TextAlign.right,
                                          controller: oldPassword,
                                          decoration: InputDecoration(
                                            labelText: 'رمز قبلی',
                                            alignLabelWithHint: true,
                                          ),
                                        ),
                                        TextField(
                                          obscureText: true,
                                          textAlign: TextAlign.right,
                                          controller: newPassword,
                                          decoration: InputDecoration(
                                            labelText: 'رمز جدید',
                                            alignLabelWithHint: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('تایید'),
                                        onPressed: () async {
                                          String res = await changePassword();
                                           String messageString = '';
                                           Color colorT = Colors.black;
                                          if(res == "200"){
                                            messageString = "رمز با موفقیت تغییر کرد";
                                            colorT = Colors.green;
                                          }
                                          if(res == "402"){
                                            messageString= "!پسورد وارد شده ضعیف است";
                                            colorT = Colors.red;
                                          }
                                          if(res == "401"){
                                            messageString = "! رمز نادرست می باشد";
                                            colorT = Colors.red;
                                          }



                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text(''),
                                              content:  Text(
                                                messageString,
                                                style: TextStyle(
                                                  color: colorT,
                                                ),
                                              ),
                                              actions: <Widget>[


                                              ],
                                            ),
                                          ).then((returnVal) {
                                            if (returnVal != null) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('You clicked: $returnVal'),
                                                  action: SnackBarAction(label: 'OK', onPressed: () {}),
                                                ),
                                              );
                                            }
                                          });

                                          // Wait for a delay
                                          await Future.delayed(Duration(seconds: 2));

                                          // Close the dialog
                                          Navigator.of(context).pop();
                                          if(res == "200")
                                            Navigator.of(context).pop();
                                        },
                                      ),

                                      TextButton(
                                        child: Text('لغو'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                              });
                            }


                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.02 * screenHeight,
                  right: screenWidth * 0.066,
                  left: screenWidth * 0.066,
                  child: ElevatedButton(
                    onPressed: () async {

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('حذف حساب کاربری',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontFamily: 'Bnazanin',
                                color: Colors.redAccent
                            ),),
                          content: const Text(
                            'آیا از حذف حساب کابری خود اطمینان دارید ؟‌',
                            style: TextStyle(
                              fontFamily: "Bnazanin",
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                String res = await removeAccount();
                                print("the res in remove account is : ${res}");

                                if(res == "200"){
                                  print("اکانت با موفقیت حذف شد");
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(''),
                                      content:  Text(
                                        "اکانت با موفقیت حذف شد",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      actions: <Widget>[


                                      ],
                                    ),
                                  ).then((returnVal) {

                                  });

                                  // Wait for a delay
                                  await Future.delayed(Duration(seconds: 2));

                                  // Close the dialog
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));


                                } else if (res == '401'){
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(''),
                                      content:  Text(
                                        "مشکلی پیش آمده! \n اکانت با موفقیت حذف نشد",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      actions: <Widget>[


                                      ],
                                    ),
                                  ).then((returnVal) {

                                  });
                                }

                            },
                              child: const Text('تایید'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'لغو'),
                              child: const Text('لغو'),
                            ),
                          ],
                        ),
                      ).then((returnVal) {

                      });
                      print("the delete button pressed");
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFFFF4545),
                      padding: EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      "حذف حساب کاربری",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}



void showAlertDialog2(BuildContext context){
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('ویرایش مشخصات',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'Bnazanin',
      ),),
      content: const Text(
        '',
      ),
      actions: <Widget>[

          CustomRow2(
            label: 'نام دانشجو',
            icon: Icons.edit,
            iconColor: Colors.purple,
            onPressed: () {

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(


                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[

                          TextField(
                            obscureText: true,
                            textAlign: TextAlign.right,
                            // controller: newPassword,
                            decoration: InputDecoration(
                              labelText: 'مقدار جدید',
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('تایید'),
                          onPressed: () async {
                            // String res = await changePassword();
                            String res = '';
                            String messageString = '';
                            Color colorT = Colors.black;
                            if(res == "200"){
                              messageString = "رمز با موفقیت تغییر کرد";
                              colorT = Colors.green;
                            }
                            if(res == "402"){
                              messageString= "! مشکلی پیش آمده است";
                              colorT = Colors.red;
                            }




                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(''),
                                content:  Text(
                                  messageString,
                                  style: TextStyle(
                                    color: colorT,
                                  ),
                                ),
                                actions: <Widget>[


                                ],
                              ),
                            ).then((returnVal) {
                              if (returnVal != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('You clicked: $returnVal'),
                                    action: SnackBarAction(label: 'OK', onPressed: () {}),
                                  ),
                                );
                              }
                            });

                            // Wait for a delay
                            await Future.delayed(Duration(seconds: 2));

                            // Close the dialog
                            Navigator.of(context).pop();
                            if(res == "200")
                              Navigator.of(context).pop();
                          },
                        ),

                        TextButton(
                          child: Text('لغو'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          Divider(),
          CustomRow2(
            label: 'شماره دانشجویی',
            icon: Icons.edit,
            iconColor: Colors.purple,
            onPressed: () {

              print('edit button pressed ');
            },
          ),
        Divider(),

        CustomRow2(
          label: 'ترم جاری',
          icon: Icons.edit,
          iconColor: Colors.purple,
          onPressed: () {

            print('edit button pressed ');
          },
        ),
        Divider(),

        CustomRow2(
          label: 'تعداد واحد',
          icon: Icons.edit,
          iconColor: Colors.purple,
          onPressed: () {

            print('edit button pressed ');
          },
        ),
        Divider(),

        CustomRow2(
          label: 'معدل کل',
          icon: Icons.edit,
          iconColor: Colors.purple,
          onPressed: () {

            print('edit button pressed ');
          },
        ),

        ],

    ),
  ).then((returnVal) {
    if (returnVal != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You clicked: $returnVal'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    }
  });
}

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('ویرایش مشخصات کاربری',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Bnazanin',
                fontSize: 26,
                color: Colors.redAccent)),
        content: const Text(
            'جهت ویرایش اطلاعات کاربری خود به واحد راهبری دانشگاه مراجعه نمایید.',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Bnazanin',
              fontSize: 20,
            )),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text('فهمیدم'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}



void showChangePasswordDialog(BuildContext context, TextEditingController oldPassword, TextEditingController newPassword) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        title: Text('تغییر رمز عبور',
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'Bnazanin',
          fontSize: 20,

        ),),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              obscureText: true,
              textAlign: TextAlign.right,
              controller: oldPassword,
              decoration: InputDecoration(
                labelText: 'رمز قبلی',
                alignLabelWithHint: true,
              ),
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.right,
              controller: newPassword,
              decoration: InputDecoration(
                labelText: 'رمز جدید',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('تایید'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('لغو'),
            onPressed: () {
              // Handle submission logic here
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class CustomRow2 extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  CustomRow2({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: iconColor,
            padding: EdgeInsets.all(8.0),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  CustomRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
