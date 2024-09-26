import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Views/Home.dart';
import 'Signup.dart';
import 'auth_services.dart'; // Import AuthService

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final AuthService _authService = AuthService(); // Instance of AuthService

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      // Navigate to Home page if user is already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(title: 'Home Page'),
        ),
      );
    }
  }

  String? validatePhoneNumber(String value) {
    RegExp regex = RegExp(r'^\d{10}$');
    if (value.isEmpty) {
      return 'Please enter a valid Phone number';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid 10 digit phone number';
    }
    return null;
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    String phoneNumberWithoutPrefix = phoneController.text.replaceAll(RegExp(r'^\+91 \| '), '');
    String? validationMessage = validatePhoneNumber(phoneNumberWithoutPrefix);

    if (validationMessage != null) {
      showAlertDialog(validationMessage);
    } else {
      // Assuming the login is successful, set the login state
      await _authService.setLoggedIn(true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(title: 'Home Page'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 16.0),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/logoyashwi.png',
                      height: 100, // adjust the height as needed
                      width: 100,  // adjust the width as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'TuneWave',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Flanella",
                    ),
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefix: Text('+91 | ', style: TextStyle(color: Colors.white)),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Enter a valid Phone Number',
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      icon: Icon(Icons.phone, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _login, // Use the _login method
                    child: Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(title: 'Sign Up'),
                            ),
                          );
                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
