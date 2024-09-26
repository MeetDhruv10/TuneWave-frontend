import 'dart:convert';
import 'package:flutter/material.dart';
import '../Components/Bottomnavbar.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  int myIndex = 1;
  List<dynamic> searchResults = []; // Store search results

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
        leading: IconButton(
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
                hintText: 'Search a song or artist',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              onChanged: (query) {
                searchSongsOrArtists(query);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final item = searchResults[index];
                  return ListTile(
                    title: Text(item['Song_Name'] ?? item['Name'], style: TextStyle(color: Colors.white)),
                    subtitle: Text(item['artist'] ?? '', style: TextStyle(color: Colors.white70)),
                    onTap: () {
                      // Handle item tap, e.g., navigate to song details
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavbar(currentIndex: myIndex),
    );
  }

  Future<void> searchSongsOrArtists(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = []; // Clear results if query is empty
      });
      return;
    }

    // Update with your JavaScript endpoint URL
    final url = Uri.parse('http://192.168.0.105:3000/search');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'searchQuery': query}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['searchresult'];
        setState(() {
          searchResults = data; // Update search results
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (error) {
      print('Error searching: $error');
    }
  }
}
