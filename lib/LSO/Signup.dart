import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'OTP.dart';
import 'package:http/http.dart' as http;
import 'registeration.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.title});

  final String title;
  static String verify = "";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  Future<void> registerUser() async {
    var regBody = {
      "User_Name": userNameController.text,
      "Phone_Number": phoneController.text,
      "DOB": dobController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 201) {
        print('User added successfully');
        // Navigate to the next screen or show success message
      } else {
        print('Failed to add user: ${response.body}');
        showAlertDialog('Failed to add user: ${jsonDecode(response.body)["message"]}');
      }
    } catch (error) {
      print('Error occurred while registering: $error');
      showAlertDialog('Error occurred while registering: $error');
    }
  }


  String? validateInput(String username, String phone, String dob) {
    if (username.isEmpty) return 'Username is required';
    if (phone.isEmpty) return 'Phone number is required';
    if (dob.isEmpty) return 'Date of Birth is required';
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16.0),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/logoyashwi.png',
                      height: 100,
                      width: 100,
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
                  TextField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter a valid username',
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      icon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefix: Text('+91 | ', style: TextStyle(color: Colors.white)),
                      hintText: 'Enter a valid Phone Number',
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      icon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: dobController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'Enter your Date of Birth',
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      icon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dobController.text = '${pickedDate.toLocal()}'.split(' ')[0];
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "GO BACK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          String? inputValidationMessage = validateInput(
                              userNameController.text,
                              phoneController.text,
                              dobController.text);

                          if (inputValidationMessage != null && inputValidationMessage.isNotEmpty) {
                            showAlertDialog(inputValidationMessage);
                          } else {
                            try {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+91' + phoneController.text,
                                verificationCompleted: (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException ex) {
                                  showAlertDialog('Verification failed. Please try again.');
                                },
                                codeSent: (String verificationId, int? resendToken) {
                                  SignUp.verify = verificationId; // Store verification ID
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTP(verificationId),
                                    ),
                                  );
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                              );
                              await registerUser(); // Register user after verification
                            } catch (ex) {
                              print(ex.toString());
                            }
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
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
