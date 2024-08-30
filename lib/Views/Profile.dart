import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tunewave/Views/Home.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Your Profile")),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home(title:"")));
          },
        ),
      ),
      body: Center(
        child: Text("Profile Page Content"),
      ),
    );
  }
}
