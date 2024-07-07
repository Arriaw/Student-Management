import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Socket Connection Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              getUserInfo();
            },
            child: Text('Connect to Server'),
          ),
        ),
      ),
    );
  }
}

Future<void> getUserInfo() async {
  final String host = 'localhost';
  final int port = 3031;

  try {
    Socket socket = await Socket.connect('192.168.1.36', 8080);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // Send request
    socket.write('getUserInfo-username-password\u0000');
    socket.flush();

    // Listen for the response
    socket.listen((data) {
      final response = String.fromCharCodes(data);
      print('Response from server: $response');
    });

    // Handle socket errors
    socket.handleError((error) {
      print('Socket error: $error');
      socket.destroy();
    });

    // Close the socket
    socket.done.then((_) {
      print('Socket closed');
      socket.destroy();
    });

  } catch (e) {
    print('Error: $e');
  }
}
