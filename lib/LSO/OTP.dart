import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:tunewave/Views/Home.dart';
import 'Signup.dart';

class OTP extends StatefulWidget {
  final String verificationid;

  OTP(this.verificationid);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("OTP"),
      ),
      body: Center(
          child: //isLoading
          //     ? const CircularProgressIndicator(
          //   color: Colors.white,
          // )
          Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'VERIFY YOUR NUMBER',
                      style: TextStyle(color: Colors.white, fontSize: 30.0),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      onChanged: (value) {
                        code = value;
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUp(title: 'Signup')));
                            },
                            child: Text(
                              "Edit Phone Number?",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          PhoneAuthCredential credential =
                              await PhoneAuthProvider.credential(
                            verificationId: widget.verificationid,
                            smsCode: code, //this will check the otp
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(title: " ")));
                        } catch (ex) {}
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )),
    );
  }
}
