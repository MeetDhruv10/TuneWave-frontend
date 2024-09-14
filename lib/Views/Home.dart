import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunewave/Views/Songs.dart';
import '../Components/Bottomnavbar.dart';
import '../Components/Drawer.dart';
import '../Components/Playlist_Provider.dart';
import '../Components/recent.dart';
import 'Playlist.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  late Timer _timer;
  String greeting = '';

  List<String> artistLinks = [];

  // Function to fetch the artistsLink from the endpoint
  Future<void> fetchArtistLinks() async {
    final url = Uri.parse(
        'http://192.168.0.103:3000/artistsimage'); // Replace with your endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String,dynamic> data = jsonDecode(response.body);

        // Extract 'artistsLink' from the JSON response

        setState(() {
          artistLinks = List<String>.from(data['artistsLinks']);
        });
        print(artistLinks[0]);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching artist links: $error');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchArtistLinks();
    updateGreeting();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      updateGreeting();
    });
  }


  void updateGreeting() {
    setState(() {
      greeting = getGreeting();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void goToSong(int index) {
    final playlistProvider =
    Provider.of<Playlist_Provider>(context, listen: false);
    playlistProvider.currentSongIndex = index;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Songs()),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Generate the list of image URLs dynamically
    final List<String> imageUrls = List.generate(
      artistLinks.length,
          (index) =>
      'https://tunewave-artists-image.s3.ap-south-1.amazonaws.com/${artistLinks[index]}',
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text(
            "$greeting",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.add_box, color: Colors.white),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 150,
                    0.0,
                    0.0,
                    0.0,
                  ),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.add, color: Colors.red),
                        title: Text('Create a new Playlist'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Playlist(title: "")),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black, Colors.black],
            begin: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: recent(),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Songs()));
                  },
                ),
                SizedBox(height: 30),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.blue, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Your favorite artists",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Display the images from S3
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Image.network(
                        imageUrls[index],
                        height: 200, // Set the height you need
                        width: 200,  // Set the width you need
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Your Playlist",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Consumer<Playlist_Provider>(
                  builder: (context, playlistProvider, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlistProvider.Playlist.length,
                      itemBuilder: (context, index) {
                        final song = playlistProvider.Playlist[index];
                        return ListTile(
                          leading: SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Image.asset(
                              song.AlbumArtImagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.SongName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          subtitle: Text(
                            song.ArtistName,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => goToSong(index),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavbar(currentIndex: 0),
    );
  }
}
