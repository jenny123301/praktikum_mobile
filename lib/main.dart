import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieMax',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Definisikan rute di sini
      routes: {
        '/login': (context) => LoginScreen(), // Rute ke halaman login
        '/register': (context) => RegisterScreen(), // Jika ada halaman register
      },
      home: LoginScreen(), // Tampilan awal
    );
  }
}
