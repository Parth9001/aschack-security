import 'dart:async';

import 'package:path/path.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

import 'package:flutter/material.dart';
import 'package:frontend/qr_scanner.dart';
import 'package:http/http.dart' as http;

bool isLoginsuccessful = false;

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

// class LoginPage extends StatefulWidget {
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//         begin: Alignment.topRight,
//         end: Alignment.bottomLeft,
//         colors: [
//           Colors.blue,
//           Colors.red,
//         ],
//       )),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: _page(),
//       ),
//     );
//   }

//   Widget _page() {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _icon(),
//             const SizedBox(
//               height: 50,
//             ),
//             _inputField("Username", usernameController),
//             const SizedBox(
//               height: 50,
//             ),
//             _inputField('Password', passwordController, isPassword: true),
//             const SizedBox(
//               height: 50,
//             ),
//             const MyButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _icon() {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.white, width: 2),
//           shape: BoxShape.circle),
//       child: const Icon(Icons.person, color: Colors.white, size: 120),
//     );
//   }

//   Widget _inputField(String hintText, TextEditingController controller,
//       {isPassword = false}) {
//     var border = OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: const BorderSide(color: Colors.white));

//     return TextField(
//       style: const TextStyle(color: Colors.white),
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(color: Colors.white),
//         enabledBorder: border,
//         focusedBorder: border,
//       ),
//       obscureText: isPassword,
//     );
//   }

//   Widget _loginBtn() {
//     return ElevatedButton(
//         onTap: () async {
//           await loginUser(usernameController.text, passwordController.text);
//           debugPrint("Username: ${usernameController.text}");
//           debugPrint("Password: ${passwordController.text}");

//           if (isLoginsuccessful) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => QRScanner()),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Invalid username or password.'),
//               ),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           shape: const StadiumBorder(),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.blue,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: const SizedBox(
//           width: double.infinity,
//           child: Text(
//             "Sign in ",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 20),
//           ),
//         ));
//   }
// }

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

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
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
