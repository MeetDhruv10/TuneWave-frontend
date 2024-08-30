import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tunewave/LSO/LoginPage.dart';
import 'package:tunewave/Views/Profile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Navigate to the LoginPage
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,

      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note_rounded,
                size: 40,
                color: Colors.orange,
              ),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 20.0, 0.0, 0.0),
              child: Tooltip(
                message: 'Profile',
                child: ListTile(
                  title: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                ),
              ),
            ),
          ),
          Divider(color: Colors.white), // White line
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 25.0, 0.0, 0.0),
              child: Tooltip(
                message: 'Settings',
                child: ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
          Divider(color: Colors.white), // White line
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 30.0, 0.0, 0.0),
              child: Tooltip(
                message: 'Log Out',
                child: ListTile(
                  title: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onTap: () {
                    _showLogoutDialog(context); // Show the confirmation dialog
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
