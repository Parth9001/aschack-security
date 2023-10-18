import 'package:frontend/login_page.dart';
// import 'package:frontend/qr_scanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      )),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}
