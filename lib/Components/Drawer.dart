import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:tunewave/LSO/LoginPage.dart'; // Adjust import as per your file structure
import 'package:tunewave/Views/Profile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

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
              onPressed: () async {
                // Clear user session here (example)
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all saved data

                // Close the dialog
                Navigator.of(context).pop();

                // Navigate to LoginPage and remove all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
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
