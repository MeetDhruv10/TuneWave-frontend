import 'package:flutter/material.dart';
import '../Components/Bottomnavbar.dart';
import 'Home.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  int myIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Search",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading:IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          tooltip: "GO BACK",
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home(title: 'Home')),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust padding as needed
        child: Column(
          children: [
          TextField(
          controller: searchController,
          cursorColor: Colors.orange,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[800],
            hintText: 'Search a song',
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
        ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavbar(currentIndex: myIndex),
    );
  }
}
