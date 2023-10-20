import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:frontend/qr_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool isLoginsuccessful = false;

String eventToken = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    await Hive.openBox('userData');
  } catch (e) {
    print('Failed to initialize Hive: $e');
  }
}

void printUserData() async {
  final userData = await Hive.openBox('userData');
  for (var i = 0; i < userData.length; i++) {
    final data = userData.getAt(i);
    print('Event Name: ${data['eventName']}');
    print('Event ID: ${data['eventID']}');
    print('User Name: ${data['name']}');
  }
}

void dataEntry(int eventId, List<String> names, String event) async {
  final userData = await Hive.openBox('userData');

  for (final name in names) {
    var data = {'eventName': event, 'eventID': eventId, 'name': name};
    await userData.add(data);
  }
  printUserData();
}

Future<void> getData(int token) async {
  final currentDate = DateTime.now();
  final date = DateFormat('yyyy-MM-dd').format(currentDate);
  final response = await http.get(
    Uri.parse(
        // 'https://solid-abnormally-iguana.ngrok-free.app/scanner_app/fetch_data/$token/$date'),
        'https://4a1b-2401-4900-57df-f79-15df-3c59-4f93-9004.ngrok-free.app/scanner_app/fetch_data/$token/$date'),
  );
  print(response.body);
  final jsonData = json.decode(response.body);
  print("Hello");
  final firstData = jsonData[0];
  final usersData = firstData['users'];
  List<String> userNames = [];
  usersData.values.forEach((user) {
    userNames.add(user[2]);
  });
  print(userNames);

  dataEntry(jsonData[0]['token'], userNames, jsonData[0]['name']);
}

Future<void> loginUser(String scanner, String password) async {
  final response = await http.post(Uri.parse(
          // 'https://solid-abnormally-iguana.ngrok-free.app/scanner_app/login/'),
          'https://4a1b-2401-4900-57df-f79-15df-3c59-4f93-9004.ngrok-free.app/scanner_app/login/'),
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
                    // getData(eventToken);
                    getData(3);
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
