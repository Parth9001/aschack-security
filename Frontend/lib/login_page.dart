import 'dart:async';
import 'package:hive/hive.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:frontend/qr_scanner.dart';
import 'package:http/http.dart' as http;

bool isLoginsuccessful = false;

void dataEntry(Map<String, dynamic> data, String uID) async {
  final scannerData = Hive.box('scannerData');
  data.forEach((key, value) async {
    var qq = {"eventName": value[1], "eventID": value[0], "uID": uID};
    await scannerData.add(qq);
    print(value[0]);
  });
}

String eventToken = '';

Future<void> loginUser(String scanner, String password) async {
  final response = await http.post(
      Uri.parse('https://7dfc-103-21-126-76.ngrok-free.app/scanner_app/login/'),
      body: {
        'scanner': scanner,
        'password': password,
      });

  print("Reponse code is");
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    isLoginsuccessful = true;
    eventToken = response.body;
    print('Login successful');
  } else if (response.statusCode == 401) {
    isLoginsuccessful = false;
    print('Invalid Credentials');
  } else if (response.statusCode == 404) {
    isLoginsuccessful = false;
    print('User Not Found');
  } else {
    isLoginsuccessful = false;
    print('No response code');
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'ASC Hackathon',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: () async {
                  await loginUser(
                      usernameController.text, passwordController.text);
                  if (isLoginsuccessful) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRScanner()),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid username or password.'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
